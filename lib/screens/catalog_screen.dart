import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../widgets/cards.dart';
import '../widgets/common_widgets.dart';
import 'detail_screen.dart';

/// Catalog: one screen for services AND shop, switched by a segmented
/// control. Search, category chips and sort all live in CatalogProvider,
/// so the two tabs behave identically.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _showServices = true;

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: catalog.setQuery,
              decoration: InputDecoration(
                hintText: _showServices
                    ? 'Search services...'
                    : 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Toggle sort: rating / price',
                  onPressed: catalog.toggleSort,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Services')),
                ButtonSegment(value: false, label: Text('Shop')),
              ],
              selected: {_showServices},
              onSelectionChanged: (s) =>
                  setState(() => _showServices = s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: CategoryChips(
              categories: _showServices
                  ? AppConstants.serviceCategories
                  : AppConstants.productCategories,
              selected: _showServices
                  ? catalog.serviceCategory
                  : catalog.productCategory,
              onSelected: _showServices
                  ? catalog.setServiceCategory
                  : catalog.setProductCategory,
            ),
          ),
          Expanded(
            child: catalog.isLoading
                ? const Center(child: CircularProgressIndicator())
                : catalog.error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(catalog.error!),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: catalog.load,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _showServices
                        ? _buildServiceList(catalog)
                        : _buildProductGrid(catalog),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList(CatalogProvider catalog) {
    final list = catalog.filteredServices;
    if (list.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No services found',
        subtitle: 'Try a different search or category.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final s = list[i];
        return ServiceCard(
          service: s,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(service: s)),
          ),
          onAdd: () {
            context.read<CartProvider>().addService(s);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${s.title} added to cart')),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGrid(CatalogProvider catalog) {
    final list = catalog.filteredProducts;
    if (list.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No products found',
        subtitle: 'Try a different search or category.',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final p = list[i];
        return ProductCard(
          product: p,
          onAdd: () {
            context.read<CartProvider>().addProduct(p);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${p.name} added to cart')),
            );
          },
        );
      },
    );
  }
}
