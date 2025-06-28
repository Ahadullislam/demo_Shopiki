class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
  // TODO: Add fromMap/toMap for Firestore
}
