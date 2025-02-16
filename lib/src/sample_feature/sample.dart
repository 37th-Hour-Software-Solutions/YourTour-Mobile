import 'package:flutter/material.dart';

import '../core/widgets/auth_middleware.dart';

class Sample extends StatelessWidget {
  static const routeName = '/sample';

  const Sample({super.key});


  @override
  Widget build(BuildContext context) {
    return AuthMiddleware(
      child: _SampleItemListContent(),
    );
  }
}

class _SampleItemListContent extends StatelessWidget {
  const _SampleItemListContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample'),
      ), 
      body: const Center(
        child: Text('Sample'),
      ),
    );
  }
}
