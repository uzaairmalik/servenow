import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'service.dart';
import 'shop_product.dart';

/// Simulated REST API layer.
///
/// Why this shape matters for a portfolio: every screen talks to this
/// class (via providers), never to raw JSON. To go live, replace the
/// `rootBundle` reads with `http.get(Uri.parse('$baseUrl/...'))` calls —
/// the method signatures, models and UI stay untouched.
///
/// The artificial delay is intentional: it makes loading spinners,
/// skeletons and error states actually visible in demo videos.
class ApiService {
  static const _latency = Duration(milliseconds: 650);

  Future<List<Service>> fetchServices() async {
    await Future<void>.delayed(_latency);
    final raw = await rootBundle.loadString('assets/data/services.json');
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Service.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ShopProduct>> fetchProducts() async {
    await Future<void>.delayed(_latency);
    final raw = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Simulates POST /orders. Returns a server-style order id.
  Future<String> placeOrder({
    required int total,
    required int itemCount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final stamp = DateTime.now().millisecondsSinceEpoch % 100000;
    return 'SN-$stamp';
  }
}
