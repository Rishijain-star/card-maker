import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../data/models/app_product.dart';

class ProductApiService {
  ProductApiService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<AppProduct>> fetchActiveProducts() async {
    final response = await _dio.get<dynamic>(
      '${ApiConfig.baseUrl}products',
      options: Options(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
        headers: const <String, String>{'Accept': 'application/json'},
      ),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Invalid products response');
    }

    final data = body['data'];
    if (data is! List<dynamic>) {
      throw const FormatException('Products list missing');
    }

    return data
        .map(
          (dynamic item) => AppProduct.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
