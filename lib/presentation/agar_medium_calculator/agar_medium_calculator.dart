import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/localization.dart';
import '../../widgets/custom_image_widget.dart';
import 'widgets/medium_type_selector_widget.dart';
import 'widgets/agar_results_widget.dart';

class AgarMediumCalculator extends StatefulWidget {
  const AgarMediumCalculator({Key? key}) : super(key: key);

  @override
  State<AgarMediumCalculator> createState() => _AgarMediumCalculatorState();
}

class _AgarMediumCalculatorState extends State<AgarMediumCalculator> {
  final TextEditingController _volumeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _resultsKey = GlobalKey();
  
  String _selectedMediumType = 'PDA'; // PDA ou MEA
  double? _calculatedVolume;
  String? _volumeError;
  bool _isCalculating = false;

  // Resultados calculados
  Map<String, double> _results = {};

  @override
  void dispose() {
    _volumeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateVolume() {
    setState(() {
      _volumeError = null;
    });

    final volumeText = _volumeController.text.trim();
    if (volumeText.isEmpty) {
      setState(() {
        _volumeError = AppLocalizations.translate("pleaseEnterVolume");
      });
      return;
    }

    final volume = double.tryParse(volumeText);
    if (volume == null) {
      setState(() {
        _volumeError = AppLocalizations.translate("pleaseEnterValidNumber");
      });
      return;
    }

    if (volume <= 0) {
      setState(() {
        _volumeError = AppLocalizations.translate("volumeMustBeGreaterThanZero");
      });
      return;
    }

    if (volume > 10000) {
      setState(() {
        _volumeError = AppLocalizations.translate("volumeTooLarge");
      });
      return;
    }

    setState(() {
      _calculatedVolume = volume;
    });
  }

  void _calculateIngredients() {
    _validateVolume();
    
    if (_calculatedVolume == null || _volumeError != null) {
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Simular um pequeno delay para mostrar o loading
    Future.delayed(const Duration(milliseconds: 500), () {
      final volume = _calculatedVolume!;
      
      // Cálculos baseados em 500ml como referência
      final ratio = volume / 500.0;
      
      Map<String, double> results = {};
      
      if (_selectedMediumType == 'PDA') {
        // PDA: 500ml caldo de papas, 10g glucosa, 8g agar
        results['potatoBroth'] = volume; // ml de caldo de papas
        results['glucose'] = 10.0 * ratio; // gramas de glucosa
        results['agar'] = 8.0 * ratio; // gramas de agar
      } else {
        // MEA: 500ml água, 10g extrato de malta, 8g agar
        results['water'] = volume; // ml de água
        results['maltExtract'] = 10.0 * ratio; // gramas de extrato de malta
        results['agar'] = 8.0 * ratio; // gramas de agar
      }
      
      setState(() {
        _results = results;
        _isCalculating = false;
      });

      // Auto-scroll to results after calculation
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_resultsKey.currentContext != null) {
          Scrollable.ensureVisible(
            _resultsKey.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('agarMediumCalculatorTitle')),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header com imagem e descrição
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomImageWidget(
                        imageUrl: "assets/images/agar_medium_calculator_image.jpg",
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.translate('agarMediumCalculatorDescription'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Seletor de tipo de meio (PDA/MEA)
              MediumTypeSelectorWidget(
                selectedType: _selectedMediumType,
                onTypeChanged: (String newType) {
                  setState(() {
                    _selectedMediumType = newType;
                    _results.clear(); // Limpar resultados ao mudar o tipo
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Input de volume
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.translate("volumeAmount"),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _volumeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.translate("enterVolumeAmount"),
                          suffixText: 'ml',
                          border: const OutlineInputBorder(),
                          errorText: _volumeError,
                        ),
                        onChanged: (value) {
                          if (_volumeError != null) {
                            setState(() {
                              _volumeError = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botão de calcular
              ElevatedButton(
                onPressed: _isCalculating ? null : _calculateIngredients,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isCalculating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.translate('calculating')),
                        ],
                      )
                    : Text(
                        AppLocalizations.translate('calculateAgar'),
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              
              const SizedBox(height: 24),
              
              // Resultados
              if (_results.isNotEmpty)
                AgarResultsWidget(
                  key: _resultsKey,
                  results: _results,
                  mediumType: _selectedMediumType,
                  volume: _calculatedVolume!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}


