import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../data/service.dart';
import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';

/// Service detail: hero image, rating, duration, what's included,
/// provider card, sticky price + Add/Book bar. This is the screen
/// clients screenshot first — it must answer "what, how long, how
/// much, who" without scrolling past the fold twice.
class DetailScreen extends StatelessWidget {
  final Service service;

  const DetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.title)),
      body: ListView(
        children: [
          AppImage(
            url: service.imageUrl,
            height: 240,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    RatingRow(rating: service.rating, reviews: service.reviews),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${service.category} • ${formatDuration(service.durationMinutes)} • ${service.providerName}',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 16),
                Text(service.description, style: const TextStyle(fontSize: 15, height: 1.5)),
                const SizedBox(height: 20),
                const Text(
                  "What's included",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                ...service.includes.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(service.providerName[0]),
                    ),
                    title: Text(service.providerName),
                    subtitle: Text(
                      '${service.providerRating.toStringAsFixed(1)} provider rating • Verified',
                    ),
                    trailing: const Icon(Icons.verified, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Starting at', style: TextStyle(fontSize: 12)),
                    PriceText(price: service.price, fontSize: 20),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addService(service);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  child: const Text('Book now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
