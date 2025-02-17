import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../../../core/providers/providers.dart';
import '../../../core/models/states.dart';
import '../../../core/models/interests.dart';
import '../../../core/widgets/form_text_field.dart';
import '../../../core/widgets/form_dropdown.dart';
import '../../../core/widgets/form_chips.dart';

class EditProfileForm extends ConsumerStatefulWidget {
  const EditProfileForm({super.key});

  @override
  ConsumerState<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _newPasswordController;
  late TextEditingController _oldPasswordController;
  String? _selectedState;
  Set<String> _selectedInterests = {};

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _newPasswordController = TextEditingController();
    _oldPasswordController = TextEditingController();

    // Load user data
    final user = ref.read(profileProvider).value;
    if (user != null) {
      _emailController.text = user.email;
      _usernameController.text = user.username;
      _phoneController.text = user.phone;
      _selectedState = user.homestate;
      _selectedInterests = user.interests.map((i) => i['name'] as String).toSet();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            controller: _newPasswordController,
            label: 'New Password (optional)',
            icon: Icons.lock_outlined,
            obscureText: true,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          FormTextField(
            controller: _oldPasswordController,
            label: 'Current Password',
            icon: Icons.lock_outlined,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Current password is required to save changes';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _handleSubmit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Save Changes'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        homestate: _selectedState ?? '',
        interests: _selectedInterests.map((name) => {'name': name}).toList(),
        profilePictureBlob: '',  // Keep existing
        badges: const [],  // Keep existing
        gems: const [],   // Keep existing
        gemsFound: 0,     // Keep existing
        badgesFound: 0,   // Keep existing
        citiesFound: 0,   // Keep existing
        statesFound: 0,   // Keep existing
      );

      ref.read(profileServiceProvider).updateUser(
        updatedUser, 
        _newPasswordController.text, 
        _oldPasswordController.text
      ).then((_) {
        ref.invalidate(profileProvider);
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }
  }
} 