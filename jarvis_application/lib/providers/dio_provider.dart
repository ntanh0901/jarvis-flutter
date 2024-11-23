import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

import '../config/config.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Config.apiUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  ));
});
