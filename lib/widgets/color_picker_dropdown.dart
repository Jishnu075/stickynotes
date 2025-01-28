import 'package:flutter/material.dart';
import 'package:stickynotes/screens/add_note_screen.dart';
import 'package:stickynotes/screens/home_screen.dart';

class ColorPickerDropdown extends StatelessWidget {
  final NoteColors selectedColor;
  final Function(NoteColors) onColorSelected;

  const ColorPickerDropdown({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  String _formatName(String enumName) {
    final formattedName = enumName.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );
    return formattedName
        .trim()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<NoteColors>(
            value: selectedColor,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            isExpanded: true,
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            items: NoteColors.values.map((color) {
              return DropdownMenuItem<NoteColors>(
                value: color,
                child: Row(
                  children: [
                    Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color: getCardColor(colorHEX: color.hexCode),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.black12,
                              width: 1,
                            ))),
                    const SizedBox(width: 12),
                    Text(_formatName(color.name),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        )),
                  ],
                ),
              );
            }).toList(),
            onChanged: (NoteColors? newColor) {
              if (newColor != null) {
                onColorSelected(newColor);
              }
            }),
      ),
    );
  }
}
