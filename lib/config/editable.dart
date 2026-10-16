import 'package:flutter/material.dart';

import 'package:energetic_selfcare/models/chakra.dart';

/// ---------------------------------------------------------------------------
/// Ryan: this is the only file you need to edit for placeholder content.
/// Replace the colours, the spiritual guidance lists, and the website / course
/// links below. The rest of the app reads these values and nothing else.
/// Colours are placeholders chosen so each point stays visible on black.
/// ---------------------------------------------------------------------------
class Editable {
  const Editable._();

  // --- Website and course ---------------------------------------------------
  // Ryan: replace these placeholder URLs with the live site and course.
  static const String websiteUrl = 'https://example.com/energetic-selfcare';
  static const String courseUrl =
      'https://example.com/energetic-selfcare/course';

  // --- Interface accents ----------------------------------------------------
  // Ryan: optional retints for the quiet interface (not the chakra points).
  static const Color shieldGold = Color(0xFFD4AF37);
  static const Color accentPurple = Color(0xFF7F00FF);
  static const Color accentTeal = Color(0xFF009999);
  static const Color accentIndigo = Color(0xFF293890);
  static const Color accentYellow = Color(0xFFFFCB2E);
  static const Color parchment = Color(0xFFF4EFE4);
  static const Color mist = Color(0xFFB7B1A4);

  // --- Chakra placeholder colours -------------------------------------------
  // Ryan: replace each colour. Both hands share one colour, and both feet
  // share one colour.
  //
  // Notes on visibility against the black ground:
  // * Feet on the colour sheet are bronze #8C5722, which sinks into black,
  //   so this placeholder is a lighter bronze.
  // * Earth Star is milky white. A true black ring would disappear here, so
  //   the ring is a soft grey until you choose a replacement.
  // * Magnetic was listed with the same hex as Divine Gateway. This
  //   placeholder is a distinct burgundy so the two points can be told apart.
  static const Map<ChakraId, Color> chakraColours = {
    ChakraId.divineGateway: Color(0xFFD100D1),
    ChakraId.galactic: Color(0xFF6AD6EF),
    ChakraId.universal: Color(0xFF71EEB8),
    ChakraId.soulStar: Color(0xFFF7F7F7),
    ChakraId.causal: Color(0xFF4C7DFF),
    ChakraId.crown: Color(0xFF7F00FF),
    ChakraId.thirdEye: Color(0xFF6A4CFF),
    ChakraId.throat: Color(0xFF5B8DEF),
    ChakraId.heart: Color(0xFF3DDC6A),
    ChakraId.solarPlexus: Color(0xFFF8ED62),
    ChakraId.naval: Color(0xFFFFBF00),
    ChakraId.sacral: Color(0xFFFF5F1F),
    ChakraId.root: Color(0xFFFF3B3B),
    ChakraId.leftHand: Color(0xFFFF7F50),
    ChakraId.rightHand: Color(0xFFFF7F50),
    ChakraId.leftFoot: Color(0xFFD08A45),
    ChakraId.rightFoot: Color(0xFFD08A45),
    ChakraId.earthStar: Color(0xFFF4F1EA),
    ChakraId.magnetic: Color(0xFFB4234A),
    ChakraId.gaiaGateway: Color(0xFFF699CD),
  };

  /// Ring drawn around a point. Null means no extra ring.
  /// Ryan: change these if you want a different outline on a point.
  static const Map<ChakraId, Color> chakraRings = {
    ChakraId.soulStar: Color(0xFFCCCCCC),
    ChakraId.causal: Color(0xFF0047AB),
    ChakraId.earthStar: Color(0xFF9A9A9A),
  };

  static Color colourOf(ChakraId id) => chakraColours[id] ?? Colors.white;

  static Color? ringOf(ChakraId id) => chakraRings[id];

  // --- Spiritual guidance lists ---------------------------------------------
  // Edit the JSON packs instead of this file:
  //   assets/data/spirit_animals.json
  //   assets/data/archangel.json
  //   assets/data/ascended_master.json
  // The guide is a name typed in the app.
}
