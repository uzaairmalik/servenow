import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../data/booking.dart';
import '../data/service.dart';
import '../data/shop_product.dart';
import 'common_widgets.dart';

/// Service list card: image, popular badge, rating, duration, price,
/// provider — and one clear "Add" action. Tapping the card opens detail.
class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImage(url: service.imageUrl, height: 170, borderRadius: BorderRadius.zero),
                if (service.isPopular)
                  const Positioned(
                    top: 12,
                    left: 12,
                    child: _Badge('POPULAR'),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      RatingRow(rating: service.rating, reviews: service.reviews),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${service.providerName} • ${formatDuration(service.durationMinutes)}',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(price: service.price, fontSize: 18),
                      FilledButton.icon(
                        onPressed: onAdd,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product grid card: sale badge, stock state, rating, price.
class ProductCard extends StatelessWidget {
  final ShopProduct product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(url: product.imageUrl, height: 130, borderRadius: BorderRadius.zero),
              if (product.onSale)
                const Positioned(top: 10, left: 10, child: _Badge('SALE')),
              if (!product.inStock)
                const Positioned(top: 10, right: 10, child: _Badge('OUT OF STOCK')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                RatingRow(rating: product.rating, reviews: product.reviews),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.oldPrice != null)
                          Text(
                            formatPKR(product.oldPrice!),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(context).hintColor,
                              fontSize: 12,
                            ),
                          ),
                        PriceText(price: product.price),
                      ],
                    ),
                    IconButton.filled(
                      onPressed: product.inStock ? onAdd : null,
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
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
}

/// Booking history card with a progress bar — the same visual language
/// as the live-tracking screen, at a glance.
class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    booking.status.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: booking.status == BookingStatus.cancelled
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.id} • ${booking.providerName}',
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: booking.progress),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriceText(price: booking.total),
                  Text('ETA: ${booking.eta}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
