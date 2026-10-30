/// Minimal signed-in user. The mock auth layer never stores a password —
/// in production this comes from Firebase Auth / your backend JWT.
class AppUser {
  final String id;
  final String name;
  final String email;
  final String city;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
  });
}
