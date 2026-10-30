/// A shoppable product (cleaning kit, tool set, ...). Kept separate from
/// [Service] on purpose: products have stock + delivery, services have a
/// duration + a provider who travels to the customer.
class ShopProduct {
  final String id;
  final String name;
  final String category;
  final String description;
  final int price; // PKR
  final int? oldPrice; // set => shows a discount badge
  final double rating;
  final int reviews;
  final int stock;
  final String imageUrl;

  const ShopProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.imageUrl,
  });

  bool get onSale => oldPrice != null && oldPrice! > price;
  bool get inStock => stock > 0;

  factory ShopProduct.fromJson(Map<String, dynamic> json) => ShopProduct(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    description: json['description'] as String,
    price: json['price'] as int,
    oldPrice: json['oldPrice'] as int?,
    rating: (json['rating'] as num).toDouble(),
    reviews: json['reviews'] as int,
    stock: json['stock'] as int,
    imageUrl: json['imageUrl'] as String,
  );
}
