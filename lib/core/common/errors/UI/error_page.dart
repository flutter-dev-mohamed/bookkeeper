import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //
          Image.asset('lib/core/assets/error.png', width: 50),
          Text("Error!.", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
