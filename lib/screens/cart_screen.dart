import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import 'checkout_screen.dart';

/// Cart: quantity steppers, remove, free-delivery progress and a
/// totals breakdown. Delivery is free above the threshold — the
/// progress bar makes that rule visible instead of hidden in fine print.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    if (cart.lines.isEmpty) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'Your cart is empty',
          subtitle: 'Add a service or a product to get started.',
        ),
      );
    }
    final progress =
        (cart.subtotal / AppConstants.freeDeliveryThreshold).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.lines.length,
              itemBuilder: (_, i) {
                final line = cart.lines[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: AppImage(
                      url: line.imageUrl,
                      height: 56,
                      width: 56,
                    ),
                    title: Text(line.title),
                    subtitle: Text(formatPKR(line.unitPrice)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () =>
                              cart.changeQuantity(line.id, -1),
                        ),
                        Text('${line.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () =>
                              cart.changeQuantity(line.id, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cart.deliveryFee == 0
                          ? 'You unlocked FREE delivery'
                          : 'Add ${formatPKR(AppConstants.freeDeliveryThreshold - cart.subtotal)} more for FREE delivery',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 12),
                _totalRow('Subtotal', formatPKR(cart.subtotal)),
                _totalRow('Delivery', cart.deliveryFee == 0 ? 'FREE' : formatPKR(cart.deliveryFee)),
                const Divider(),
                _totalRow('Total', formatPKR(cart.total), bold: true),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  ),
                  child: const Text('Proceed to checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
