import 'package:flutter/foundation.dart' show kReleaseMode;

import 'env/dev.dart' as dev;
import 'env/prod.dart' as prod;

class Constants {
  static const String baseUrl = kReleaseMode ? prod.EnvironmentConfig.baseUrl : dev.EnvironmentConfig.baseUrl;
  static const String geminiApiKey = kReleaseMode ? prod.EnvironmentConfig.geminiApiKey : dev.EnvironmentConfig.geminiApiKey;
}
