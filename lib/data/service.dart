/// A bookable on-demand service (cleaning, plumbing, ...).
/// `fromJson` mirrors the shape a real REST API would return, so swapping
/// the mock layer for http calls is a one-file change in ApiService.
class Service {
  final String id;
  final String title;
  final String category;
  final String description;
  final int price; // PKR
  final int durationMinutes;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String providerName;
  final double providerRating;
  final bool isPopular;
  final List<String> includes;

  const Service({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.providerName,
    required this.providerRating,
    this.isPopular = false,
    this.includes = const [],
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    description: json['description'] as String,
    price: json['price'] as int,
    durationMinutes: json['durationMinutes'] as int,
    rating: (json['rating'] as num).toDouble(),
    reviews: json['reviews'] as int,
    imageUrl: json['imageUrl'] as String,
    providerName: json['providerName'] as String,
    providerRating: (json['providerRating'] as num).toDouble(),
    isPopular: json['isPopular'] as bool? ?? false,
    includes: List<String>.from(json['includes'] as List? ?? const []),
  );
}
