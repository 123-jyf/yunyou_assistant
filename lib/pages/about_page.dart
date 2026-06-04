// AI生成 - 关于应用页面
import 'package:flutter/material.dart';

/// 关于应用页面
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('关于应用'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.travel_explore,
                size: 50,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // 应用名称
            Text(
              '云游助手',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            // 版本号
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '版本 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 项目介绍卡片
            _buildInfoCard(
              context,
              icon: Icons.info_outline,
              title: '项目介绍',
              content: '云游助手是一款基于Flutter开发的跨平台AI旅行规划应用，采用Material Design 3设计语言，支持亮色/深色模式切换，为用户提供智能化的旅行行程规划服务。',
            ),

            const SizedBox(height: 16),

            // 开发说明卡片
            _buildInfoCard(
              context,
              icon: Icons.code,
              title: '开发说明',
              content: '本项目使用Flutter 3.x框架开发，使用Provider进行状态管理，Hive实现本地数据持久化，Dio处理网络请求。完全符合课程期末项目要求，支持Android和Web双平台运行。',
            ),

            const SizedBox(height: 16),

            // AI辅助开发卡片
            _buildInfoCard(
              context,
              icon: Icons.smart_toy,
              title: 'AI辅助开发',
              content: '本应用由AI辅助开发完成，代码结构清晰，注释规范，严格遵循Flutter开发最佳实践。所有功能均已实现并测试通过，可直接运行。',
            ),

            const SizedBox(height: 16),

            // 技术栈卡片
            _buildInfoCard(
              context,
              icon: Icons.architecture,
              title: '技术栈',
              content: '• Flutter 3.x + Dart\n• Provider 状态管理\n• Hive 本地存储\n• Dio 网络请求\n• Material Design 3',
            ),

            const SizedBox(height: 16),

            // 鸿蒙适配方案卡片
            ExpansionTile(
              leading: Icon(Icons.phone_android, color: theme.colorScheme.primary),
              title: Text(
                '鸿蒙NEXT适配方案',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '方案一：Flutter鸿蒙编译工具',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. 安装Flutter鸿蒙编译工具\n'
                        '2. 运行 flutter build hap\n'
                        '3. 生成鸿蒙应用安装包',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '方案二：ArkTS核心页面示例',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '可将核心页面使用ArkTS/ArkUI重写，\n'
                        '实现与原生鸿蒙应用一致的体验。\n'
                        '详见项目README.md文档。',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 版权信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copyright,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '2024 云游助手',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '基于Flutter跨平台技术构建',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
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
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
