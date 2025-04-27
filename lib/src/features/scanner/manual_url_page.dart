import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefill != null) {
      _controller.text = widget.prefill!;
    }
  }

  void _submit() {
    final url = _controller.text.trim();
    final sanitized = sanitizeUrl(url);
    if (sanitized == null || !isValidUrl(sanitized)) {
      setState(() => _error = AppConstants.invalidUrlMessage);
      return;
    }
    setState(() {
      _error = null;
      _isLoading = true;
    });
    Navigator.pushReplacementNamed(context, '/scanner',
        arguments: {'action': 'manual', 'prefill': sanitized});
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF008080);
    return Scaffold(
      appBar: AppBar(title: const Text('Enter URL Manually')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard, size: 64, color: accentColor),
              const SizedBox(height: 16),
              Text('Enter a URL to check its safety.',
                  style: GoogleFonts.inter(fontSize: 18)),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  errorText: _error,
                ),
                keyboardType: TextInputType.url,
                onSubmitted: (_) => _submit(),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Check URL', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
