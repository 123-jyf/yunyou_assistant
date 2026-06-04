// AI生成 - 目的地详情页面
import 'package:flutter/material.dart';
import '../models/destination_data.dart';

/// 目的地详情页面
class DestinationDetailPage extends StatelessWidget {
  final String cityName;

  const DestinationDetailPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final detail = DestinationData.getDetail(cityName);

    if (detail == null) {
      return Scaffold(
        appBar: AppBar(title: Text(cityName)),
        body: const Center(child: Text('暂无该城市详情')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, detail),
          SliverToBoxAdapter(child: _buildBody(context, detail)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, DestinationDetail detail) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Icon(Icons.travel_explore, size: 200, color: Colors.white.withAlpha(30)),
              ),
            ],
          ),
        ),
        title: Text(detail.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context, DestinationDetail detail) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 温度概览
          _buildTempCard(theme, detail),
          const SizedBox(height: 16),

          // 城市简介
          _buildSectionTitle(theme, '城市简介', Icons.info_outline),
          const SizedBox(height: 8),
          Text(detail.description, style: TextStyle(fontSize: 14, height: 1.6, color: theme.colorScheme.onSurface.withValues(alpha: 0.8))),
          const SizedBox(height: 20),

          // 最佳季节
          _buildSectionTitle(theme, '最佳旅行季节', Icons.calendar_month),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              const Icon(Icons.wb_sunny, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Expanded(child: Text(detail.bestSeason, style: const TextStyle(fontSize: 14, color: Colors.green))),
            ]),
          ),
          const SizedBox(height: 20),

          // 特色亮点
          _buildSectionTitle(theme, '特色亮点', Icons.star),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: detail.highlights.map((h) => Chip(
              avatar: const Icon(Icons.check, size: 16, color: Colors.green),
              label: Text(h),
              backgroundColor: Colors.green.withAlpha(20),
            )).toList(),
          ),
          const SizedBox(height: 20),

          // 推荐景点
          _buildSectionTitle(theme, '热门景点', Icons.place),
          const SizedBox(height: 8),
          ...detail.topAttractions.map((a) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a.icon, color: theme.colorScheme.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(a.brief, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Row(children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 2),
                    Text(a.duration, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    const SizedBox(width: 12),
                    Text(a.cost, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade400)),
                  ]),
                ])),
              ]),
            ),
          )),
          const SizedBox(height: 20),

          // 旅行贴士
          _buildSectionTitle(theme, '旅行贴士', Icons.lightbulb_outline),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withAlpha(40)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.lightbulb, color: Colors.amber.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(detail.tips, style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey.shade700))),
            ]),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTempCard(ThemeData theme, DestinationDetail detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.red.shade400]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wb_sunny, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('年均气温', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${detail.avgTemp}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)),
                const Padding(padding: EdgeInsets.only(bottom: 4), child: Text('°C', style: TextStyle(fontSize: 14))),
              ]),
              Text('气候宜人，适合旅行', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Row(children: [
      Icon(icon, size: 20, color: theme.colorScheme.primary),
      const SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
    ]);
  }
}
