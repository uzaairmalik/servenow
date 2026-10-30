import 'package:flutter/foundation.dart';

import '../data/booking.dart';
import '../data/mock_data.dart';

/// Owns order history + the live-tracking simulation.
///
/// The tracking screen calls [tick] on a timer. Each tick moves the
/// active booking forward and recomputes status/ETA from [progress],
/// so the map, timeline and ETA can never disagree — they all read
/// the same single source of truth.
class BookingProvider extends ChangeNotifier {
  BookingProvider() : _bookings = MockData.seedBookings();

  List<Booking> _bookings;

  List<Booking> get bookings => List.unmodifiable(_bookings);

  Booking? get activeBooking {
    for (final b in _bookings) {
      if (b.status != BookingStatus.completed &&
          b.status != BookingStatus.cancelled) {
        return b;
      }
    }
    return null;
  }

  void addBooking(Booking booking) {
    _bookings = [booking, ..._bookings];
    notifyListeners();
  }

  void tick() {
    final active = activeBooking;
    if (active == null) return;
    final nextProgress = (active.progress + 0.08).clamp(0.0, 1.0);
    final nextStatus = nextProgress >= 1
        ? BookingStatus.completed
        : nextProgress >= 0.7
            ? BookingStatus.inProgress
            : nextProgress >= 0.3
                ? BookingStatus.onTheWay
                : BookingStatus.confirmed;
    final minutesLeft = ((1 - nextProgress) * 25).round();
    final nextEta =
        nextProgress >= 1 ? 'Delivered' : '$minutesLeft min';
    _bookings = _bookings
        .map(
          (b) => b.id == active.id
              ? b.copyWith(status: nextStatus, progress: nextProgress, eta: nextEta)
              : b,
        )
        .toList();
    notifyListeners();
  }

  void cancel(String id) {
    _bookings = _bookings
        .map(
          (b) => b.id == id
              ? b.copyWith(status: BookingStatus.cancelled)
              : b,
        )
        .toList();
    notifyListeners();
  }
}
