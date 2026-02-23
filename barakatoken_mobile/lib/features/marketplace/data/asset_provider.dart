import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/network/dio_client.dart';
import 'package:barakatoken_mobile/features/marketplace/domain/asset_model.dart';

final assetsProvider = FutureProvider<List<SukukAsset>>((ref) async {
  final dio = DioClient.instance;
  final response = await dio.get('/assets/');
  if (response.statusCode == 200) {
    final List data = response.data;
    return data.map((json) => SukukAsset.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load assets');
  }
});
