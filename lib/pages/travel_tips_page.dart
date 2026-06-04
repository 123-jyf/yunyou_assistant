// AI生成 - 旅行攻略页面（季节、省钱、安全）
import 'package:flutter/material.dart';

/// 旅行攻略页面
class TravelTipsPage extends StatelessWidget {
  final String category; // 'season', 'budget', 'safety'

  const TravelTipsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle()), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _buildTips(theme),
      ),
    );
  }

  String _getTitle() {
    switch (category) {
      case 'season': return '最佳旅行季节';
      case 'budget': return '省钱攻略';
      case 'safety': return '安全出行指南';
      default: return '旅行攻略';
    }
  }

  List<Widget> _buildTips(ThemeData theme) {
    switch (category) {
      case 'season':
        return _buildSeasonTips(theme);
      case 'budget':
        return _buildBudgetTips(theme);
      case 'safety':
        return _buildSafetyTips(theme);
      default:
        return [];
    }
  }

  List<Widget> _buildSeasonTips(ThemeData theme) {
    final seasons = [
      {'city': '三亚', 'season': '10月-次年4月', 'reason': '气候宜人，避寒首选', 'icon': Icons.beach_access, 'temp': '25°C'},
      {'city': '丽江', 'season': '3月-10月', 'reason': '春夏最美，避暑好去处', 'icon': Icons.landscape, 'temp': '16°C'},
      {'city': '北京', 'season': '3-5月、9-11月', 'reason': '春秋最舒适', 'icon': Icons.account_balance, 'temp': '12°C'},
      {'city': '杭州', 'season': '3-5月、9-11月', 'reason': '春季西湖最美', 'icon': Icons.water_drop, 'temp': '18°C'},
      {'city': '成都', 'season': '3-6月、9-11月', 'reason': '春秋宜人', 'icon': Icons.pets, 'temp': '17°C'},
      {'city': '厦门', 'season': '3-5月、10-12月', 'reason': '气候最舒适', 'icon': Icons.sailing, 'temp': '21°C'},
      {'city': '日本', 'season': '3-5月（樱花）', 'reason': '樱花季最美', 'icon': Icons.flutter_dash, 'temp': '15°C'},
      {'city': '泰国', 'season': '11月-次年2月', 'reason': '凉季最舒适', 'icon': Icons.wb_sunny, 'temp': '28°C'},
      {'city': '巴黎', 'season': '4-6月、9-10月', 'reason': '春秋最浪漫', 'icon': Icons.wine_bar, 'temp': '14°C'},
    ];

    return [
      _buildHeader('🌤️ 热门目的地最佳旅行季节', theme),
      const SizedBox(height: 16),
      _buildTipCard(
        '💡 小贴士',
        '旺季（春节、五一、国庆）期间，机票酒店价格通常翻倍，建议提前1-2个月预订。\n\n淡季出行虽然价格便宜，但需注意部分地区可能有台风、暴雨等天气影响。',
        Colors.blue,
        theme,
      ),
      const SizedBox(height: 16),
      ...seasons.map((s) => _buildSeasonCard(s, theme)),
    ];
  }

  Widget _buildSeasonCard(Map<String, dynamic> s, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: Icon(s['icon'] as IconData, color: Colors.blue, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s['city'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            Text('最佳季节: ${s['season']}', style: TextStyle(fontSize: 13, color: Colors.green.shade600)),
            Text(s['reason'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ])),
          Text(s['temp'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange.shade400)),
        ]),
      ),
    );
  }

  List<Widget> _buildBudgetTips(ThemeData theme) {
    return [
      _buildHeader('💰 旅行省钱攻略', theme),
      const SizedBox(height: 16),
      _buildTipCard('✈️ 机票省钱', '• 提前1-2个月订票，价格最低\n• 选择周二、周三出发，比周末便宜30%\n• 使用比价APP（携程、飞猪、去哪儿）\n• 关注航空公司会员日活动\n• 中转航班可节省40-60%费用', Colors.blue, theme),
      const SizedBox(height: 12),
      _buildTipCard('🏨 住宿省钱', '• 提前预订比当天便宜50%\n• 选择民宿/青旅比酒店便宜\n• 使用返现平台（美团、携程返现）\n• 关注酒店会员折扣\n• 多人出行合住更划算', Colors.green, theme),
      const SizedBox(height: 12),
      _buildTipCard('🍜 餐饮省钱', '• 避开景区内餐厅，走远500米价格减半\n• 去本地人常去的菜市场\n• 自备水壶，省去买饮料的钱\n• 住民宿可自己做饭\n• 团购APP提前买优惠券', Colors.orange, theme),
      const SizedBox(height: 12),
      _buildTipCard('🎫 门票省钱', '• 学生证可优惠50%（记得带！）\n• 提前网上购票比现场便宜\n• 关注景点免费开放日\n• 购买城市旅游卡（如北京一卡通）\n• 部分景点下午票更便宜', Colors.purple, theme),
      const SizedBox(height: 12),
      _buildTipCard('📦 打包省钱', '• 使用旅行装分装瓶减少行李\n• 携带折叠购物袋\n• 准备万能转换插头\n• 药品按需携带，不要买太多\n• 提前查好当地天气再打包', Colors.red, theme),
    ];
  }

  List<Widget> _buildSafetyTips(ThemeData theme) {
    return [
      _buildHeader('🛡️ 安全出行指南', theme),
      const SizedBox(height: 16),
      _buildTipCard('📋 出行前准备', '• 购买旅行保险（尤其是境外游）\n• 复印护照/身份证并分开存放\n• 告知家人行程和联系方式\n• 下载离线地图和翻译APP\n• 准备常用药物和急救包', Colors.blue, theme),
      const SizedBox(height: 12),
      _buildTipCard('👛 财物安全', '• 现金分开放，不要全放在一个地方\n• 使用隐蔽腰包或防盗背包\n• 贵重物品存酒店保险箱\n• 手机不要随手放在桌上\n• 警惕街头诈骗和强买强卖', Colors.red, theme),
      const SizedBox(height: 12),
      _buildTipCard('🚗 交通安全', '• 选择正规出租车/网约车\n• 拒绝黑车和超载车辆\n• 自驾前检查车况和保险\n• 夜间避免单独出行\n• 记下当地紧急电话（110/120）', Colors.orange, theme),
      const SizedBox(height: 12),
      _buildTipCard('🌡️ 健康安全', '• 注意饮食卫生，避免生冷食物\n• 多喝水，防止中暑\n• 高原地区注意高反\n• 海边注意防晒和溺水风险\n• 携带常用药品（感冒药/肠胃药）', Colors.green, theme),
      const SizedBox(height: 12),
      _buildTipCard('📞 紧急联系方式', '• 报警: 110\n• 急救: 120\n• 火警: 119\n• 外交部全球领事保护: +86-10-12308\n• 旅行保险客服: 查看保单上的电话', Colors.purple, theme),
    ];
  }

  Widget _buildHeader(String text, ThemeData theme) {
    return Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface));
  }

  Widget _buildTipCard(String title, String content, Color color, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 14, height: 1.6, color: theme.colorScheme.onSurface.withValues(alpha: 0.8))),
      ]),
    );
  }
}
