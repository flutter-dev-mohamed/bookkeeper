import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String? note;

  const NoteCard({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    if (note == null || note!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notes_outlined),
                SizedBox(width: 8),
                Text(
                  'ملاحظة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(note!, style: const TextStyle(fontSize: 15, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
