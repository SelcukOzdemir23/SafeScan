import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safescan_flutter/src/utils/constants.dart';
import 'package:safescan_flutter/src/utils/url_validator.dart';

class InputBottomSheet extends StatefulWidget {
  final Function(String) onUrlSubmitted;
  final Function(File) onImageSelected;

  const InputBottomSheet({
    super.key,
    required this.onUrlSubmitted,
    required this.onImageSelected,
  });

  @override
  State<InputBottomSheet> createState() => _InputBottomSheetState();
}

class _InputBottomSheetState extends State<InputBottomSheet> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        widget.onImageSelected(File(image.path));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitUrl() {
    if (_formKey.currentState?.validate() ?? false) {
      final url = _urlController.text.trim();
      widget.onUrlSubmitted(url);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppConstants.standardPadding,
        right: AppConstants.standardPadding,
        top: AppConstants.standardPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Check URL Safety',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideY(begin: 0.3),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                hintText: 'https://example.com',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (_) => _submitUrl(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a URL';
                }
                final sanitizedUrl = sanitizeUrl(value);
                if (sanitizedUrl == null || !isValidUrl(sanitizedUrl)) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload QR Image'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitUrl,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(_isLoading ? 'Checking...' : 'Check URL'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
