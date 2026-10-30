import 'package:flutter/material.dart';

import '../core/formatters.dart';

/// Network image with a graceful fallback — demo image hosts can fail,
/// and a broken-image icon in a client screenshot is an instant red flag.
class AppImage extends StatelessWidget {
  final String url;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.url,
    required this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.network(
        url,
        height: height,
        width: width ?? double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => Container(
          height: height,
          width: width ?? double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_outlined, size: 32),
        ),
      ),
    );
  }
}

/// Star + rating + review count, used identically on every card.
class RatingRow extends StatelessWidget {
  final double rating;
  final int reviews;

  const RatingRow({super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviews)',
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
        ),
      ],
    );
  }
}

/// Section heading + optional "See all" action.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }
}

/// Horizontal scrollable category chips. The selected chip is the
/// primary colour; unselected chips are surface — one pattern, reused
/// for services and products so filtering feels consistent.
class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((c) {
          final isSelected = c == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(c),
              selected: isSelected,
              onSelected: (_) => onSelected(c),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Empty state used by cart, bookings and search results.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Price text — always through [formatPKR], never a raw number.
class PriceText extends StatelessWidget {
  final int price;
  final double fontSize;

  const PriceText({super.key, required this.price, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatPKR(price),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
