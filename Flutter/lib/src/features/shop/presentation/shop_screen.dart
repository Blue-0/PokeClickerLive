import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokeclickerlive/src/features/clicker/application/clicker_controller.dart';
import '../application/shop_controller.dart';
import '../application/inventory_controller.dart';
import '../domain/shop_item.dart';
import '../domain/upgrade.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopControllerProvider);
    final clickerState = ref.watch(clickerControllerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PokéShop'),
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.upgrade), text: 'Upgrades'),
              Tab(icon: Icon(Icons.shopping_bag), text: 'Items'),
            ],
            indicatorColor: Colors.white,
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${clickerState.currency}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amber.shade50, Colors.orange.shade100],
            ),
          ),
          child: TabBarView(
            children: [
              _buildUpgradeList(
                context,
                ref,
                shopState.upgrades,
                clickerState.currency,
              ),
              _buildItemList(
                context,
                ref,
                shopState.items,
                clickerState.currency,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeList(
    BuildContext context,
    WidgetRef ref,
    List<Upgrade> upgrades,
    int currency,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upgrades.length,
      itemBuilder: (context, index) {
        final upgrade = upgrades[index];
        final canAfford = currency >= upgrade.currentCost;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: canAfford ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildIcon(upgrade.icon),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfo(
                    upgrade.name,
                    upgrade.description,
                    upgrade.level,
                  ),
                ),
                _buildBuyButton(
                  context,
                  ref,
                  canAfford,
                  upgrade.currentCost,
                  () => ref
                      .read(shopControllerProvider.notifier)
                      .purchaseUpgrade(upgrade.id),
                  '${upgrade.name} upgraded!',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemList(
    BuildContext context,
    WidgetRef ref,
    List<ShopItem> items,
    int currency,
  ) {
    final inventory = ref.watch(inventoryControllerProvider);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final canAfford = currency >= item.price;
        final owned = inventory.items[item.id] ?? 0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: canAfford ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: item.spriteUrl,
                    fit: BoxFit.contain,
                    memCacheHeight: 96,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Owned: $owned',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBuyButton(
                      context,
                      ref,
                      canAfford,
                      item.price,
                      () => ref
                          .read(shopControllerProvider.notifier)
                          .purchaseItem(item),
                      '${item.name} purchased!',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIcon(String icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(icon, style: const TextStyle(fontSize: 30))),
    );
  }

  Widget _buildInfo(String name, String description, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Lv. $level',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBuyButton(
    BuildContext context,
    WidgetRef ref,
    bool canAfford,
    int cost,
    bool Function() onBuy,
    String successMsg,
  ) {
    return ElevatedButton(
      onPressed: canAfford
          ? () {
              final result = onBuy();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result ? successMsg : 'Purchase failed!'),
                    backgroundColor: result ? Colors.green : Colors.red,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        children: [
          const Icon(Icons.monetization_on, size: 16),
          Text('$cost', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
