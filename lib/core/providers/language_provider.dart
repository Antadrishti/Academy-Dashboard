import 'package:flutter/material.dart';
import '../services/translation_service.dart';

/// Language Provider for managing app language state
class LanguageProvider extends ChangeNotifier {
  final TranslationService _translationService = TranslationService();
  
  bool _isInitialized = false;
  bool _isDownloading = false;
  double _downloadProgress = 0;
  String? _downloadingLanguage;
  String? _error;

  bool get isInitialized => _isInitialized;
  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  String? get downloadingLanguage => _downloadingLanguage;
  String? get error => _error;
  
  AppLanguage get currentLanguage => _translationService.currentLanguage;
  List<AppLanguage> get availableLanguages => AppLanguage.values.toList();

  /// Initialize the language provider
  Future<void> initialize() async {
    try {
      await _translationService.initialize();
      _isInitialized = true;
      _error = null;
    } catch (e) {
      debugPrint('LanguageProvider initialization error: $e');
      _error = e.toString();
      _isInitialized = true; // Still mark as initialized so app can continue
    }
    notifyListeners();
  }

  /// Change the app language
  Future<void> changeLanguage(AppLanguage language) async {
    if (language == currentLanguage) return;

    try {
      // Check if model needs downloading
      if (language != AppLanguage.english) {
        final isDownloaded = await _translationService.isModelDownloaded(language);
        
        if (!isDownloaded) {
          _isDownloading = true;
          _downloadingLanguage = language.displayName;
          _downloadProgress = 0;
          notifyListeners();

          try {
            await _translationService.downloadModel(language);
          } finally {
            _isDownloading = false;
            _downloadingLanguage = null;
            notifyListeners();
          }
        }
      }

      await _translationService.setLanguage(language);
      _error = null;
    } catch (e) {
      debugPrint('Language change error: $e');
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Translate a string
  Future<String> translate(String text) async {
    try {
      return await _translationService.translate(text);
    } catch (e) {
      debugPrint('Translation error: $e');
      return text; // Return original text on error
    }
  }

  /// Check if a language model is downloaded
  Future<bool> isModelDownloaded(AppLanguage language) async {
    try {
      if (language == AppLanguage.english) return true;
      return await _translationService.isModelDownloaded(language);
    } catch (e) {
      return false;
    }
  }

  /// Delete a language model to free up space
  Future<void> deleteLanguageModel(AppLanguage language) async {
    try {
      if (language == AppLanguage.english) return;
      await _translationService.deleteModel(language);
    } catch (e) {
      debugPrint('Delete model error: $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _translationService.dispose();
    super.dispose();
  }
}
