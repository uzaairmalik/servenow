import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../data/app_notification.dart';
import '../data/booking.dart';
import '../data/api_service.dart';
import '../providers/booking_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/notification_provider.dart';
import 'tracking_screen.dart';

/// Checkout: address, city, date/time slot, payment method, order
/// summary. On success it creates a real Booking (visible in Orders
/// and on the tracking map), posts a notification, and clears the cart
/// — the full loop, not a dead "Order placed" dialog.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  String _city = 'Islamabad';
  String _payment = 'Cash on delivery';
  String _slot = 'Today, 2:00 – 4:00 PM';
  bool _placing = false;

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _placing = true);
    final cart = context.read<CartProvider>();
    final orderId = await ApiService().placeOrder(
      total: cart.total,
      itemCount: cart.itemCount,
    );
    if (!mounted) return;
    final title = cart.lines.length == 1
        ? cart.lines.first.title
        : '${cart.lines.first.title} + ${cart.lines.length - 1} more';
    context.read<BookingProvider>().addBooking(
      Booking(
        id: orderId,
        title: title,
        total: cart.total,
        status: BookingStatus.confirmed,
        progress: 0.1,
        providerName: 'ServeNow Partner',
        eta: '25 min',
        placedAt: DateTime.now(),
        address: '${_address.text.trim()}, $_city',
      ),
    );
    context.read<NotificationProvider>().add(
      AppNotification(
        id: 'n-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Order $orderId confirmed',
        body: 'Your booking is confirmed for $_slot. We will notify you when the provider leaves.',
        receivedAt: DateTime.now(),
        icon: 'booking',
      ),
    );
    cart.clear();
    setState(() => _placing = false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TrackingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Delivery address', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 10),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'House, street, area',
                hintText: 'House 12, Street 4, F-11/2',
              ),
              validator: (v) =>
                  (v == null || v.trim().length < 6) ? 'Enter a full address' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _city,
              items: AppConstants.cities
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _city = v ?? _city),
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 20),
            const Text('Time slot', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 10),
            RadioGroup<String>(
              groupValue: _slot,
              onChanged: (v) => setState(() => _slot = v ?? _slot),
              child: Column(
                children: [
                  'Today, 2:00 – 4:00 PM',
                  'Today, 4:00 – 6:00 PM',
                  'Tomorrow, 10:00 AM – 12:00 PM',
                ]
                    .map(
                      (slot) => RadioListTile<String>(
                        title: Text(slot),
                        value: slot,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Payment method', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 10),
            RadioGroup<String>(
              groupValue: _payment,
              onChanged: (v) => setState(() => _payment = v ?? _payment),
              child: Column(
                children: [
                  'Cash on delivery',
                  'Card on delivery',
                  'JazzCash / Easypaisa',
                ]
                    .map(
                      (method) => RadioListTile<String>(
                        title: Text(method),
                        value: method,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text(formatPKR(cart.subtotal)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery'),
                        Text(cart.deliveryFee == 0 ? 'FREE' : formatPKR(cart.deliveryFee)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontWeight: FontWeight.w800)),
                        Text(formatPKR(cart.total), style: const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _placing ? null : _placeOrder,
              child: _placing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text('Place order • ${formatPKR(cart.total)}'),
            ),
          ],
        ),
      ),
    );
  }
}
