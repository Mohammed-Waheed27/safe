import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  /// User ID
  final String id;

  /// User's full name
  final String fullName;

  /// User's email address
  final String email;

  /// Optional profile picture URL
  final String? photoUrl;

  /// Constructor
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, fullName, email, photoUrl];
}
