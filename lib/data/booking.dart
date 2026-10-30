/// One placed order: a service booking, a shop order, or a mix of both
/// (the cart allows both, like real super-apps). [progress] drives the
/// live-tracking screen: 0 = confirmed, 1 = delivered/completed.
enum BookingStatus { confirmed, onTheWay, inProgress, completed, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get label => switch (this) {
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.onTheWay => 'Provider on the way',
    BookingStatus.inProgress => 'In progress',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };
}

class Booking {
  final String id;
  final String title; // e.g. "Deep Home Cleaning + 2 items"
  final int total; // PKR
  final BookingStatus status;
  final double progress; // 0.0 - 1.0, drives the tracking map
  final String providerName;
  final String eta; // human text, e.g. "12 min"
  final DateTime placedAt;
  final String address;

  const Booking({
    required this.id,
    required this.title,
    required this.total,
    required this.status,
    required this.progress,
    required this.providerName,
    required this.eta,
    required this.placedAt,
    required this.address,
  });

  Booking copyWith({BookingStatus? status, double? progress, String? eta}) =>
      Booking(
        id: id,
        title: title,
        total: total,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        providerName: providerName,
        eta: eta ?? this.eta,
        placedAt: placedAt,
        address: address,
      );
}
