import 'package:flutter_test/flutter_test.dart';
import 'package:servenow/core/formatters.dart';
import 'package:servenow/data/service.dart';
import 'package:servenow/providers/cart_provider.dart';

void main() {
  test('formatPKR groups thousands', () {
    expect(formatPKR(12500), 'Rs 12,500');
    expect(formatPKR(900), 'Rs 900');
  });

  test('formatDuration renders hours and minutes', () {
    expect(formatDuration(45), '45m');
    expect(formatDuration(90), '1h 30m');
  });

  test('cart merges duplicate adds and totals correctly', () {
    const service = Service(
      id: 'svc-01',
      title: 'Deep Home Cleaning',
      category: 'Cleaning',
      description: 'Test',
      price: 4500,
      durationMinutes: 180,
      rating: 4.9,
      reviews: 10,
      imageUrl: '',
      providerName: 'Test Co.',
      providerRating: 4.9,
    );
    final cart = CartProvider();
    cart.addService(service);
    cart.addService(service);
    expect(cart.itemCount, 2);
    expect(cart.lines.length, 1);
    // 9,000 subtotal clears the 5,000 free-delivery threshold.
    expect(cart.deliveryFee, 0);
    expect(cart.total, 9000);
  });
}
