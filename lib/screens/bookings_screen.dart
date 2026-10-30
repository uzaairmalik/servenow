import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/booking.dart';
import '../providers/booking_provider.dart';
import '../widgets/cards.dart';
import '../widgets/common_widgets.dart';
import 'tracking_screen.dart';

/// Order history. Tapping an active booking opens live tracking;
/// tapping a completed one shows a short confirmation instead of a
/// dead tracking screen.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;
    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: bookings.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No bookings yet',
              subtitle: 'Your orders and service bookings will appear here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final b = bookings[i];
                return BookingCard(
                  booking: b,
                  onTap: () {
                    final isActive = b.status != BookingStatus.completed &&
                        b.status != BookingStatus.cancelled;
                    if (isActive) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TrackingScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${b.title} • ${b.status.label}')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
