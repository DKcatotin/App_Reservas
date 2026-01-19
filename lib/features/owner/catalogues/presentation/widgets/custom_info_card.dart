// lib/features/owner/shared/widgets/custom_info_card.dart

import 'package:flutter/material.dart';

/// Widget base reutilizable para mostrar tarjetas de información
/// Puede usarse con gradiente o color sólido
class CustomInfoCard extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Gradient? gradient;
  final String title;
  final Widget child;
  final Color? backgroundColor;

  const CustomInfoCard({
    super.key,
    required this.icon,
    this.iconColor,
    this.gradient,
    required this.title,
    required this.child,
    this.backgroundColor,
  }) : assert(
          gradient != null || backgroundColor != null,
          'Debes proporcionar gradient o backgroundColor',
        );

  /// Constructor para tarjetas con gradiente (estilo moderno)
  const CustomInfoCard.gradient({
    super.key,
    required this.icon,
    required Gradient gradient,
    required this.title,
    required this.child,
  })  : iconColor = Colors.white,
        gradient = gradient,
        backgroundColor = null;

  /// Constructor para tarjetas con fondo blanco
  const CustomInfoCard.white({
    super.key,
    required this.icon,
    required Color iconColor,
    required this.title,
    required this.child,
  })  : iconColor = iconColor,
        gradient = null,
        backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final bool hasGradient = gradient != null;
    final Color effectiveIconColor = iconColor ?? Colors.white;
    final Color effectiveTitleColor =
        hasGradient ? Colors.white : const Color(0xFF1F2937);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: hasGradient
                ? const Color(0xFF7C3AED).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: hasGradient ? 15 : 10,
            offset: Offset(0, hasGradient ? 8 : 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasGradient
                        ? Colors.white.withValues(alpha: 0.2)
                        : effectiveIconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: effectiveTitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Contenido
            child,
          ],
        ),
      ),
    );
  }
}
