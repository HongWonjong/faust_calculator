import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SidebarMenu extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onItemSelected;

  const SidebarMenu({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: AppTheme.backgroundDark,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItem == item.toLowerCase();
          return ListTile(
            title: Text(
              item,
              style: AppTheme.bodyText.copyWith(
                color: isSelected ? AppTheme.secondaryColor : AppTheme.textColor,
              ),
            ),
            tileColor: isSelected
                ? AppTheme.secondaryColor.withOpacity(0.1)
                : Colors.transparent,
            onTap: () => onItemSelected(item.toLowerCase()),
          );
        },
      ),
    );
  }
}