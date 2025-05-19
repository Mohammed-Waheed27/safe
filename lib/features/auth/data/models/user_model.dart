import '../../domain/entities/user.dart';

/// Model class for User entity
class UserModel extends User {
  /// Constructor that matches the entity
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.photoUrl,
  });

  /// Create model from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
