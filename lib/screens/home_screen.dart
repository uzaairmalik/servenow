import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/cards.dart';
import '../widgets/common_widgets.dart';
import 'detail_screen.dart';
import 'notifications_screen.dart';
import 'tracking_screen.dart';

/// Home: greeting, search, quick categories, live-booking banner,
/// popular services and top products. Every card routes to the same
/// detail/catalog flows — home never duplicates business logic.
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onGoToTab;

  const HomeScreen({super.key, required this.onGoToTab});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final catalog = context.watch<CatalogProvider>();
    final active = context.watch<BookingProvider>().activeBooking;
    final unread = context.watch<NotificationProvider>().unreadCount;
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user?.name.split(' ').first ?? 'there'} 👋',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              user?.city ?? 'Islamabad',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              if (unread > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$unread',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => onGoToTab(2),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: catalog.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Search jumps straight to the catalog tab, query pre-filled.
                TextField(
                  readOnly: true,
                  onTap: () => onGoToTab(1),
                  decoration: const InputDecoration(
                    hintText: 'Search cleaning, plumbing, AC...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                if (active != null)
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.local_shipping_outlined),
                      title: Text('${active.providerName} is on the way'),
                      subtitle: Text('ETA ${active.eta} • ${active.title}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TrackingScreen(),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SectionHeader(
                  title: 'Popular services',
                  onSeeAll: () => onGoToTab(1),
                ),
                const SizedBox(height: 8),
                ...catalog.popularServices.take(3).map(
                  (s) => ServiceCard(
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
                  ),
                ),
                const SizedBox(height: 8),
                SectionHeader(
                  title: 'Shop essentials',
                  onSeeAll: () => onGoToTab(1),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: catalog.filteredProducts.take(4).length,
                  itemBuilder: (_, i) {
                    final p = catalog.filteredProducts[i];
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
                ),
                const SizedBox(height: 16),
                Text(
                  'Cities served: ${AppConstants.cities.join(' • ')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                ),
              ],
            ),
    );
  }
}
