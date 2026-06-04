// AI生成 - 目的地详情数据和模型
// 云游助手 - 目的地详情信息

import 'package:flutter/material.dart';

/// 目的地详情模型
class DestinationDetail {
  final String name;
  final String description;
  final String bestSeason;
  final String tips;
  final double avgTemp;
  final List<String> highlights;
  final List<RecommendedAttraction> topAttractions;

  DestinationDetail({
    required this.name,
    required this.description,
    required this.bestSeason,
    required this.tips,
    required this.avgTemp,
    required this.highlights,
    required this.topAttractions,
  });
}

/// 推荐景点
class RecommendedAttraction {
  final String name;
  final String brief;
  final IconData icon;
  final String duration;
  final String cost;

  RecommendedAttraction({
    required this.name,
    required this.brief,
    required this.icon,
    required this.duration,
    required this.cost,
  });
}

/// 打包清单分类
class PackingCategory {
  final String name;
  final IconData icon;
  final List<PackingItem> items;

  PackingCategory({required this.name, required this.icon, required this.items});
}

class PackingItem {
  final String name;
  bool checked;

  PackingItem({required this.name, this.checked = false});
}

/// 预算明细项
class BudgetBreakdown {
  final double accommodation; // 住宿
  final double food; // 餐饮
  final double transport; // 交通
  final double tickets; // 门票
  final double other; // 其他

  BudgetBreakdown({
    required this.accommodation,
    required this.food,
    required this.transport,
    required this.tickets,
    required this.other,
  });

  double get total => accommodation + food + transport + tickets + other;
}

/// 目的地详情数据库
class DestinationData {
  static final Map<String, DestinationDetail> details = {
    '三亚': DestinationDetail(
      name: '三亚',
      description: '三亚位于海南岛最南端，是中国唯一的热带滨海旅游城市。拥有碧海蓝天、椰风海韵，被誉为"东方夏威夷"。海水清澈、沙质细腻，是冬季避寒的绝佳去处。',
      bestSeason: '10月-次年4月（气候宜人，避寒首选）',
      tips: '注意防晒！建议携带防晒霜、墨镜、遮阳帽。旺季（春节、国庆）住宿价格翻倍，建议提前1-2个月预订。海鲜市场可以自己买了去加工，性价比高。',
      avgTemp: 25.5,
      highlights: ['热带海滨度假', '潜水冲浪', '海鲜美食', '免税购物'],
      topAttractions: [
        RecommendedAttraction(name: '亚龙湾', brief: '天下第一湾，水清沙白', icon: Icons.beach_access, duration: '半天', cost: '免费'),
        RecommendedAttraction(name: '蜈支洲岛', brief: '中国马尔代夫，潜水胜地', icon: Icons.sailing, duration: '1天', cost: '¥144'),
        RecommendedAttraction(name: '天涯海角', brief: '爱情圣地，浪漫打卡', icon: Icons.favorite, duration: '2-3小时', cost: '¥81'),
        RecommendedAttraction(name: '南山文化旅游区', brief: '108米海上观音像', icon: Icons.temple_buddhist, duration: '4-5小时', cost: '¥121'),
      ],
    ),
    '丽江': DestinationDetail(
      name: '丽江',
      description: '丽江古城是世界文化遗产，纳西族文化的发源地。小桥流水、古巷石路，融合了雪山、古城、古镇、湖泊等多重景观。这里气候温和，四季如春。',
      bestSeason: '3月-10月（春夏最美，避暑好去处）',
      tips: '丽江古城内石板路多，建议穿舒适的平底鞋。高原地区注意防晒和补水。玉龙雪山需提前预订大索道票。古城酒吧街晚上很热闹，但消费较高。',
      avgTemp: 16.0,
      highlights: ['古城漫步', '雪山风光', '纳西文化', '民族美食'],
      topAttractions: [
        RecommendedAttraction(name: '丽江古城', brief: '世界文化遗产，小桥流水', icon: Icons.location_city, duration: '半天', cost: '免费'),
        RecommendedAttraction(name: '玉龙雪山', brief: '纳西族神山', icon: Icons.terrain, duration: '1天', cost: '¥130'),
        RecommendedAttraction(name: '泸沽湖', brief: '东方女儿国', icon: Icons.water, duration: '2天', cost: '¥70'),
        RecommendedAttraction(name: '束河古镇', brief: '茶马古道上的明珠', icon: Icons.landscape, duration: '2-3小时', cost: '免费'),
      ],
    ),
    '北京': DestinationDetail(
      name: '北京',
      description: '北京是中国的首都，拥有三千多年建城史和八百多年建都史。故宫、长城、天坛等世界文化遗产星罗棋布，同时又是一座现代化国际大都市。',
      bestSeason: '3月-5月、9月-11月（春秋最舒适）',
      tips: '北京景点面积大，建议穿舒适运动鞋。故宫需提前7天预约。地铁非常方便，建议下载"亿通行"APP。烤鸭建议去四季民福或大董，不要盲目跟风全聚德。',
      avgTemp: 12.0,
      highlights: ['历史文化', '皇家建筑', '美食之都', '现代都市'],
      topAttractions: [
        RecommendedAttraction(name: '故宫博物院', brief: '紫禁城，世界最大宫殿', icon: Icons.account_balance, duration: '半天', cost: '¥60'),
        RecommendedAttraction(name: '八达岭长城', brief: '万里长城精华段', icon: Icons.construction, duration: '半天', cost: '¥40'),
        RecommendedAttraction(name: '颐和园', brief: '皇家园林博物馆', icon: Icons.park, duration: '3-4小时', cost: '¥30'),
        RecommendedAttraction(name: '天坛', brief: '明清皇帝祭天场所', icon: Icons.church, duration: '2-3小时', cost: '¥34'),
      ],
    ),
    '杭州': DestinationDetail(
      name: '杭州',
      description: '"上有天堂，下有苏杭"。杭州以西湖美景闻名天下，是江南水乡的代表。山水相依、人文荟萃，既有自然之美，又有深厚的历史文化底蕴。',
      bestSeason: '3月-5月、9月-11月（春季西湖最美）',
      tips: '西湖免费开放，建议骑行或步行游览。龙井茶产区的茶农家可以品茶买茶。灵隐寺香火旺盛，建议早上去。宋城千古情演出非常震撼，值得一看。',
      avgTemp: 17.5,
      highlights: ['西湖十景', '茶文化', '江南美食', '佛教文化'],
      topAttractions: [
        RecommendedAttraction(name: '西湖', brief: '人间天堂，世界遗产', icon: Icons.water_drop, duration: '半天', cost: '免费'),
        RecommendedAttraction(name: '灵隐寺', brief: '千年古刹，香火鼎盛', icon: Icons.temple_buddhist, duration: '2-3小时', cost: '¥75'),
        RecommendedAttraction(name: '宋城', brief: '穿越南宋，千年风情', icon: Icons.theater_comedy, duration: '半天', cost: '¥300'),
        RecommendedAttraction(name: '千岛湖', brief: '天下第一秀水', icon: Icons.sailing, duration: '1-2天', cost: '¥130'),
      ],
    ),
    '成都': DestinationDetail(
      name: '成都',
      description: '成都被誉为"天府之国"，是一座来了就不想走的城市。这里有大熊猫、火锅、宽窄巷子，还有悠闲的生活节奏。美食文化享誉全国。',
      bestSeason: '3月-6月、9月-11月（春秋最宜人）',
      tips: '成都美食偏辣，不能吃辣记得说"微辣"。大熊猫基地建议早上一开门就去，熊猫最活跃。火锅推荐小龙坎、大龙燚，串串香推荐马路边边。宽窄巷子适合拍照。',
      avgTemp: 16.5,
      highlights: ['大熊猫', '川菜美食', '三国文化', '慢生活'],
      topAttractions: [
        RecommendedAttraction(name: '大熊猫基地', brief: '国宝大熊猫的故乡', icon: Icons.pets, duration: '半天', cost: '¥55'),
        RecommendedAttraction(name: '宽窄巷子', brief: '最具成都味的老街', icon: Icons.streetview, duration: '2-3小时', cost: '免费'),
        RecommendedAttraction(name: '都江堰', brief: '古代水利工程奇迹', icon: Icons.construction, duration: '半天', cost: '¥90'),
        RecommendedAttraction(name: '锦里古街', brief: '三国蜀汉文化街', icon: Icons.museum, duration: '2-3小时', cost: '免费'),
      ],
    ),
    '厦门': DestinationDetail(
      name: '厦门',
      description: '厦门是一座海上花园城市，清新的空气、干净的海滩、文艺的小巷，处处散发着浪漫气息。鼓浪屿的万国建筑、厦大的青春气息，都让人流连忘返。',
      bestSeason: '3月-5月、10月-12月（气候最舒适）',
      tips: '鼓浪屿船票需提前在公众号购买，建议早上8点前上岛避开人流。厦大需要预约参观。环岛路骑行非常惬意。海鲜大排档推荐小眼镜、阿罗海。',
      avgTemp: 21.0,
      highlights: ['海岛风光', '万国建筑', '文艺小清新', '闽南美食'],
      topAttractions: [
        RecommendedAttraction(name: '鼓浪屿', brief: '海上花园，世界遗产', icon: Icons.sailing, duration: '1天', cost: '免费'),
        RecommendedAttraction(name: '厦门大学', brief: '中国最美大学', icon: Icons.school, duration: '2-3小时', cost: '免费'),
        RecommendedAttraction(name: '环岛路', brief: '最美海岸线骑行', icon: Icons.directions_bike, duration: '2-3小时', cost: '免费'),
        RecommendedAttraction(name: '南普陀寺', brief: '闽南佛教圣地', icon: Icons.temple_buddhist, duration: '1-2小时', cost: '免费'),
      ],
    ),
    '上海': DestinationDetail(
      name: '上海',
      description: '上海是中国的经济中心，一座充满魅力的国际大都市。外滩的万国建筑群、陆家嘴的摩天大楼、弄堂里的老上海风情，构成了魔都的独特魅力。',
      bestSeason: '3月-5月、9月-11月（春秋最舒服）',
      tips: '地铁非常方便，下载"大都会"APP扫码乘车。外滩夜景最美，建议傍晚去。迪士尼建议买早享卡。南京路步行街适合购物，城隍庙吃小吃。',
      avgTemp: 16.0,
      highlights: ['摩天大楼', '外滩夜景', '迪士尼乐园', '海派文化'],
      topAttractions: [
        RecommendedAttraction(name: '外滩', brief: '万国建筑博览', icon: Icons.location_city, duration: '2-3小时', cost: '免费'),
        RecommendedAttraction(name: '迪士尼乐园', brief: '童话王国', icon: Icons.celebration, duration: '1天', cost: '¥399'),
        RecommendedAttraction(name: '东方明珠', brief: '上海地标', icon: Icons.location_city, duration: '2小时', cost: '¥180'),
        RecommendedAttraction(name: '豫园', brief: '江南古典园林', icon: Icons.park, duration: '2小时', cost: '¥40'),
      ],
    ),
    '重庆': DestinationDetail(
      name: '重庆',
      description: '重庆被称为"8D魔幻城市"、"火锅之都"。山城独特的地形造就了轻轨穿楼、洪崖洞等奇观。麻辣鲜香的火锅、小面，让人欲罢不能。',
      bestSeason: '3月-5月、9月-11月（春秋最舒适）',
      tips: '重庆地形复杂，导航容易迷路，建议多问当地人。火锅越老越好吃，推荐佩姐、周师兄。洪崖洞夜景最美，不要门票。长江索道建议早上去人少。',
      avgTemp: 18.5,
      highlights: ['魔幻地形', '火锅美食', '山城夜景', '网红打卡'],
      topAttractions: [
        RecommendedAttraction(name: '洪崖洞', brief: '千与千寻同款夜景', icon: Icons.nightlight_round, duration: '2-3小时', cost: '免费'),
        RecommendedAttraction(name: '长江索道', brief: '山城空中巴士', icon: Icons.airplanemode_active, duration: '30分钟', cost: '¥20'),
        RecommendedAttraction(name: '磁器口古镇', brief: '千年古镇', icon: Icons.landscape, duration: '2-3小时', cost: '免费'),
        RecommendedAttraction(name: '武隆天生三桥', brief: '大自然的鬼斧神工', icon: Icons.terrain, duration: '半天', cost: '¥125'),
      ],
    ),
  };

  static DestinationDetail? getDetail(String cityName) {
    return details[cityName.trim()];
  }

  /// 根据预算等级和天数生成预算明细
  static BudgetBreakdown getBudgetBreakdown(String budget, int days) {
    final base = switch (budget) {
      '经济' => 300.0,
      '舒适' => 600.0,
      '豪华' => 1200.0,
      _ => 500.0,
    };
    return BudgetBreakdown(
      accommodation: base * 0.35 * days,
      food: base * 0.25 * days,
      transport: base * 0.20 * days,
      tickets: base * 0.12 * days,
      other: base * 0.08 * days,
    );
  }

  /// 获取打包清单
  static List<PackingCategory> getPackingList() {
    return [
      PackingCategory(name: '证件类', icon: Icons.credit_card, items: [
        PackingItem(name: '身份证/护照'),
        PackingItem(name: '学生证（有优惠）'),
        PackingItem(name: '驾驶证（如需租车）'),
        PackingItem(name: '机票/火车票（电子版）'),
        PackingItem(name: '酒店预订确认单'),
      ]),
      PackingCategory(name: '衣物类', icon: Icons.checkroom, items: [
        PackingItem(name: '换洗衣物（天数+1套）'),
        PackingItem(name: '外套/防晒衣'),
        PackingItem(name: '舒适运动鞋'),
        PackingItem(name: '拖鞋/凉鞋'),
        PackingItem(name: '泳衣（海边必备）'),
        PackingItem(name: '遮阳帽/太阳镜'),
      ]),
      PackingCategory(name: '洗护类', icon: Icons.cleaning_services, items: [
        PackingItem(name: '牙刷/牙膏'),
        PackingItem(name: '洗面奶/护肤品'),
        PackingItem(name: '防晒霜（SPF50+）'),
        PackingItem(name: '毛巾/浴巾'),
        PackingItem(name: '洗发水/沐浴露（小样）'),
      ]),
      PackingCategory(name: '电子设备', icon: Icons.phone_android, items: [
        PackingItem(name: '手机+充电器'),
        PackingItem(name: '充电宝（20000mAh以内）'),
        PackingItem(name: '耳机'),
        PackingItem(name: '相机/GoPro'),
        PackingItem(name: '转换插头（出境用）'),
      ]),
      PackingCategory(name: '药品类', icon: Icons.medication, items: [
        PackingItem(name: '感冒药'),
        PackingItem(name: '肠胃药（水土不服）'),
        PackingItem(name: '创可贴/消毒棉片'),
        PackingItem(name: '晕车药/防蚊液'),
      ]),
      PackingCategory(name: '其他', icon: Icons.more_horiz, items: [
        PackingItem(name: '雨伞/雨衣'),
        PackingItem(name: '保温杯'),
        PackingItem(name: '零食/干粮'),
        PackingItem(name: '环保袋/收纳袋'),
        PackingItem(name: '旅行枕/眼罩'),
      ]),
    ];
  }
}
