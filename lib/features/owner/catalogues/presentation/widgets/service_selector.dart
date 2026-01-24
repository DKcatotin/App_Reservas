// lib/features/owner/catalogues/presentation/widgets/service_selector.dart

import 'package:flutter/material.dart';
import '../../domain/entities/service_entity.dart';

/// Widget reutilizable para seleccionar servicios de un catálogo
/// Usado en appointments, invoices, etc.
class ServiceSelector extends StatelessWidget {
  final List<ServiceEntity> services;
  final Set<String> selectedIds;
  final Function(String) onToggle;
  final bool showPrices;

  const ServiceSelector({
    super.key, 
    required this.services,
    required this.selectedIds,
    required this.onToggle,
    this.showPrices = true,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: services.map((service) {
        return ServiceListItem(
          service: service,
          isSelected: selectedIds.contains(service.id),
          onToggle: () => onToggle(service.id),
          showPrice: showPrices,
        );
      }).toList(),
    );
  }

  /// Estado vacío cuando no hay servicios
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No hay servicios disponibles',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget interno para mostrar cada servicio individual como item seleccionable
class ServiceListItem extends StatelessWidget {
  final ServiceEntity service;
  final bool isSelected;
  final VoidCallback onToggle;
  final bool showPrice;

  const ServiceListItem({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onToggle,
    this.showPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF7C3AED).withValues(alpha: 0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF7C3AED) : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (_) => onToggle(),
        title: Text(
          service.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? const Color(0xFF7C3AED)
                : const Color(0xFF1F2937),
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(service.durationLabel),
            if (showPrice) ...[
              const SizedBox(width: 12),
              const Icon(Icons.attach_money, size: 14, color: Colors.grey),
              Text('\$${service.basePrice.toStringAsFixed(2)}'),
            ],
          ],
        ),
        activeColor: const Color(0xFF7C3AED),
      ),
    );
  }
}
