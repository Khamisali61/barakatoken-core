import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/network/dio_client.dart';

class UserProfile {
  final int id;
  final String email;
  final String fullName;
  final double kesBalance;
  final double usdBalance;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.kesBalance,
    required this.usdBalance,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      kesBalance: (json['kes_balance'] as num).toDouble(),
      usdBalance: (json['usd_balance'] as num).toDouble(),
    );
  }
}

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final dio = DioClient.instance;
  final response = await dio.get('/users/me');
  if (response.statusCode == 200) {
    return UserProfile.fromJson(response.data);
  } else {
    throw Exception('Failed to load user profile');
  }
});
