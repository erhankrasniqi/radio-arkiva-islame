import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'dart:convert';
import 'dart:async';

import 'package:radio_arkiva_islame/constants/strings.dart';

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
        _showSnackbar(Strings.message10Minutes);
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
        _showSnackbar(Strings.messageSuccess);
        _clearForm();
      } else {
        _showSnackbar(Strings.messageFailed);
      }
    }
  }

  Future<bool> _sendFormData() async {
    const String url = FormSpree.endpoint;
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
    if (value.isEmpty) return Strings.writeName;
    if (value.length < 2) return Strings.nameAtLeast2;
    if (value.length > 30) {
      return Strings.nameNoMoreThan30;
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return Strings.writeEmail;
    if (value.length > 30) {
      return Strings.emailNoMoreThan30;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return Strings.validEmail;
    }
    return null;
  }

  String? _validateMessage(String value) {
    if (value.isEmpty) return Strings.writeMessage;
    if (value.length < 15) {
      return Strings.messageAtLeast15;
    }
    if (value.length > 300) {
      return Strings.messageNoMoreThan300;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.writeUs), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.contactThankYou,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                Strings.fillForm,
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
                        labelText: Strings.name,
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
                        labelText: Strings.email,
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
                        labelText: Strings.message,
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
                            child: const Text(Strings.sendMessage),
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
