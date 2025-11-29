import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English', TranslateLanguage.english),
  hindi('hi', 'हिंदी', TranslateLanguage.hindi),
  tamil('ta', 'தமிழ்', TranslateLanguage.tamil),
  telugu('te', 'తెలుగు', TranslateLanguage.telugu),
  marathi('mr', 'मराठी', TranslateLanguage.marathi),
  bengali('bn', 'বাংলা', TranslateLanguage.bengali),
  gujarati('gu', 'ગુજરાતી', TranslateLanguage.gujarati),
  kannada('kn', 'ಕನ್ನಡ', TranslateLanguage.kannada);

  final String code;
  final String displayName;
  final TranslateLanguage mlKitLanguage;

  const AppLanguage(this.code, this.displayName, this.mlKitLanguage);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Translation Service using Google ML Kit
class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final Map<String, OnDeviceTranslator> _translators = {};
  final Map<String, String> _translationCache = {};
  OnDeviceTranslatorModelManager? _modelManager;

  AppLanguage _currentLanguage = AppLanguage.english;
  AppLanguage get currentLanguage => _currentLanguage;

  /// Initialize service and load saved language preference
  Future<void> initialize() async {
    try {
      _modelManager = OnDeviceTranslatorModelManager();
      
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('app_language') ?? 'en';
      _currentLanguage = AppLanguage.fromCode(savedLanguage);
      
      // Pre-download the current language model if not English
      if (_currentLanguage != AppLanguage.english) {
        try {
          await _ensureModelDownloaded(_currentLanguage);
        } catch (e) {
          debugPrint('Failed to pre-download language model: $e');
          // Fall back to English if model download fails
          _currentLanguage = AppLanguage.english;
        }
      }
    } catch (e) {
      debugPrint('TranslationService initialization error: $e');
      _currentLanguage = AppLanguage.english;
    }
  }

  /// Set the current language
  Future<void> setLanguage(AppLanguage language) async {
    _currentLanguage = language;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', language.code);
    } catch (e) {
      debugPrint('Failed to save language preference: $e');
    }
    
    // Clear cache when language changes
    _translationCache.clear();
    
    // Ensure model is downloaded
    if (language != AppLanguage.english) {
      await _ensureModelDownloaded(language);
    }
  }

  /// Check if a language model is downloaded
  Future<bool> isModelDownloaded(AppLanguage language) async {
    try {
      if (_modelManager == null) return false;
      return await _modelManager!.isModelDownloaded(language.mlKitLanguage.bcpCode);
    } catch (e) {
      debugPrint('isModelDownloaded error: $e');
      return false;
    }
  }

  /// Download a language model
  Future<void> downloadModel(AppLanguage language) async {
    try {
      if (_modelManager == null) {
        _modelManager = OnDeviceTranslatorModelManager();
      }
      await _modelManager!.downloadModel(language.mlKitLanguage.bcpCode);
    } catch (e) {
      debugPrint('downloadModel error: $e');
      rethrow;
    }
  }

  /// Delete a language model
  Future<void> deleteModel(AppLanguage language) async {
    try {
      if (_modelManager == null) return;
      await _modelManager!.deleteModel(language.mlKitLanguage.bcpCode);
    } catch (e) {
      debugPrint('deleteModel error: $e');
    }
  }

  /// Ensure model is downloaded
  Future<void> _ensureModelDownloaded(AppLanguage language) async {
    final isDownloaded = await isModelDownloaded(language);
    if (!isDownloaded) {
      await downloadModel(language);
    }
  }

  /// Get or create translator for a language
  OnDeviceTranslator _getTranslator(AppLanguage targetLanguage) {
    final key = '${AppLanguage.english.code}_${targetLanguage.code}';
    
    if (!_translators.containsKey(key)) {
      _translators[key] = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: targetLanguage.mlKitLanguage,
      );
    }
    
    return _translators[key]!;
  }

  /// Translate a string
  Future<String> translate(String text) async {
    // If current language is English, return original text
    if (_currentLanguage == AppLanguage.english) {
      return text;
    }

    // Check cache first
    final cacheKey = '${_currentLanguage.code}_$text';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    try {
      // Ensure model is downloaded
      final isDownloaded = await isModelDownloaded(_currentLanguage);
      if (!isDownloaded) {
        // Return original if model not available
        return text;
      }

      final translator = _getTranslator(_currentLanguage);
      final translated = await translator.translateText(text);
      
      // Cache the translation
      _translationCache[cacheKey] = translated;
      
      return translated;
    } catch (e) {
      debugPrint('Translation error: $e');
      return text; // Return original text on error
    }
  }

  /// Translate multiple strings at once
  Future<Map<String, String>> translateBatch(List<String> texts) async {
    final results = <String, String>{};
    
    for (final text in texts) {
      results[text] = await translate(text);
    }
    
    return results;
  }

  /// Dispose all translators
  void dispose() {
    for (final translator in _translators.values) {
      translator.close();
    }
    _translators.clear();
    _translationCache.clear();
  }
}
