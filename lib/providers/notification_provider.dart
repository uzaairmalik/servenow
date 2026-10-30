import 'package:flutter/foundation.dart';

import '../data/app_notification.dart';
import '../data/mock_data.dart';

/// Notification centre state. In production, FCM handlers call [add]
/// with the same model — the screen below does not change.
class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _items = MockData.seedNotifications();

  List<AppNotification> get items => List.unmodifiable(_items);
  int get unreadCount => _items.where((n) => !n.read).length;

  void add(AppNotification notification) {
    _items = [notification, ..._items];
    notifyListeners();
  }

  void markRead(String id) {
    _items = _items
        .map((n) => n.id == id ? n.copyWith(read: true) : n)
        .toList();
    notifyListeners();
  }

  void markAllRead() {
    _items = _items.map((n) => n.copyWith(read: true)).toList();
    notifyListeners();
  }
}
