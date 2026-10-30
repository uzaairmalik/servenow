import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../data/cart_line.dart';
import '../data/service.dart';
import '../data/shop_product.dart';

/// Single cart for services + products. Quantities merge by id so
/// tapping "Add" twice never creates duplicate rows.
class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);
  int get itemCount => _lines.fold(0, (sum, l) => sum + l.quantity);
  int get subtotal => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  int get deliveryFee {
    if (_lines.isEmpty) return 0;
    return subtotal >= AppConstants.freeDeliveryThreshold
        ? 0
        : AppConstants.deliveryFee;
  }

  int get total => subtotal + deliveryFee;

  void addService(Service service) {
    _add(
      CartLine(
        id: service.id,
        title: service.title,
        kind: CartKind.service,
        unitPrice: service.price,
        quantity: 1,
        imageUrl: service.imageUrl,
      ),
    );
  }

  void addProduct(ShopProduct product) {
    _add(
      CartLine(
        id: product.id,
        title: product.name,
        kind: CartKind.product,
        unitPrice: product.price,
        quantity: 1,
        imageUrl: product.imageUrl,
      ),
    );
  }

  void _add(CartLine line) {
    final index = _lines.indexWhere((l) => l.id == line.id);
    if (index >= 0) {
      _lines[index] = _lines[index].copyWith(
        quantity: _lines[index].quantity + 1,
      );
    } else {
      _lines.add(line);
    }
    notifyListeners();
  }

  void changeQuantity(String id, int delta) {
    final index = _lines.indexWhere((l) => l.id == id);
    if (index < 0) return;
    final next = _lines[index].quantity + delta;
    if (next <= 0) {
      _lines.removeAt(index);
    } else {
      _lines[index] = _lines[index].copyWith(quantity: next);
    }
    notifyListeners();
  }

  void remove(String id) {
    _lines.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
