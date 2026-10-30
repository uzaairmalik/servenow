import 'package:flutter/foundation.dart';

import '../data/api_service.dart';
import '../data/service.dart';
import '../data/shop_product.dart';

/// Owns the catalog: loading, search, category filters and sorting.
/// Screens never filter lists themselves — they read [filteredServices]
/// / [filteredProducts], so search behaviour is identical everywhere.
class CatalogProvider extends ChangeNotifier {
  CatalogProvider({ApiService? api}) : _api = api ?? ApiService();

  final ApiService _api;
  List<Service> _services = [];
  List<ShopProduct> _products = [];
  bool _loading = false;
  String? _error;

  String _query = '';
  String _serviceCategory = 'All';
  String _productCategory = 'All';
  bool _priceLowFirst = false;

  bool get isLoading => _loading;
  String? get error => _error;
  String get query => _query;
  String get serviceCategory => _serviceCategory;
  String get productCategory => _productCategory;

  List<Service> get popularServices =>
      _services.where((s) => s.isPopular).toList();

  List<Service> get filteredServices {
    final list = _services.where((s) {
      final matchesQuery = _query.isEmpty ||
          s.title.toLowerCase().contains(_query.toLowerCase()) ||
          s.category.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _serviceCategory == 'All' || s.category == _serviceCategory;
      return matchesQuery && matchesCategory;
    }).toList();
    list.sort((a, b) => _priceLowFirst
        ? a.price.compareTo(b.price)
        : b.rating.compareTo(a.rating));
    return list;
  }

  List<ShopProduct> get filteredProducts {
    final list = _products.where((p) {
      final matchesQuery = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.category.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _productCategory == 'All' || p.category == _productCategory;
      return matchesQuery && matchesCategory;
    }).toList();
    list.sort((a, b) => _priceLowFirst
        ? a.price.compareTo(b.price)
        : b.rating.compareTo(a.rating));
    return list;
  }

  Future<void> load() async {
    if (_loading || _services.isNotEmpty) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _services = await _api.fetchServices();
      _products = await _api.fetchProducts();
    } catch (e) {
      _error = 'Could not load the catalog. Pull to retry.';
    }
    _loading = false;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setServiceCategory(String value) {
    _serviceCategory = value;
    notifyListeners();
  }

  void setProductCategory(String value) {
    _productCategory = value;
    notifyListeners();
  }

  void toggleSort() {
    _priceLowFirst = !_priceLowFirst;
    notifyListeners();
  }
}
