import 'dart:io';

class AppLocalizations {
  static String get currentLanguage {
    final locale = Platform.localeName;
    if (locale.startsWith('es')) return 'es';
    if (locale.startsWith('pt')) return 'pt';
    return 'en'; // default
  }
  
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'FungiNautas Calculator',
      'cvgCalculatorTitle': 'CVG Substrate Calculator',
      'cvgCalculatorDescription': 'Calculate the perfect CVG substrate mixture for your mushroom cultivation',
      'lcCalculatorTitle': 'LC Broth Calculator',
      'lcCalculatorDescription': 'Calculate liquid culture broth ingredients for mushroom cultivation',
      'calculating': 'Calculating...',
      'calculateCVG': 'Calculate CVG',
      'calculateLC': 'Calculate LC',
      'calculatedAmounts': 'Calculated Amounts',
      'scrollToSeeResults': 'Scroll down to see your results',
      'saveToHistory': 'Save to History',
      'shareRecipe': 'Share Recipe',
      'support': 'Support',
      'contactUs': 'Contact Us',
      'website': 'Website',
      'email': 'Email',
      'whatsapp': 'WhatsApp',
      'visitWebsite': 'Visit our website for more information',
      'sendEmail': 'Send us an email for support',
      'chatWhatsApp': 'Chat with us on WhatsApp',
    },
    'es': {
      'appTitle': 'Calculadora FungiNautas',
      'cvgCalculatorTitle': 'Calculadora de Sustrato CVG',
      'cvgCalculatorDescription': 'Calcula la mezcla perfecta de sustrato CVG para tu cultivo de hongos',
      'lcCalculatorTitle': 'Calculadora de Caldo LC',
      'lcCalculatorDescription': 'Calcula los ingredientes del caldo de cultivo líquido para el cultivo de hongos',
      'calculating': 'Calculando...',
      'calculateCVG': 'Calcular CVG',
      'calculateLC': 'Calcular LC',
      'calculatedAmounts': 'Cantidades Calculadas',
      'scrollToSeeResults': 'Desplázate hacia abajo para ver tus resultados',
      'saveToHistory': 'Guardar en Historial',
      'shareRecipe': 'Compartir Receta',
      'support': 'Soporte',
      'contactUs': 'Contáctanos',
      'website': 'Sitio Web',
      'email': 'Correo',
      'whatsapp': 'WhatsApp',
      'visitWebsite': 'Visita nuestro sitio web para más información',
      'sendEmail': 'Envíanos un correo para soporte',
      'chatWhatsApp': 'Chatea con nosotros en WhatsApp',
    },
    'pt': {
      'appTitle': 'Calculadora FungiNautas',
      'cvgCalculatorTitle': 'Calculadora de Substrato CVG',
      'cvgCalculatorDescription': 'Calcule a mistura perfeita de substrato CVG para seu cultivo de cogumelos',
      'lcCalculatorTitle': 'Calculadora de Caldo LC',
      'lcCalculatorDescription': 'Calcule os ingredientes do caldo de cultura líquida para cultivo de cogumelos',
      'calculating': 'Calculando...',
      'calculateCVG': 'Calcular CVG',
      'calculateLC': 'Calcular LC',
      'calculatedAmounts': 'Quantidades Calculadas',
      'scrollToSeeResults': 'Role para baixo para ver seus resultados',
      'saveToHistory': 'Salvar no Histórico',
      'shareRecipe': 'Compartilhar Receita',
      'support': 'Suporte',
      'contactUs': 'Entre em Contato',
      'website': 'Site',
      'email': 'Email',
      'whatsapp': 'WhatsApp',
      'visitWebsite': 'Visite nosso site para mais informações',
      'sendEmail': 'Envie-nos um email para suporte',
      'chatWhatsApp': 'Converse conosco no WhatsApp',
    },
  };

  static String translate(String key) {
    final lang = currentLanguage;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

