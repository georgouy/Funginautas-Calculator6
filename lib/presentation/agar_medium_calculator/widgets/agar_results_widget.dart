import 'package:flutter/material.dart';
import '../../../core/localization.dart';

class AgarResultsWidget extends StatelessWidget {
  final Map<String, double> results;
  final String mediumType;
  final double volume;

  const AgarResultsWidget({
    Key? key,
    required this.results,
    required this.mediumType,
    required this.volume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.science,
                      color: Color(0xFF2E7D32),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.translate('calculatedAmounts'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${AppLocalizations.translate("mediumType")}: $mediumType',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${AppLocalizations.translate("totalVolume")}: ${volume.toStringAsFixed(0)} ml',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // Ingredientes específicos por tipo
                if (mediumType == 'PDA') ..._buildPDAResults(),
                if (mediumType == 'MEA') ..._buildMEAResults(),
                
                const SizedBox(height: 16),
                
                // Nota sobre variação do ágar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.translate("agarVariationNote"),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Instruções de preparo
        if (mediumType == 'PDA') _buildPDAInstructions(),
        if (mediumType == 'MEA') _buildMEAInstructions(),
        
        const SizedBox(height: 24),
        
        // Botões de ação
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implementar salvar no histórico
                },
                icon: const Icon(Icons.save),
                label: Text(AppLocalizations.translate('saveToHistory')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implementar compartilhar receita
                },
                icon: const Icon(Icons.share),
                label: Text(AppLocalizations.translate('shareRecipe')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPDAResults() {
    return [
      _buildIngredientRow(
        AppLocalizations.translate("potatoBroth"),
        results['potatoBroth']!,
        'ml',
        Icons.local_drink,
      ),
      _buildIngredientRow(
        AppLocalizations.translate("glucose"),
        results['glucose']!,
        'g',
        Icons.grain,
      ),
      _buildIngredientRow(
        AppLocalizations.translate("agar"),
        results['agar']!,
        'g',
        Icons.science,
      ),
    ];
  }

  List<Widget> _buildMEAResults() {
    return [
      _buildIngredientRow(
        AppLocalizations.translate("water"),
        results['water']!,
        'ml',
        Icons.water_drop,
      ),
      _buildIngredientRow(
        AppLocalizations.translate("maltExtract"),
        results['maltExtract']!,
        'g',
        Icons.grain,
      ),
      _buildIngredientRow(
        AppLocalizations.translate("agar"),
        results['agar']!,
        'g',
        Icons.science,
      ),
    ];
  }

  Widget _buildIngredientRow(String name, double amount, String unit, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${amount.toStringAsFixed(1)} $unit',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPDAInstructions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.menu_book,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.translate("preparationInstructions"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.translate("pdaPreparationInstructions"),
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMEAInstructions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.menu_book,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.translate("preparationInstructions"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.translate("meaPreparationInstructions"),
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

