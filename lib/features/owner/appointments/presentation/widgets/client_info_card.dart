// lib/features/owner/appointments/presentation/widgets/client_info_card.dart

import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:flutter/material.dart';

/// Widget que muestra la información del cliente en el detalle de la cita
/// Incluye: nombre (editable), teléfono (editable con acción de WhatsApp)
class ClientInfoCard extends StatelessWidget {
  final CustomerEntity customer;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback? onWhatsAppTap;

  const ClientInfoCard({
    super.key,
    required this.customer,
    required this.isEditing,
    required this.nameController,
    required this.phoneController,
    this.onWhatsAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cliente',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // NOMBRE (editable o solo lectura)
            _buildNameField(),
            
            const SizedBox(height: 12),
            
            // TELÉFONO (editable o con acción de WhatsApp)
            _buildPhoneField(),
          ],
        ),
      ),
    );
  }

  /// Campo de nombre (editable o solo lectura)
  Widget _buildNameField() {
    if (isEditing) {
      return TextField(
        controller: nameController,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'Nombre del cliente',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      );
    }

    // Modo solo lectura
    return Text(
      nameController.text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  /// Campo de teléfono (editable o con acción de WhatsApp)
  Widget _buildPhoneField() {
    if (isEditing) {
      return TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Número de teléfono',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          prefixIcon: const Icon(
            Icons.phone_rounded,
            color: Colors.white,
            size: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
        ),
      );
    }

    // Modo solo lectura con acción de WhatsApp
    return GestureDetector(
      onTap: onWhatsAppTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.phone_rounded,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              phoneController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onWhatsAppTap != null) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
