import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/language_provider.dart';
import '../../core/services/translation_service.dart';

/// A text widget that automatically translates its content
class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool selectable;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;

  @override
  void initState() {
    super.initState();
    _translateText();
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translateText();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translateText();
  }

  Future<void> _translateText() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    // If English, use original text
    if (languageProvider.currentLanguage == AppLanguage.english) {
      if (_translatedText != widget.text) {
        setState(() => _translatedText = widget.text);
      }
      return;
    }

    // Translate
    try {
      final translated = await languageProvider.translate(widget.text);
      if (mounted) {
        setState(() {
          _translatedText = translated;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedText = widget.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to language changes to trigger rebuild
    Provider.of<LanguageProvider>(context);
    
    final displayText = _translatedText ?? widget.text;

    if (widget.selectable) {
      return SelectableText(
        displayText,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
      );
    }

    return Text(
      displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}

/// Extension to easily translate strings
extension StringTranslation on String {
  /// Get translation using context
  Future<String> tr(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return await languageProvider.translate(this);
  }
}

/// Shorthand widget for common translated text scenarios
class TrText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TrText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return TranslatedText(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}
