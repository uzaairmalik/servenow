/// One entry in the notification centre. This is the *layout* for push
/// notifications: in production these arrive via FCM and are stored the
/// same way, so the UI does not change when FCM is wired in.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool read;
  final String icon; // emoji-free key: 'booking' | 'offer' | 'delivery' | 'info'

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.read = false,
    this.icon = 'info',
  });

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    title: title,
    body: body,
    receivedAt: receivedAt,
    read: read ?? this.read,
    icon: icon,
  );
}
