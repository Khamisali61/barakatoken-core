import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:barakatoken_mobile/core/network/dio_client.dart';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Dio _dio = DioClient.instance;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login/access-token',
        data: FormData.fromMap({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '/users/',
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        // Automatically login after registration
        return await login(email, password);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<bool> canUseBiometrics() async {
    final bool canAuthenticateWithBiometrics =
        await _localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your Baraka Wallet',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _secureStorage.write(
      key: 'biometrics_enabled',
      value: enabled.toString(),
    );
  }

  Future<bool> isBiometricsEnabled() async {
    final String? val = await _secureStorage.read(key: 'biometrics_enabled');
    return val == 'true';
  }
}

final authServiceProvider = Provider((ref) => AuthService());
