// 人工优化 - 行程生成页面（重构AI生成逻辑）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/travel_plan_provider.dart';
import '../models/user_preferences_provider.dart';
import '../services/ai_service.dart';
import '../services/hive_service.dart';
import 'detail_page.dart';

/// 行程生成页面
class CreatePage extends StatefulWidget {
  final String? initialDestination;

  const CreatePage({super.key, this.initialDestination});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _destinationController = TextEditingController();
  int _days = 3;
  String _budget = '舒适';
  List<String> _interests = ['自然风光', '美食'];
  String _people = '情侣';
  bool _isGenerating = false;

  // 预算选项
  final List<String> _budgetOptions = ['经济', '舒适', '豪华'];
  // 兴趣选项
  final List<String> _interestOptions = ['美食', '自然风光', '人文历史', '休闲购物'];
  // 出行人群选项
  final List<String> _peopleOptions = ['单人', '情侣', '家庭', '朋友'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    if (widget.initialDestination != null) {
      _destinationController.text = widget.initialDestination!;
    }
  }

  Future<void> _loadPreferences() async {
    final prefsProvider = context.read<UserPreferencesProvider>();
    await prefsProvider.loadPreferences();
    final prefs = prefsProvider.preferences;

    setState(() {
      _days = prefs.defaultDays;
      _budget = prefs.defaultBudget;
      _interests = List.from(prefs.interests);
      _people = prefs.defaultPeople;
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  /// 生成行程
  Future<void> _generateTrip() async {
    final destination = _destinationController.text.trim();

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入目的地'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // 调用AI服务生成行程
      final plan = await AIService.generateTrip(
        destination: destination,
        days: _days,
        budget: _budget,
        interests: _interests,
        people: _people,
      );

      // 保存到历史记录
      await HiveService.saveHistoryPlan(plan);

      // 更新全局状态
      if (mounted) {
        context.read<TravelPlanProvider>().addHistory(plan);
        context.read<TravelPlanProvider>().setCurrentPlan(plan);

        // 跳转到详情页
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DetailPage(planId: plan.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('生成失败: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('生成行程'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 目的地输入
            Text(
              '目的地',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: '请输入目的地（如：三亚、丽江等）',
                prefixIcon: const Icon(Icons.location_on),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 出行天数
            Text(
              '出行天数',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _days > 1
                        ? () => setState(() => _days--)
                        : null,
                  ),
                  Text(
                    '$_days 天',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _days < 15
                        ? () => setState(() => _days++)
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 预算选择
            Text(
              '预算',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _budgetOptions.map((budget) {
                return ChoiceChip(
                  label: Text(budget),
                  selected: _budget == budget,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _budget = budget;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 兴趣偏好
            Text(
              '兴趣偏好',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interestOptions.map((interest) {
                final isSelected = _interests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _interests.add(interest);
                      } else {
                        _interests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 出行人群
            Text(
              '出行人群',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _peopleOptions.map((people) {
                return ChoiceChip(
                  label: Text(people),
                  selected: _people == people,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _people = people;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // 生成按钮
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: _isGenerating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'AI正在生成行程...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome),
                          SizedBox(width: 8),
                          Text(
                            '生成AI行程',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
