// AI生成 - 出行打包清单页面
import 'package:flutter/material.dart';
import '../models/destination_data.dart';

/// 出行打包清单页面
class PackingListPage extends StatefulWidget {
  final String? destination;

  const PackingListPage({super.key, this.destination});

  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  late List<PackingCategory> _categories;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _categories = DestinationData.getPackingList();
    _calcProgress();
  }

  void _calcProgress() {
    int total = 0, checked = 0;
    for (final cat in _categories) {
      for (final item in cat.items) {
        total++;
        if (item.checked) checked++;
      }
    }
    _progress = total > 0 ? checked / total : 0;
  }

  void _toggleItem(int catIndex, int itemIndex) {
    setState(() {
      _categories[catIndex].items[itemIndex].checked =
          !_categories[catIndex].items[itemIndex].checked;
      _calcProgress();
    });
  }

  void _resetAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置清单'),
        content: const Text('确定要重置所有勾选项吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(onPressed: () {
            setState(() {
              for (final cat in _categories) {
                for (final item in cat.items) {
                  item.checked = false;
                }
              }
              _calcProgress();
            });
            Navigator.pop(ctx);
          }, child: const Text('确定')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination != null ? '${widget.destination}·打包清单' : '出行打包清单'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetAll, tooltip: '重置'),
        ],
      ),
      body: Column(
        children: [
          // 进度条
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withAlpha(50)),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.checklist, size: 20),
                const SizedBox(width: 8),
                Text('打包进度', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                const Spacer(),
                Text('${(_progress * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ]),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 10,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(_progress >= 1 ? Colors.green : theme.colorScheme.primary),
                ),
              ),
              if (_progress >= 1)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.celebration, color: Colors.amber.shade600, size: 18),
                      const SizedBox(width: 6),
                      Text('打包完成！准备出发！', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ]),
          ),

          // 清单列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _categories.length,
              itemBuilder: (context, catIndex) {
                final cat = _categories[catIndex];
                final catChecked = cat.items.where((i) => i.checked).length;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(cat.icon, color: theme.colorScheme.primary, size: 20),
                    ),
                    title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$catChecked/${cat.items.length} 项', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    initiallyExpanded: catChecked < cat.items.length,
                    children: [
                      ...List.generate(cat.items.length, (itemIndex) {
                        final item = cat.items[itemIndex];
                        return CheckboxListTile(
                          title: Text(item.name, style: TextStyle(
                            decoration: item.checked ? TextDecoration.lineThrough : null,
                            color: item.checked ? Colors.grey : null,
                          )),
                          value: item.checked,
                          onChanged: (_) => _toggleItem(catIndex, itemIndex),
                          activeColor: theme.colorScheme.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
