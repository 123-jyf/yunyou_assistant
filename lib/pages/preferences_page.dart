// AI生成 - 偏好设置页面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_preferences.dart';
import '../models/user_preferences_provider.dart';
import '../models/theme_provider.dart';
import '../services/hive_service.dart';

/// 偏好设置页面
class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  late UserPreferences _preferences;
  bool _isLoading = false;

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
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await HiveService.getUserPreferences();
    setState(() {
      _preferences = prefs ?? UserPreferences.defaultPreferences();
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    await HiveService.saveUserPreferences(_preferences);

    // 更新全局状态
    if (mounted) {
      context.read<UserPreferencesProvider>().setPreferences(_preferences);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('设置已保存'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('偏好设置'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _savePreferences,
            child: const Text('保存'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 默认出行天数
                  _buildSection(
                    title: '默认出行天数',
                    icon: Icons.calendar_today,
                    child: Wrap(
                      spacing: 8,
                      children: List.generate(15, (index) {
                        final day = index + 1;
                        final isSelected = _preferences.defaultDays == day;
                        return ChoiceChip(
                          label: Text('$day天'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _preferences.defaultDays = day;
                              });
                            }
                          },
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 默认预算
                  _buildSection(
                    title: '默认预算',
                    icon: Icons.attach_money,
                    child: Wrap(
                      spacing: 8,
                      children: _budgetOptions.map((budget) {
                        final isSelected = _preferences.defaultBudget == budget;
                        return ChoiceChip(
                          label: Text(budget),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _preferences.defaultBudget = budget;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 兴趣偏好
                  _buildSection(
                    title: '兴趣偏好',
                    icon: Icons.interests,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _interestOptions.map((interest) {
                        final isSelected = _preferences.interests.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _preferences.interests.add(interest);
                              } else {
                                _preferences.interests.remove(interest);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 出行人群
                  _buildSection(
                    title: '默认出行人群',
                    icon: Icons.people,
                    child: Wrap(
                      spacing: 8,
                      children: _peopleOptions.map((people) {
                        final isSelected = _preferences.defaultPeople == people;
                        return ChoiceChip(
                          label: Text(people),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _preferences.defaultPeople = people;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 深色模式开关
                  _buildSection(
                    title: '深色模式',
                    icon: Icons.dark_mode,
                    child: SwitchListTile(
                      title: const Text('开启深色模式'),
                      subtitle: const Text('全局应用深色主题'),
                      value: _preferences.darkMode,
                      onChanged: (value) {
                        setState(() {
                          _preferences.darkMode = value;
                        });
                        // 实时更新主题
                        context.read<ThemeProvider>().setDarkMode(value);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 保存按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePreferences,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '保存设置',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
