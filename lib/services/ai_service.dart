// AI生成 + 人工优化 - 接入DeepSeek API生成行程
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import '../models/travel_plan.dart';
import '../models/day_plan.dart';
import '../models/attraction.dart';

/// AI行程生成服务（接入DeepSeek）
class AIService {
  static final Random _random = Random();
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.deepseek.com',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Authorization': 'Bearer sk-1839b8c6348e4fa0b9dbaee3bba8a0e6',
      'Content-Type': 'application/json',
    },
  ));

  /// 预算基数（每天的基准花费，用于fallback）
  static final Map<String, int> _budgetBase = {
    '经济': 200,
    '舒适': 500,
    '豪华': 1200,
  };

  /// 根据参数调用DeepSeek生成行程
  /// 失败时自动fallback到模拟数据
  static Future<TravelPlan> generateTrip({
    required String destination,
    required int days,
    required String budget,
    required List<String> interests,
    required String people,
  }) async {
    final cleanDest = destination.trim();

    try {
      // 1. 尝试调用DeepSeek API
      return await _generateWithDeepSeek(
        destination: cleanDest,
        days: days,
        budget: budget,
        interests: interests,
        people: people,
      );
    } catch (e) {
      // 2. API失败，fallback到模拟数据
      print('[AIService] DeepSeek API failed: $e, falling back to mock');
      return _generateMockTrip(
        destination: cleanDest,
        days: days,
        budget: budget,
        interests: interests,
        people: people,
      );
    }
  }

  /// 调用DeepSeek API生成行程
  static Future<TravelPlan> _generateWithDeepSeek({
    required String destination,
    required int days,
    required String budget,
    required List<String> interests,
    required String people,
  }) async {
    // 构建system prompt
    final systemPrompt = '''
你是一个专业的旅行规划AI助手。请根据用户的需求生成一份详细的旅行行程计划。
你必须严格按照以下JSON格式返回结果（只返回JSON，不要任何其他文字）：

{
  "destination": "目的地名称",
  "days": 天数,
  "budget": "预算等级",
  "totalBudget": "总预算预估，格式如'¥3000'",
  "interests": ["兴趣标签"],
  "people": "出行人群",
  "dayPlans": [
    {
      "day": 1,
      "attractions": [
        {
          "name": "景点名称",
          "description": "景点简短描述，15字以内",
          "openTime": "开放时间",
          "cost": "门票价格",
          "duration": "建议游玩时长",
          "rating": 4.5
        }
      ]
    }
  ]
}

要求：
- 每天安排2-3个景点
- 景点必须是真实的、存在的
- 按照合理的游玩路线安排顺序
- description控制在15字以内
- rating在3.5-5.0之间
- 根据预算等级调整推荐景点的档次
''';

    // 构建user prompt
    final userPrompt = '''
请为我的旅行生成一份行程计划：
- 目的地：$destination
- 天数：$days 天
- 预算等级：$budget
- 兴趣偏好：${interests.join('、')}
- 出行人群：$people

请严格按照JSON格式返回。''';

    // 调用DeepSeek API
    final response = await _dio.post('/v1/chat/completions', data: {
      'model': 'deepseek-chat',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'temperature': 0.8,
      'max_tokens': 4096,
    });

    if (response.statusCode != 200) {
      throw Exception('API返回错误: ${response.statusCode}');
    }

    // 解析返回内容
    final data = response.data as Map<String, dynamic>;
    final choices = data['choices'] as List;
    if (choices.isEmpty) {
      throw Exception('API返回为空');
    }

    final message = choices[0]['message'] as Map<String, dynamic>;
    final content = message['content'] as String;

    // 提取JSON（处理可能被markdown代码块包裹的情况）
    final jsonStr = _extractJson(content);
    final planData = jsonDecode(jsonStr) as Map<String, dynamic>;

    // 转换为TravelPlan对象
    return _parsePlanFromJson(planData, destination, days, budget, interests, people);
  }

  /// 从文本中提取JSON（处理markdown代码块）
  static String _extractJson(String text) {
    // 尝试匹配 ```json ... ``` 代码块
    final codeBlockMatch = RegExp(r'```(?:json)?\s*\n?([\s\S]*?)\n?```').firstMatch(text);
    if (codeBlockMatch != null) {
      return codeBlockMatch.group(1)!.trim();
    }
    // 尝试匹配 {...} 最外层大括号
    final braceMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (braceMatch != null) {
      return braceMatch.group(0)!;
    }
    return text;
  }

  /// 解析JSON到TravelPlan
  static TravelPlan _parsePlanFromJson(
    Map<String, dynamic> data,
    String destination,
    int days,
    String budget,
    List<String> interests,
    String people,
  ) {
    final dayPlans = <DayPlan>[];
    final rawDayPlans = data['dayPlans'] as List? ?? [];

    for (int i = 0; i < rawDayPlans.length; i++) {
      final dayData = rawDayPlans[i] as Map<String, dynamic>;
      final rawAttractions = dayData['attractions'] as List? ?? [];
      final attractions = <Attraction>[];

      for (int j = 0; j < rawAttractions.length; j++) {
        final attr = rawAttractions[j] as Map<String, dynamic>;
        attractions.add(Attraction(
          id: 'attr_${i + 1}_$j',
          name: attr['name']?.toString() ?? '景点${j + 1}',
          description: attr['description']?.toString() ?? '',
          image: _getCityImage(destination, j),
          openTime: attr['openTime']?.toString() ?? '全天开放',
          cost: attr['cost']?.toString() ?? '免费',
          rating: (attr['rating'] as num?)?.toDouble() ?? 4.5,
          duration: attr['duration']?.toString() ?? '2小时',
        ));
      }

      if (attractions.isNotEmpty) {
        dayPlans.add(DayPlan(day: dayData['day'] as int? ?? (i + 1), attractions: attractions));
      }
    }

    // 如果AI没有返回足够的天数，补全天数
    while (dayPlans.length < days) {
      dayPlans.add(DayPlan(day: dayPlans.length + 1, attractions: []));
    }

    final totalBudget = data['totalBudget']?.toString() ?? '¥${(_budgetBase[budget] ?? 500) * days}';

    return TravelPlan(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      destination: destination,
      days: days,
      budget: budget,
      interests: interests,
      people: people,
      totalBudget: totalBudget,
      createTime: DateTime.now(),
      dayPlans: dayPlans,
    );
  }

  /// ====== Fallback: 模拟数据生成 ======

  /// 城市图片缓存
  static final Map<String, List<String>> _cityImages = {
    '三亚': ['https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400'],
    '丽江': ['https://images.unsplash.com/photo-1528181304800-259b08848526?w=400'],
    '北京': ['https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=400'],
    '杭州': ['https://images.unsplash.com/photo-1598887142487-3c854d51eabb?w=400'],
    '成都': ['https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=400'],
    '厦门': ['https://images.unsplash.com/photo-1569709334729-f50f4a8a6652?w=400'],
    '上海': ['https://images.unsplash.com/photo-1543362322-3d5ed8a08f16?w=400'],
    '重庆': ['https://images.unsplash.com/photo-1543362322-3d5ed8a08f16?w=400'],
    '美国': ['https://images.unsplash.com/photo-1500917293891-ef4fc5e5e8f0?w=400'],
    '纽约': ['https://images.unsplash.com/photo-1500917293891-ef4fc5e5e8f0?w=400'],
    '日本': ['https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?w=400'],
    '东京': ['https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?w=400'],
    '泰国': ['https://images.unsplash.com/photo-1550355291-bbee06a71f32?w=400'],
    '巴黎': ['https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400'],
    '法国': ['https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400'],
    '伦敦': ['https://images.unsplash.com/photo-1502685106426-123d1df5f68a?w=400'],
    '韩国': ['https://images.unsplash.com/photo-1528143358888-6d3c7f67bd5d?w=400'],
    '新加坡': ['https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=400'],
    '澳大利亚': ['https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=400'],
    '马尔代夫': ['https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=400'],
  };

  static String _getCityImage(String city, int index) {
    final images = _cityImages[city];
    if (images != null && images.isNotEmpty) {
      return images[index % images.length];
    }
    return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400';
  }

  /// Fallback：用模拟数据生成
  static Future<TravelPlan> _generateMockTrip({
    required String destination,
    required int days,
    required String budget,
    required List<String> interests,
    required String people,
  }) async {
    // 模拟延迟
    await Future.delayed(Duration(seconds: 1 + _random.nextInt(1)));

    final baseBudget = _budgetBase[budget] ?? 500;
    final totalBudget = baseBudget * days;

    // 生成每日行程
    final dayPlans = <DayPlan>[];
    for (int day = 1; day <= days; day++) {
      final attractions = <Attraction>[
        Attraction(
          id: 'mock_${day}_1',
          name: '推荐景点A',
          description: '当地热门打卡地',
          image: _getCityImage(destination, 0),
          openTime: '08:00-18:00',
          cost: '免费',
          rating: 4.5 + (_random.nextDouble() - 0.5) * 0.5,
          duration: '3-4小时',
        ),
        Attraction(
          id: 'mock_${day}_2',
          name: '推荐景点B',
          description: '不容错过的体验',
          image: _getCityImage(destination, 1),
          openTime: '09:00-17:00',
          cost: budget == '经济' ? '¥30' : budget == '舒适' ? '¥60' : '¥120',
          rating: 4.3 + (_random.nextDouble() - 0.5) * 0.5,
          duration: '2-3小时',
        ),
      ];
      dayPlans.add(DayPlan(day: day, attractions: attractions));
    }

    return TravelPlan(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      destination: destination,
      days: days,
      budget: budget,
      interests: interests,
      people: people,
      totalBudget: '¥$totalBudget',
      createTime: DateTime.now(),
      dayPlans: dayPlans,
    );
  }

  /// 获取支持的所有目的地（含fallback城市）
  static List<String> getSupportedCities() {
    return _cityImages.keys.toList();
  }

  /// 检查城市是否支持
  static bool isCitySupported(String city) {
    // DeepSeek支持任何目的地，所以总是返回true
    return true;
  }
}
