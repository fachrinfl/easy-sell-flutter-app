import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'EasySell POS';

  static const String appVersion = '1.0.0';

  static const String buildNumber = '1';

  static const String appDescription = 'Simple Point of Sale for Small Business';

  static const String packageName = 'com.easysell.pos';

  static const String bundleIdentifier = 'com.easysell.pos';

  static const int minSdkVersion = 21;

  static const int targetSdkVersion = 34;

  static const int compileSdkVersion = 34;

  static const ThemeMode themeMode = ThemeMode.system;

  static const bool debugMode = true;

  static const bool productionMode = false;

  static const bool analyticsEnabled = true;

  static const bool crashReportingEnabled = true;

  static const bool performanceMonitoringEnabled = true;

  static const bool remoteConfigEnabled = true;

  static const bool abTestingEnabled = false;

  static const Map<String, bool> featureFlags = {
    'pos_enabled': true,
    'inventory_enabled': true,
    'reports_enabled': true,
    'analytics_enabled': true,
    'offline_mode': true,
    'multi_user': false,
    'cloud_sync': true,
    'receipt_printing': true,
    'barcode_scanning': true,
    'payment_processing': true,
  };

  static const Map<String, String> apiEndpoints = {
    'base_url': 'https://api.easysell.pos',
    'auth_url': 'https://auth.easysell.pos',
    'storage_url': 'https://storage.easysell.pos',
    'analytics_url': 'https://analytics.easysell.pos',
  };

  static const Map<String, dynamic> databaseConfig = {
    'name': 'easysell_pos.db',
    'version': 1,
    'backup_enabled': true,
    'sync_interval': 300,
  };

  static const Map<String, dynamic> cacheConfig = {
    'max_size': 100 * 1024 * 1024,
    'ttl': 3600,
    'cleanup_interval': 1800,
  };

  static const Map<String, dynamic> securityConfig = {
    'encryption_enabled': true,
    'biometric_auth': true,
    'session_timeout': 1800,
    'max_login_attempts': 5,
  };

  static const Map<String, dynamic> performanceConfig = {
    'lazy_loading': true,
    'image_optimization': true,
    'memory_management': true,
    'battery_optimization': true,
  };

  static const Map<String, dynamic> accessibilityConfig = {
    'screen_reader_support': true,
    'high_contrast': true,
    'large_text': true,
    'voice_over': true,
  };

  static const Map<String, dynamic> localizationConfig = {
    'supported_languages': ['en', 'es', 'fr', 'de'],
    'default_language': 'en',
    'rtl_support': true,
  };

  static const Map<String, dynamic> notificationConfig = {
    'push_notifications': true,
    'email_notifications': true,
    'sms_notifications': false,
    'sound_enabled': true,
    'vibration_enabled': true,
  };

  static const Map<String, dynamic> updateConfig = {
    'auto_update': true,
    'check_interval': 86400,
    'force_update': false,
    'beta_updates': false,
  };

  static const Map<String, dynamic> loggingConfig = {
    'level': 'info',
    'file_logging': true,
    'console_logging': true,
    'remote_logging': true,
    'max_file_size': 10 * 1024 * 1024,
  };

  static const Map<String, dynamic> monitoringConfig = {
    'crash_reporting': true,
    'performance_monitoring': true,
    'user_analytics': true,
    'error_tracking': true,
  };

  static bool getFeatureFlag(String key) {
    return featureFlags[key] ?? false;
  }

  static String getApiEndpoint(String key) {
    return apiEndpoints[key] ?? '';
  }

  static bool isFeatureEnabled(String feature) {
    return getFeatureFlag(feature);
  }

  static Map<String, dynamic> getAppInfo() {
    return {
      'name': appName,
      'version': appVersion,
      'build': buildNumber,
      'description': appDescription,
      'package': packageName,
      'bundle': bundleIdentifier,
    };
  }

  static Map<String, dynamic> getEnvironmentInfo() {
    return {
      'debug': debugMode,
      'production': productionMode,
      'analytics': analyticsEnabled,
      'crash_reporting': crashReportingEnabled,
      'performance_monitoring': performanceMonitoringEnabled,
      'remote_config': remoteConfigEnabled,
      'ab_testing': abTestingEnabled,
    };
  }
}
