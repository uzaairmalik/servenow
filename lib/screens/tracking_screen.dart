import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/booking.dart';
import '../providers/booking_provider.dart';
import '../widgets/common_widgets.dart';

/// Live tracking: simulated map + timeline + ETA, all driven by the
/// active booking's [progress] (see BookingProvider.tick).
///
/// Production swap: replace [TrackingMap] with a Google Maps /
/// flutter_map widget fed by the provider's live coordinates. The
/// timeline, ETA and status logic stay exactly the same, because they
/// read the booking — not the map.
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Demo simulation: advance the booking every 3 seconds so the
    // marker visibly moves during a screen recording.
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => context.read<BookingProvider>().tick(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>().activeBooking;
    if (booking == null) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.local_shipping_outlined,
          title: 'No active booking',
          subtitle: 'Place an order and watch your provider live here.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Live tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TrackingMap(progress: booking.progress),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.providerName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Text(booking.title, style: TextStyle(color: Theme.of(context).hintColor)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ETA: ${booking.eta}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      PriceText(price: booking.total),
                    ],
                  ),
                  Text(booking.address, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._timelineSteps(booking).map(
            (step) => ListTile(
              leading: Icon(
                step.done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: step.done ? Colors.green : null,
              ),
              title: Text(step.label),
              subtitle: step.done ? null : const Text('Pending'),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.read<BookingProvider>().cancel(booking.id),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
  }

  List<_Step> _timelineSteps(Booking b) => [
    const _Step('Order confirmed', true),
    _Step('Provider assigned', b.progress >= 0.3),
    _Step('Provider on the way', b.progress >= 0.3),
    _Step('Work in progress', b.progress >= 0.7),
    _Step('Completed', b.progress >= 1),
  ];
}

class _Step {
  final String label;
  final bool done;
  const _Step(this.label, this.done);
}

/// Stylised map: no API key needed for the demo. The route is a fixed
/// polyline in relative coordinates; the provider marker is placed by
/// interpolating along it at [progress].
class TrackingMap extends StatelessWidget {
  final double progress;
  const TrackingMap({super.key, required this.progress});

  static const _route = [
    Offset(0.12, 0.78),
    Offset(0.32, 0.58),
    Offset(0.52, 0.66),
    Offset(0.72, 0.36),
    Offset(0.88, 0.24),
  ];

  Offset _pointAt(double t, Size size) {
    final scaled = _route
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();
    final pos = t.clamp(0.0, 1.0) * (scaled.length - 1);
    final i = pos.floor().clamp(0, scaled.length - 2);
    final frac = pos - i;
    return Offset(
      scaled[i].dx + (scaled[i + 1].dx - scaled[i].dx) * frac,
      scaled[i].dy + (scaled[i + 1].dy - scaled[i].dy) * frac,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, 260);
          final providerPoint = _pointAt(progress, size);
          final customerPoint = _route.last * 1.0;
          final customerPx = Offset(
            customerPoint.dx * size.width,
            customerPoint.dy * size.height,
          );
          return SizedBox(
            height: 260,
            child: Stack(
              children: [
                CustomPaint(
                  size: size,
                  painter: _RoutePainter(route: _route, progress: progress),
                ),
                Positioned(
                  left: providerPoint.dx - 20,
                  top: providerPoint.dy - 20,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF0E6B62),
                    child: Icon(Icons.delivery_dining, color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  left: customerPx.dx - 16,
                  top: customerPx.dy - 32,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(progress * 100).round()}% on the way',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final List<Offset> route;
  final double progress;
  const _RoutePainter({required this.route, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8F0EC);
    canvas.drawRect(Offset.zero & size, bg);
    // Faint street grid, so it reads as a map at a glance.
    final grid = Paint()
      ..color = Colors.white
      ..strokeWidth = 10;
    for (var y = 40.0; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (var x = 50.0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    final pts = route.map((p) => Offset(p.dx * size.width, p.dy * size.height)).toList();
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    // Travelled portion, in primary teal.
    final travelled = Path()..moveTo(pts.first.dx, pts.first.dy);
    final total = (pts.length - 1) * progress;
    for (var i = 0; i < pts.length - 1; i++) {
      if (total >= i + 1) {
        travelled.lineTo(pts[i + 1].dx, pts[i + 1].dy);
      } else if (total > i) {
        final f = total - i;
        travelled.lineTo(
          pts[i].dx + (pts[i + 1].dx - pts[i].dx) * f,
          pts[i].dy + (pts[i + 1].dy - pts[i].dy) * f,
        );
        break;
      }
    }
    canvas.drawPath(
      travelled,
      Paint()
        ..color = const Color(0xFF0E6B62)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) =>
      old.progress != progress || old.route != route;
}
