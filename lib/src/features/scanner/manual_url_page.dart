import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';
import 'package:safescan_flutter/src/services/url_safety_service.dart';
import 'package:safescan_flutter/src/utils/constants.dart';
import 'package:safescan_flutter/src/utils/url_validator.dart';

class ManualUrlPage extends StatefulWidget {
  final String? prefill;
  const ManualUrlPage({super.key, this.prefill});

  @override
  State<ManualUrlPage> createState() => _ManualUrlPageState();
}

class _ManualUrlPageState extends State<ManualUrlPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final UrlSafetyService _urlSafetyService = UrlSafetyService();
  String? _error;
  bool _isLoading = false;
  bool _hasText = false;
  String? _sanitizedUrl;

  @override
  void initState() {
    super.initState();
    if (widget.prefill != null) {
      _controller.text = widget.prefill!;
      _hasText = widget.prefill!.isNotEmpty;

      // If prefilled, validate the URL
      final sanitized = sanitizeUrl(widget.prefill!.trim());
      if (sanitized != null && isValidUrl(sanitized)) {
        _sanitizedUrl = sanitized;
      }
    }

    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }

      // Validate URL as user types
      if (hasText) {
        final sanitized = sanitizeUrl(_controller.text.trim());
        if (sanitized != null && isValidUrl(sanitized)) {
          if (_error != null) {
            setState(() {
              _error = null;
              _sanitizedUrl = sanitized;
            });
          } else {
            _sanitizedUrl = sanitized;
          }
        }
      }
    });

    // Focus the text field after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final url = _controller.text.trim();
    final sanitized = sanitizeUrl(url);
    if (sanitized == null || !isValidUrl(sanitized)) {
      setState(() => _error = AppConstants.invalidUrlMessage);
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
      _sanitizedUrl = sanitized;
    });

    try {
      // Check URL safety
      final safetyResult = await _urlSafetyService.checkUrlSafety(sanitized);

      if (mounted) {
        // Navigate to result screen with safety information
        Navigator.pushNamed(
          context,
          '/result',
          arguments: safetyResult,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error checking URL safety: $e';
        });
      }
    }
  }

  void _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      final text = clipboardData!.text!;
      _controller.text = text;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
    }
  }

  void _clearText() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter URL Manually'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('URL Entry Help'),
                  content: const Text(
                    'Enter a URL to check its safety before visiting. '
                    'You can paste a URL from your clipboard or type it manually. '
                    'Make sure to include the full URL including http:// or https://.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  MdiIcons.link,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 32),
              Text(
                'Enter URL to Check',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
              const SizedBox(height: 16),
              Text(
                'Type or paste a URL to verify its safety before visiting',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withAlpha(180),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          labelText: 'URL',
                          hintText: 'https://example.com',
                          prefixIcon: Icon(
                            MdiIcons.web,
                            color: _error != null
                                ? colorScheme.error
                                : colorScheme.primary,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_hasText)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearText,
                                  tooltip: 'Clear',
                                ),
                              IconButton(
                                icon: const Icon(Icons.content_paste),
                                onPressed: _pasteFromClipboard,
                                tooltip: 'Paste',
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorText: _error,
                          errorMaxLines: 2,
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (_) => _submit(),
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading || !_hasText ? null : _submit,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.security),
                          label: Text(
                            _isLoading ? 'Checking...' : 'Check URL Safety',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      if (_isLoading && _sanitizedUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            children: [
                              const LinearProgressIndicator(),
                              const SizedBox(height: 12),
                              Text(
                                'Checking URL safety:',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(180),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _sanitizedUrl!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(
                    begin: 0.2,
                    end: 0,
                    delay: 600.ms,
                    duration: 500.ms,
                    curve: Curves.easeOutQuad,
                  ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Scanner'),
              ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
