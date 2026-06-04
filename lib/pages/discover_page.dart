// AI生成 - 发现页：旅行灵感、攻略推荐、热门路线（修复分类筛选）
import 'package:flutter/material.dart';
import 'create_page.dart';
import 'packing_list_page.dart';
import 'travel_tips_page.dart';

/// 发现页面 - 旅行灵感和攻略
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String _selectedCategory = '热门推荐';
  final List<String> _categories = ['热门推荐', '国内游', '境外游', '亲子游', '蜜月游', '穷游'];

  // 路线数据
  final List<Map<String, dynamic>> _routes = [
    {'dest': '三亚', 'title': '三亚5天4晚度假游', 'tag': '海滨度假', 'rating': '4.8', 'price': '¥2500', 'cats': ['热门推荐', '国内游', '亲子游']},
    {'dest': '成都', 'title': '成都重庆6天美食之旅', 'tag': '美食之旅', 'rating': '4.7', 'price': '¥2000', 'cats': ['热门推荐', '国内游']},
    {'dest': '日本', 'title': '日本关西7日深度游', 'tag': '境外游', 'rating': '4.9', 'price': '¥8000', 'cats': ['热门推荐', '境外游']},
    {'dest': '泰国', 'title': '泰国曼谷芭提雅5日游', 'tag': '境外游', 'rating': '4.6', 'price': '¥3500', 'cats': ['境外游', '蜜月游']},
    {'dest': '丽江', 'title': '丽江大理5天文艺之旅', 'tag': '古城游', 'rating': '4.7', 'price': '¥2800', 'cats': ['国内游', '蜜月游']},
    {'dest': '北京', 'title': '北京4天历史文化游', 'tag': '文化游', 'rating': '4.8', 'price': '¥3000', 'cats': ['国内游', '亲子游']},
    {'dest': '马尔代夫', 'title': '马尔代夫6天蜜月之旅', 'tag': '海岛游', 'rating': '4.9', 'price': '¥15000', 'cats': ['境外游', '蜜月游']},
    {'dest': '新加坡', 'title': '新加坡4天亲子游', 'tag': '亲子游', 'rating': '4.7', 'price': '¥6000', 'cats': ['境外游', '亲子游']},
    {'dest': '杭州', 'title': '杭州3天周末游', 'tag': '周边游', 'rating': '4.6', 'price': '¥1500', 'cats': ['国内游', '穷游']},
    {'dest': '重庆', 'title': '重庆3天网红打卡游', 'tag': '穷游', 'rating': '4.5', 'price': '¥1200', 'cats': ['国内游', '穷游']},
  ];

  // 攻略数据
  final List<Map<String, dynamic>> _allTips = [
    {'icon': Icons.checklist, 'title': '出行打包清单', 'desc': '再也不怕忘带东西', 'color': Colors.green, 'cat': 'season'},
    {'icon': Icons.wb_sunny, 'title': '最佳旅行季节', 'desc': '什么时候去最合适', 'color': Colors.orange, 'cat': 'season'},
    {'icon': Icons.lightbulb, 'title': '省钱攻略', 'desc': '聪明旅行小技巧', 'color': Colors.blue, 'cat': 'budget'},
    {'icon': Icons.security, 'title': '安全出行指南', 'desc': '旅行安全注意事项', 'color': Colors.red, 'cat': 'safety'},
  ];

  List<Map<String, dynamic>> get _filteredRoutes {
    if (_selectedCategory == '热门推荐') return _routes;
    return _routes.where((r) => (r['cats'] as List).contains(_selectedCategory)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: _DestinationSearchDelegate());
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部分类标签（已修复：可以交互筛选）
            _buildCategoryChips(theme),
            const SizedBox(height: 20),

            // 精选推荐（只有"热门推荐"时显示）
            if (_selectedCategory == '热门推荐') ...[
              Text('精选推荐', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              _buildFeaturedCard(context, theme),
              const SizedBox(height: 20),
            ],

            // 热门路线（按分类筛选）
            Text('推荐路线', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 12),

            if (_filteredRoutes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(child: Column(children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('暂无相关推荐', style: TextStyle(color: Colors.grey.shade400)),
                ])),
              )
            else
              ..._filteredRoutes.map((r) => _buildRouteCard(context, theme, r)),

            const SizedBox(height: 20),

            // 旅行攻略
            if (_selectedCategory == '热门推荐') ...[
              Text('旅行攻略', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ..._allTips.map((t) => _buildTipCard(context, theme, t)),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((c) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(c),
            onPressed: () => setState(() => _selectedCategory = c),
            backgroundColor: c == _selectedCategory ? theme.colorScheme.primaryContainer : null,
            side: c == _selectedCategory ? BorderSide(color: theme.colorScheme.primary) : BorderSide.none,
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, ThemeData theme) {
    return Container(
      height: 200, width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.purple.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage(initialDestination: '云南'))),
        child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withAlpha(40), borderRadius: BorderRadius.circular(12)),
            child: const Text('编辑推荐', style: TextStyle(color: Colors.white, fontSize: 11))),
          const SizedBox(height: 12),
          const Text('云南·大理丽江5日游', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('风花雪月 · 邂逅最美云南', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.star, color: Colors.amber, size: 16), const SizedBox(width: 4),
            Text('4.9', style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 13)),
            const SizedBox(width: 16),
            const Icon(Icons.people, color: Colors.white70, size: 16), const SizedBox(width: 4),
            Text('2345人收藏', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12)),
          ]),
        ])),
      )),
    );
  }

  Widget _buildRouteCard(BuildContext context, ThemeData theme, Map<String, dynamic> r) {
    return Card(margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePage(initialDestination: r['dest']!))),
        child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
          Container(width: 60, height: 60,
            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.travel_explore, color: theme.colorScheme.primary, size: 30)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.blue.withAlpha(20), borderRadius: BorderRadius.circular(4)),
                child: Text(r['tag']!, style: TextStyle(color: Colors.blue.shade600, fontSize: 11))),
              const SizedBox(width: 8),
              Icon(Icons.star, size: 12, color: Colors.amber),
              Text(' ${r['rating']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ]),
          ])),
          Text(r['price']!, style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold, fontSize: 16)),
        ])),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, ThemeData theme, Map<String, dynamic> t) {
    return Card(margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (t['title'] == '出行打包清单') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PackingListPage()));
          } else if (t['title'] == '最佳旅行季节') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TravelTipsPage(category: 'season')));
          } else if (t['title'] == '省钱攻略') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TravelTipsPage(category: 'budget')));
          } else if (t['title'] == '安全出行指南') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TravelTipsPage(category: 'safety')));
          }
        },
        child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
          Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: (t['color'] as Color).withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            Text(t['desc'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ])),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ])),
      ),
    );
  }
}

/// 目的地搜索委托
class _DestinationSearchDelegate extends SearchDelegate<String?> {
  final List<String> _allDestinations = [
    '北京', '上海', '三亚', '丽江', '杭州', '成都', '厦门', '重庆',
    '日本', '东京', '泰国', '巴黎', '法国', '伦敦', '韩国', '新加坡',
    '美国', '纽约', '澳大利亚', '马尔代夫', '云南', '大理', '西安', '桂林',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = query.isEmpty
        ? _allDestinations
        : _allDestinations.where((d) => d.contains(query)).toList();

    if (results.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text('未找到相关内容', style: TextStyle(color: Colors.grey.shade500)),
      ]));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(results[i]),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          close(context, results[i]);
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => const CreatePage(), // 这里可以传initialDestination
          ));
        },
      ),
    );
  }
}