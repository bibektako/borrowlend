import 'package:equatable/equatable.dart';

/// Represents the core User object in the application domain.
/// This class is pure and has no dependencies on data sources.
class UserProfileEntity extends Equatable {
  final String id; // Corresponds to Mongoose's `_id`
  final String username;
  final String email;
  final String phone;
  final String? location; // Optional field
  final String? bio;      // Optional field
  // From `timestamps`

  const UserProfileEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.location,
    this.bio,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        phone,
        location,
        bio,
        
      ];
}