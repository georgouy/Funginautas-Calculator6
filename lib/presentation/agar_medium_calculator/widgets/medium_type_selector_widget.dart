import 'package:flutter/material.dart';
import '../../../core/localization.dart';

class MediumTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const MediumTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.translate("mediumTypeSelection"),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTypeChanged('PDA'),
                    child: _buildMediumOption(
                      'PDA',
                      AppLocalizations.translate("pdaDescription"),
                      selectedType == 'PDA',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTypeChanged('MEA'),
                    child: _buildMediumOption(
                      'MEA',
                      AppLocalizations.translate("meaDescription"),
                      selectedType == 'MEA',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              selectedType == 'PDA'
                  ? AppLocalizations.translate("pdaFullDescription")
                  : AppLocalizations.translate("meaFullDescription"),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumOption(String type, String description, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

