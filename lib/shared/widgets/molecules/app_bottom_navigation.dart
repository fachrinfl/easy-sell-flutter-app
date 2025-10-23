import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<AppBottomNavigationItem> items;
  final Function(int) onTap;
  final AppBottomNavigationVariant variant;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.variant = AppBottomNavigationVariant.standard,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: isIOS
            ? Border(top: BorderSide(color: AppColors.outline, width: 0.5))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: isIOS ? 8 : 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: isIOS ? 60.0 : 70.0,
          padding: EdgeInsets.symmetric(
            horizontal: isIOS ? 0 : 4.0,
            vertical: isIOS ? 0 : 2.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isIOS ? 6.0 : 4.0,
                        horizontal: 4.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 22.0,
                            color: isSelected
                                ? (selectedItemColor ??
                                      theme.colorScheme.primary)
                                : (unselectedItemColor ??
                                      theme.colorScheme.onSurface.withOpacity(
                                        0.6,
                                      )),
                          ),
                          SizedBox(height: isIOS ? 2.0 : 1.0),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: isIOS ? 10.0 : 9.0,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? (selectedItemColor ??
                                        theme.colorScheme.primary)
                                  : (unselectedItemColor ??
                                        theme.colorScheme.onSurface.withOpacity(
                                          0.6,
                                        )),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.badge != null) ...[
                            SizedBox(height: isIOS ? 2.0 : 1.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.badge.toString(),
                                style: TextStyle(
                                  fontSize: isIOS ? 10 : 8,
                                  color: AppColors.onError,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class AppBottomNavigationItem {
  final IconData icon;
  final String label;
  final int? badge;

  const AppBottomNavigationItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

enum AppBottomNavigationVariant { standard, compact, extended }
