import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/network/dio_client.dart';
import 'package:barakatoken_mobile/features/dashboard/data/user_provider.dart';
import 'package:barakatoken_mobile/features/marketplace/data/asset_provider.dart';

class WalletService {
  final Ref _ref;

  WalletService(this._ref);

  Future<bool> topUp(double amount) async {
    try {
      final response = await DioClient.instance.post(
        '/payments/mock-topup',
        queryParameters: {'amount': amount},
      );

      if (response.statusCode == 200) {
        // Invalidate user profile to trigger a refresh
        _ref.invalidate(userProfileProvider);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> invest(int assetId, double amount) async {
    try {
      final response = await DioClient.instance.post(
        '/assets/$assetId/invest',
        queryParameters: {'amount': amount},
      );

      if (response.statusCode == 200) {
        _ref.invalidate(userProfileProvider);
        _ref.invalidate(assetsProvider);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

final walletServiceProvider = Provider((ref) => WalletService(ref));
