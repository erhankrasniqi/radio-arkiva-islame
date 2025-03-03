import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ContactDetails extends StatefulWidget {
  const ContactDetails({super.key});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _messageError;
  bool _isLoading = false;
  bool _isSent = false;
  DateTime? _lastSubmissionTime;

  bool get _isFormValid =>
      _nameError == null &&
      _emailError == null &&
      _messageError == null &&
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _messageController.text.isNotEmpty;

  void _validateAndSubmit() async {
    setState(() {
      _nameError = _validateName(_nameController.text);
      _emailError = _validateEmail(_emailController.text);
      _messageError = _validateMessage(_messageController.text);
    });

    if (_formKey.currentState!.validate()) {
      if (_lastSubmissionTime != null &&
          DateTime.now().difference(_lastSubmissionTime!) <
              const Duration(minutes: 10)) {
        _showSnackbar("Ju mund të dërgoni vetëm një mesazh çdo 10 minuta.");
        return;
      }

      setState(() {
        _isLoading = true;
      });

      bool success = await _sendFormData();

      setState(() {
        _isLoading = false;
        if (success) {
          _isSent = true;
          _lastSubmissionTime = DateTime.now();
        }
      });

      if (success) {
        _showSnackbar("Mesazhi u dërgua me sukses!");
        _clearForm();
      } else {
        _showSnackbar("Dështoi dërgimi i mesazhit. Provo përsëri.");
      }
    }
  }

  Future<bool> _sendFormData() async {
    const String url = "https://formspree.io/f/mldgkppv";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text,
        "email": _emailController.text,
        "message": _messageController.text,
      }),
    );

    return response.statusCode == 200;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {
      _isSent = false;
    });
  }

  String? _validateName(String value) {
    if (value.isEmpty) return 'Ju lutemi shkruani emrin tuaj';
    if (value.length < 2) return 'Emri duhet të ketë të paktën 2 karaktere';
    if (value.length > 30) {
      return 'Emri nuk mund të jetë më shumë se 30 karaktere';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Ju lutemi shkruani emailin tuaj';
    if (value.length > 30) {
      return 'Email-i nuk mund të jetë më shumë se 30 karaktere';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ju lutemi shkruani një email të vlefshëm';
    }
    return null;
  }

  String? _validateMessage(String value) {
    if (value.isEmpty) return 'Ju lutemi shkruani mesazhin tuaj';
    if (value.length < 15) {
      return 'Mesazhi duhet të ketë të paktën 15 karaktere';
    }
    if (value.length > 300) {
      return 'Mesazhi nuk mund të jetë më shumë se 300 karaktere';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Na Shkruani'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Faleminderit që dëshironi të na kontaktoni!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                "Plotësoni formularin më poshtë dhe ne do t'ju përgjigjemi sa më shpejt të jetë e mundur.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12.0),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 8.0,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Emri',
                        errorText: _nameError,
                      ),
                      maxLength: 30,
                      onChanged: (value) {
                        setState(() {
                          _nameError = _validateName(value);
                        });
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Email',
                        errorText: _emailError,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 30,
                      onChanged: (value) {
                        setState(() {
                          _emailError = _validateEmail(value);
                        });
                      },
                    ),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Mesazhi',
                        errorText: _messageError,
                      ),
                      maxLength: 300,
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          _messageError = _validateMessage(value);
                        });
                      },
                    ),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed:
                                _isFormValid && !_isSent
                                    ? _validateAndSubmit
                                    : null,
                            child: const Text("Dërgoni mesazhin"),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
