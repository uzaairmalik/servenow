import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../widgets/common_widgets.dart';

/// Notification centre — the in-app layout for push notifications.
/// FCM payloads map to the same model (see AppNotification), so wiring
/// real push later does not redesign this screen.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(String key) => switch (key) {
    'booking' => Icons.calendar_month_outlined,
    'offer' => Icons.local_offer_outlined,
    'delivery' => Icons.local_shipping_outlined,
    _ => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: provider.markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: provider.items.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'No notifications',
              subtitle: 'Booking updates and offers will appear here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.items.length,
              itemBuilder: (_, i) {
                final n = provider.items[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: n.read ? null : Theme.of(context).colorScheme.primaryContainer,
                  child: ListTile(
                    leading: Icon(_iconFor(n.icon)),
                    title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(n.body),
                    onTap: () => provider.markRead(n.id),
                  ),
                );
              },
            ),
    );
  }
}
