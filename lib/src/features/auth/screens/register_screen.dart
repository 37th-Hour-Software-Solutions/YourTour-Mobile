import 'package:flutter/material.dart';
import '../models/register_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/models/states.dart';
import '../../../core/models/interests.dart';
import '../../../core/widgets/form_text_field.dart';
import '../../../core/widgets/form_dropdown.dart';
import '../../../core/widgets/form_chips.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({
    super.key,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedState;
  Set<String> _selectedInterests = {};
  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInterests.isEmpty) {
      setState(() {
        _error = 'Please select at least one interest';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.register(
        RegisterRequest(
          email: _emailController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          homestate: _selectedState!,
          interests: _selectedInterests.toList(),
        ),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            FormTextField(
              controller: _usernameController,
              label: 'Username',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            FormTextField(
              controller: _phoneController,
              label: 'Phone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            FormDropdown(
              value: _selectedState,
              label: 'Home State',
              icon: Icons.location_on_outlined,
              items: states,
              onChanged: (value) => setState(() => _selectedState = value),
              validator: (value) {
                if (value == null) {
                  return 'Please select your home state';
                }
                return null;
              },
            ),
            FormChips(
              label: 'Interests',
              options: interests,
              selectedValues: _selectedInterests,
              onChanged: (values) => setState(() => _selectedInterests = values),
            ),
            FormTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outlined,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _register,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Account'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
} 