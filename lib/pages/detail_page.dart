// 人工优化 - 行程详情页面（修复动态渲染）
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:intl/intl.dart';
import '../models/travel_plan.dart';
import '../models/travel_plan_provider.dart';
import '../services/hive_service.dart';
import 'create_page.dart';
import 'packing_list_page.dart';
import '../models/destination_data.dart';

/// 行程详情页
class DetailPage extends StatefulWidget {
  final String? planId;

  const DetailPage({super.key, this.planId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TravelPlan? _plan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.planId != null) {
      // 从历史记录中查找
      final historyPlans = HiveService.getHistoryPlans();
      _plan = historyPlans.firstWhere(
        (p) => p.id == widget.planId,
        orElse: () => historyPlans.isNotEmpty ? historyPlans.first : _createDefaultPlan(),
      );
    } else {
      // 从全局状态获取当前行程
      final provider = Provider.of<TravelPlanProvider>(context, listen: false);
      _plan = provider.currentPlan;
    }

    setState(() {
      _isLoading = false;
    });
  }

  TravelPlan _createDefaultPlan() {
    return TravelPlan(
      id: 'default',
      destination: '示例行程',
      days: 3,
      budget: '舒适',
      interests: ['自然风景', '美食'],
      people: '情侣',
      totalBudget: '¥5,000',
      createTime: DateTime.now(),
      dayPlans: [],
    );
  }

  /// 分享行程
  Future<void> _sharePlan() async {
    if (_plan == null) return;

    final shareText = _generateShareText();

    try {
      await Share.share(
        shareText,
        subject: '${_plan!.destination}行程分享',
      );
    } catch (e) {
      // Web端不支持原生分享，弹窗显示
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('分享行程'),
            content: SingleChildScrollView(
              child: SelectableText(shareText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: shareText));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已复制到剪贴板'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('复制'),
              ),
            ],
          ),
        );
      }
    }
  }

  String _generateShareText() {
    if (_plan == null) return '';

    final buffer = StringBuffer();
    buffer.writeln('📍 ${_plan!.destination}旅行计划');
    buffer.writeln('📅 ${_plan!.days}天${_plan!.days - 1}晚');
    buffer.writeln('💰 预算: ${_plan!.totalBudget}');
    buffer.writeln('👥 ${_plan!.people}');
    buffer.writeln('');
    buffer.writeln('【每日行程】');

    for (final dayPlan in _plan!.dayPlans) {
      buffer.writeln('');
      buffer.writeln('Day ${dayPlan.day}:');
      for (final attraction in dayPlan.attractions) {
        buffer.writeln('• ${attraction.name} (${attraction.duration})');
      }
    }

    buffer.writeln('');
    buffer.writeln('由云游助手AI生成 ✨');

    return buffer.toString();
  }

  /// 导出行程
  Future<void> _exportPlan() async {
    if (_plan == null) return;

    final exportText = _generateShareText();

    await Clipboard.setData(ClipboardData(text: exportText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('行程已复制到剪贴板'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 编辑行程
  void _editPlan() {
    if (_plan == null) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CreatePage(
          initialDestination: _plan!.destination,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('行程详情')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('行程详情')),
        body: const Center(child: Text('未找到行程')),
      );
    }

    final isFav = HiveService.isFavorite(_plan!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(_plan!.destination),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
            onPressed: () async {
              await HiveService.toggleFavorite(_plan!);
              setState(() {});
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFav ? '已取消收藏' : '已添加收藏'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 行程概览
            _buildOverview(theme),

            const SizedBox(height: 20),

            // 预算明细
            _buildBudgetSection(theme),

            const SizedBox(height: 20),

            // 每日行程
            _buildDayPlans(theme),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildBottomActions(theme),
    );
  }

  Widget _buildOverview(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primary.withOpacity(0.3),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _plan!.destination,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.calendar_today,
                label: '${_plan!.days}天${_plan!.days - 1}晚',
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.attach_money,
                label: _plan!.budget,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.people,
                label: _plan!.people,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '预估预算',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      _plan!.totalBudget,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  /// 预算明细
  Widget _buildBudgetSection(ThemeData theme) {
    if (_plan == null) return const SizedBox.shrink();
    final budget = DestinationData.getBudgetBreakdown(_plan!.budget, _plan!.days);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.account_balance_wallet, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text('预算明细', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                const Spacer(),
                Text('${_plan!.budget}出行', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ]),
              const SizedBox(height: 16),
              _buildBudgetRow('🏨 住宿', budget.accommodation, Colors.blue, budget.total),
              _buildBudgetRow('🍜 餐饮', budget.food, Colors.orange, budget.total),
              _buildBudgetRow('🚗 交通', budget.transport, Colors.green, budget.total),
              _buildBudgetRow('🎫 门票', budget.tickets, Colors.purple, budget.total),
              _buildBudgetRow('📦 其他', budget.other, Colors.grey, budget.total),
              const Divider(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('合计', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                Text('¥${budget.total.toStringAsFixed(0)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PackingListPage(destination: _plan!.destination),
                      ),
                    );
                  },
                  icon: const Icon(Icons.checklist, size: 18),
                  label: const Text('查看打包清单'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetRow(String label, double amount, Color color, double total) {
    final ratio = total > 0 ? amount / total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text('¥${amount.toStringAsFixed(0)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Text('${(ratio * 100).toInt()}%', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildDayPlans(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '每日行程',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_plan!.dayPlans.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('暂无行程详情'),
              ),
            )
          else
            ..._plan!.dayPlans.map((dayPlan) {
              return _buildDayPlanCard(dayPlan, theme);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildDayPlanCard(dynamic dayPlan, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'D${dayPlan.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '第${dayPlan.day}天',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...dayPlan.attractions.map<Widget>((attraction) {
              return _buildAttractionCard(attraction, theme);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttractionCard(dynamic attraction, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: attraction.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attraction.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        attraction.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _sharePlan,
                icon: const Icon(Icons.share),
                label: const Text('分享'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _exportPlan,
                icon: const Icon(Icons.description),
                label: const Text('导出'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _editPlan,
                icon: const Icon(Icons.edit),
                label: const Text('编辑'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
