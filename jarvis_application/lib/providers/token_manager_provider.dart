// token_manager_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/token_manager.dart';

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});
