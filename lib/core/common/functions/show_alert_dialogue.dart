import 'package:flutter/cupertino.dart';

// TODO: MAKE THIS FUNCTION SHOW PLATFORM SPECIFIC ALERTDIALOG
void showAlertDialogue({
  required BuildContext context,
  String title = "Error!",
  required String message,
}) => showCupertinoDialog(
  context: context,
  builder: (context) => CupertinoListTile(
    leading: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: CupertinoColors.activeBlue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Icon(
        CupertinoIcons.bell_fill,
        color: CupertinoColors.white,
        size: 20,
      ),
    ),
    title: const Text('Push Notifications'),
    subtitle: const Text('Receive alerts, sounds, and badge counts'),
    trailing: CupertinoSwitch(
      value: true,
      onChanged: (bool value) {
        // Handle toggle state
      },
    ),
  ),
);
