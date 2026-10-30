/// One line in the cart. A line is either a service or a product —
/// [kind] keeps checkout + totals honest without two parallel carts.
enum CartKind { service, product }

class CartLine {
  final String id;
  final String title;
  final CartKind kind;
  final int unitPrice; // PKR
  final int quantity;
  final String imageUrl;

  const CartLine({
    required this.id,
    required this.title,
    required this.kind,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
  });

  int get lineTotal => unitPrice * quantity;

  CartLine copyWith({int? quantity}) => CartLine(
    id: id,
    title: title,
    kind: kind,
    unitPrice: unitPrice,
    quantity: quantity ?? this.quantity,
    imageUrl: imageUrl,
  );
}
