import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/theme_provider.dart';

/// Profile: account summary, dark-mode toggle, support contact and
/// logout. Deliberately small — a portfolio profile screen should
/// prove settings wiring, not become a second app.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final theme = context.watch<ThemeProvider>();
    final bookings = context.watch<BookingProvider>().bookings;
    final completed = bookings
        .where((b) => b.status.name == 'completed')
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                child: Text(
                  (user?.name.isNotEmpty ?? false) ? user!.name[0] : '?',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              title: Text(
                user?.name ?? 'Guest',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              subtitle: Text('${user?.email ?? ''}\n${user?.city ?? ''}'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('Bookings', '${bookings.length}'),
                  _stat('Completed', '$completed'),
                  _stat('Cities', '${AppConstants.cities.length}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Switch the whole app theme'),
            value: theme.isDark,
            onChanged: (_) => theme.toggle(),
          ),
          const ListTile(
            leading: Icon(Icons.support_agent_outlined),
            title: Text('Support'),
            subtitle: Text(AppConstants.supportPhone),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About ServeNow'),
            subtitle: Text('Version 1.0.0 • Demo build with mock API'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.read<AuthProvider>().logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
