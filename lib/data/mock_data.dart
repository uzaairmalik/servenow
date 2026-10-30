import 'app_notification.dart';
import 'booking.dart';

/// Seeded history + notifications so the app looks lived-in on first
/// launch — essential for screenshots and demo videos. New bookings and
/// notifications created at checkout are prepended to these lists by
/// their providers; nothing here is hard-coded into a screen.
class MockData {
  static List<Booking> seedBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 'SN-48102',
        title: 'AC General Service',
        total: 2500,
        status: BookingStatus.onTheWay,
        progress: 0.45,
        providerName: 'CoolCare Technicians',
        eta: '12 min',
        placedAt: now.subtract(const Duration(minutes: 20)),
        address: 'House 12, Street 4, F-11/2, Islamabad',
      ),
      Booking(
        id: 'SN-47988',
        title: 'Deep Home Cleaning',
        total: 4500,
        status: BookingStatus.completed,
        progress: 1,
        providerName: 'Ayesha Cleaning Co.',
        eta: 'Delivered',
        placedAt: now.subtract(const Duration(days: 3)),
        address: 'House 12, Street 4, F-11/2, Islamabad',
      ),
      Booking(
        id: 'SN-47751',
        title: 'Pro Cleaning Kit + LED Bulb Pack',
        total: 6000,
        status: BookingStatus.completed,
        progress: 1,
        providerName: 'ServeNow Store',
        eta: 'Delivered',
        placedAt: now.subtract(const Duration(days: 6)),
        address: 'House 12, Street 4, F-11/2, Islamabad',
      ),
    ];
  }

  static List<AppNotification> seedNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n1',
        title: 'Your technician is on the way',
        body: 'CoolCare Technicians will arrive in ~12 min for AC General Service.',
        receivedAt: now.subtract(const Duration(minutes: 8)),
        icon: 'booking',
      ),
      AppNotification(
        id: 'n2',
        title: 'Weekend offer: 20% off cleaning',
        body: 'Book any cleaning service before Sunday and save 20% at checkout.',
        receivedAt: now.subtract(const Duration(hours: 5)),
        icon: 'offer',
      ),
      AppNotification(
        id: 'n3',
        title: 'Order SN-47751 delivered',
        body: 'Your store order was delivered. Rate your items to help others.',
        receivedAt: now.subtract(const Duration(days: 6)),
        icon: 'delivery',
      ),
      AppNotification(
        id: 'n4',
        title: 'Welcome to ServeNow',
        body: 'Book trusted home services and shop essentials in one app.',
        receivedAt: now.subtract(const Duration(days: 7)),
        read: true,
        icon: 'info',
      ),
    ];
  }
}
