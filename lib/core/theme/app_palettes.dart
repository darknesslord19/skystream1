import 'package:flutter/material.dart';

/// One of the app's named colour themes.
///
/// [seed] drives a Material 3 tonal palette (the soft `tonalSpot` variant by
/// default, so accents stay calm on the eyes), and [background] is the dark
/// theme's screen colour: a near-black lightly tinted toward the seed instead
/// of pure black, which is easier to look at for a long time.
class AppPalette {
  const AppPalette({
    required this.id,
    required this.name,
    required this.seed,
    required this.background,
    this.variant = DynamicSchemeVariant.tonalSpot,
    this.bold = false,
  });

  final String id;
  final String name;
  final Color seed;
  final Color background;
  final DynamicSchemeVariant variant;

  /// A vivid theme: its colour fills the whole layout (screens, cards,
  /// sheets, bars and fields), not just the accents.
  final bool bold;

  /// The stored id that means "no palette": wallpaper colours where the
  /// device offers them, the app's original blue otherwise.
  static const String dynamicId = 'dynamic';

  static AppPalette? byId(String? id) {
    if (id == null || id == dynamicId) return null;
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }

  static const List<AppPalette> all = [
    AppPalette(id: 'midnight_blue', name: 'Gece Mavisi', seed: Color(0xFF448AFF), background: Color(0xFF0B0F17)),
    AppPalette(id: 'ocean', name: 'Okyanus', seed: Color(0xFF00ACC1), background: Color(0xFF071214)),
    AppPalette(id: 'emerald', name: 'Zümrüt', seed: Color(0xFF10B981), background: Color(0xFF08120E)),
    AppPalette(id: 'forest', name: 'Orman', seed: Color(0xFF4CAF50), background: Color(0xFF0C120B)),
    AppPalette(id: 'mint', name: 'Nane', seed: Color(0xFF26A69A), background: Color(0xFF0A1312)),
    AppPalette(id: 'lavender', name: 'Lavanta', seed: Color(0xFF9C88FF), background: Color(0xFF100E17)),
    AppPalette(id: 'amethyst', name: 'Ametist', seed: Color(0xFF8E44AD), background: Color(0xFF120C16)),
    AppPalette(id: 'rose', name: 'Gül', seed: Color(0xFFE91E63), background: Color(0xFF160A0F)),
    AppPalette(id: 'coral', name: 'Mercan', seed: Color(0xFFFF6F61), background: Color(0xFF160D0C)),
    AppPalette(id: 'sunset', name: 'Gün Batımı', seed: Color(0xFFFF8A3D), background: Color(0xFF150E09)),
    AppPalette(id: 'amber', name: 'Kehribar', seed: Color(0xFFFFB300), background: Color(0xFF14100A)),
    AppPalette(id: 'gold', name: 'Altın', seed: Color(0xFFD4AF37), background: Color(0xFF12100A)),
    AppPalette(id: 'sand', name: 'Kum', seed: Color(0xFFC8A27A), background: Color(0xFF13100D)),
    AppPalette(id: 'cocoa', name: 'Kakao', seed: Color(0xFF8D6E63), background: Color(0xFF120E0C)),
    AppPalette(
      id: 'graphite',
      name: 'Grafit',
      seed: Color(0xFF90A4AE),
      background: Color(0xFF0E1012),
      variant: DynamicSchemeVariant.neutral,
    ),
    AppPalette(id: 'oled', name: 'OLED Siyah', seed: Color(0xFF7C4DFF), background: Color(0xFF000000)),
    AppPalette(id: 'cherry', name: 'Kiraz', seed: Color(0xFFC62828), background: Color(0xFF140909)),
    AppPalette(id: 'ice', name: 'Buz', seed: Color(0xFF81D4FA), background: Color(0xFF0A1015)),
    AppPalette(id: 'sakura', name: 'Sakura', seed: Color(0xFFF48FB1), background: Color(0xFF150D11)),
    AppPalette(id: 'nordic', name: 'Nordik', seed: Color(0xFF5E81AC), background: Color(0xFF0F1218)),
    ...vivid,
  ];

  /// The vivid themes ([bold]): strong backgrounds with a contrasting accent.
  static const List<AppPalette> vivid = [
    AppPalette(id: 'v_royal', name: 'Kraliyet Mavisi', seed: Color(0xFF2979FF), background: Color(0xFF0A1A4A), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_deep_ocean', name: 'Derin Okyanus', seed: Color(0xFF00B8D4), background: Color(0xFF002B36), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_emerald_forest', name: 'Zümrüt Ormanı', seed: Color(0xFF00E676), background: Color(0xFF06311F), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_purple_night', name: 'Mor Gece', seed: Color(0xFFD500F9), background: Color(0xFF22073F), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_burgundy', name: 'Bordo', seed: Color(0xFFFF1744), background: Color(0xFF3A0812), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_volcano', name: 'Volkan', seed: Color(0xFFFF6D00), background: Color(0xFF3A1600), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_golden_night', name: 'Altın Gece', seed: Color(0xFFFFD600), background: Color(0xFF2B2205), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_neon_pink', name: 'Neon Pembe', seed: Color(0xFFFF4081), background: Color(0xFF33061F), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_turquoise', name: 'Turkuaz', seed: Color(0xFF1DE9B6), background: Color(0xFF003330), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_cyberpunk', name: 'Siberpunk', seed: Color(0xFFF50057), background: Color(0xFF1A0B3A), variant: DynamicSchemeVariant.fidelity, bold: true),
    AppPalette(id: 'v_navy_gold', name: 'Lacivert Altın', seed: Color(0xFFFFC400), background: Color(0xFF0B1D3A), variant: DynamicSchemeVariant.fidelity, bold: true),
    AppPalette(id: 'v_espresso', name: 'Espresso', seed: Color(0xFFFF9E40), background: Color(0xFF2E1A0E), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_olive', name: 'Zeytin', seed: Color(0xFFAEEA00), background: Color(0xFF1E2A05), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_midnight_violet', name: 'Gece Moru', seed: Color(0xFF7C4DFF), background: Color(0xFF160F3A), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_steel', name: 'Çelik Mavisi', seed: Color(0xFF40C4FF), background: Color(0xFF10263A), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_crimson_dusk', name: 'Kızıl Akşam', seed: Color(0xFFFF5252), background: Color(0xFF2E0F1E), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_aurora', name: 'Aurora', seed: Color(0xFF64FFDA), background: Color(0xFF0B2440), variant: DynamicSchemeVariant.fidelity, bold: true),
    AppPalette(id: 'v_matrix', name: 'Matrix', seed: Color(0xFF00E676), background: Color(0xFF001A0A), variant: DynamicSchemeVariant.fidelity, bold: true),
    AppPalette(id: 'v_lavender_dream', name: 'Lavanta Rüyası', seed: Color(0xFFB388FF), background: Color(0xFF2A1E4A), variant: DynamicSchemeVariant.vibrant, bold: true),
    AppPalette(id: 'v_reef', name: 'Mercan Resifi', seed: Color(0xFFFF8A65), background: Color(0xFF0D2E3A), variant: DynamicSchemeVariant.fidelity, bold: true),
  ];
}
