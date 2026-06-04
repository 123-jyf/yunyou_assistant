// 人工优化 - 首页 + 底部导航Tab切换（修复跳转后导航栏消失）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';
import '../services/ai_service.dart';
import 'create_page.dart';
import 'mine_page.dart';
import 'discover_page.dart';
import 'packing_list_page.dart';

/// 主页面 - 包含底部Tab导航
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      _HomeTab(),
      DiscoverPage(),
      CreatePage(),
      MinePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: '发现'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: '生成'),
          NavigationDestination(icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

// ═══════════ 首页Tab内容 ═══════════
class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  int _currentBannerIndex = 0;

  static const Map<String, String> _cityImages = {
    '三亚': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
    '丽江': 'https://images.unsplash.com/photo-1528181304800-259b08848526?w=600',
    '北京': 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=600',
    '杭州': 'https://images.unsplash.com/photo-1598887142487-3c854d51eabb?w=600',
    '成都': 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=600',
    '厦门': 'https://images.unsplash.com/photo-1569709334729-f50f4a8a6652?w=600',
  };

  final List<Map<String, String>> _banners = [
    {'title': '春季特惠', 'subtitle': '热门目的地5折起', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'},
    {'title': '五一黄金周', 'subtitle': '提前规划享优惠', 'image': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800'},
    {'title': 'AI智能规划', 'subtitle': '一键生成专属行程', 'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800'},
  ];

  final List<Map<String, dynamic>> _hotDestinations = [
    {'name': '三亚', 'desc': '热带海滨', 'rating': '4.9'},
    {'name': '丽江', 'desc': '古城风情', 'rating': '4.8'},
    {'name': '北京', 'desc': '古都文化', 'rating': '4.9'},
    {'name': '杭州', 'desc': '西湖美景', 'rating': '4.8'},
    {'name': '成都', 'desc': '美食天堂', 'rating': '4.7'},
    {'name': '厦门', 'desc': '海上花园', 'rating': '4.8'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchDestination() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _showSnack('请输入目的地');
      return;
    }
    if (AIService.isCitySupported(query)) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CreatePage(initialDestination: query),
      ));
    } else {
      _showSnack('暂不支持"$query"城市，请选择其他目的地');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  void _showCityList() {
    final cities = AIService.getSupportedCities();
    showModalBottomSheet(context: context, builder: (ctx) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('支持的目的地', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8,
          children: cities.map((c) => ActionChip(label: Text(c), onPressed: () {
            Navigator.pop(ctx);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreatePage(initialDestination: c)));
          })).toList()),
      ]),
    ));
  }

  void _generateTrip() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreatePage()));
  }

  void _goToDestination(String dest) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreatePage(initialDestination: dest)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('云游助手'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // 搜索框
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索目的地...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(icon: const Icon(Icons.travel_explore), onPressed: _showCityList),
              filled: true, fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
            onSubmitted: (_) => _searchDestination(),
          ),
          const SizedBox(height: 20),

          // Banner
          _buildBanner(theme),
          const SizedBox(height: 24),

          // 快捷入口
          _buildQuickActions(theme),
          const SizedBox(height: 24),

          // 热门目的地
          _buildHotDestinations(theme),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildBanner(ThemeData theme) {
    return Column(children: [
      SizedBox(height: 160, child: PageView.builder(
        itemCount: _banners.length,
        onPageChanged: (i) => setState(() => _currentBannerIndex = i),
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade500])),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_banners[i]['title']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_banners[i]['subtitle']!, style: const TextStyle(color: Colors.white70)),
          ]),
        ),
      )),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_banners.length, (i) =>
        Container(width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(shape: BoxShape.circle, color: _currentBannerIndex == i ? theme.colorScheme.primary : theme.colorScheme.outline)),
      )),
    ]);
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('快捷功能', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _actionCard(Icons.auto_awesome, '一键生成', 'AI智能规划', theme.colorScheme.primaryContainer, _generateTrip)),
        const SizedBox(width: 10),
        Expanded(child: _actionCard(Icons.list_alt, '打包清单', '出行必备', Colors.green.withAlpha(30), () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PackingListPage())))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _actionCard(Icons.explore, '热门城市', '目的地推荐', theme.colorScheme.secondaryContainer, _showCityList)),
        const SizedBox(width: 10),
        Expanded(child: _actionCard(Icons.map, '探索发现', '旅游攻略', Colors.purple.withAlpha(25), () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiscoverPage())))),
      ]),
    ]);
  }

  Widget _actionCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Material(color: color, borderRadius: BorderRadius.circular(16),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ])),
      ),
    );
  }

  Widget _buildHotDestinations(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('热门目的地', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        TextButton(onPressed: _showCityList, child: const Text('查看全部')),
      ]),
      const SizedBox(height: 8),
      GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.3, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: _hotDestinations.length,
        itemBuilder: (_, i) => _destCard(_hotDestinations[i]),
      ),
    ]);
  }

  Widget _destCard(Map<String, dynamic> dest) {
    final imageUrl = _cityImages[dest['name']] ?? '';
    return Material(borderRadius: BorderRadius.circular(16), elevation: 2,
      child: InkWell(onTap: () => _goToDestination(dest['name']), borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)])),
            padding: const EdgeInsets.all(12),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(dest['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(children: [
                Text(dest['desc'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 2),
                Text(dest['rating'], style: const TextStyle(color: Colors.white, fontSize: 12)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
