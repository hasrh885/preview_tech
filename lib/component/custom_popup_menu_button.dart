import 'package:denomination/resources/color.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<CustomPopupMenuItem> items;
  const CustomPopupMenuButton({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: black,
      icon: Icon(Icons.more_vert, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (context) => items.asMap().entries.map((entry) {
        int index = entry.key;
        CustomPopupMenuItem item = entry.value;

        return PopupMenuItem<int>(
          value: index,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the popup menu
              item.onTap?.call();
            },
            child: Row(
              children: [
                Icon(item.icon, color: Colors.lightBlue),
                SizedBox(width: 8),
                Text(
                  item.text,
                  style: TextStyle(fontSize: 16, color: white),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}


class CustomPopupMenuItem {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  CustomPopupMenuItem({
    required this.icon,
    required this.text,
    this.onTap,
  });
}
