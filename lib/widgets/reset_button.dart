import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback? onPressed;
  const ResetButton({
    super.key,
    required this.colorScheme,
    required this.isDark,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    colorScheme.surface.withOpacity(0.1),
                    colorScheme.surface.withOpacity(0.05),
                  ]
                  : [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.6),
                  ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reset',
                    style: TextStyle(
                      color: isDark ? Colors.white : colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
