import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: MAKE THIS LOOK GOOD!
    return Center(child: CircularProgressIndicator());
  }
}
