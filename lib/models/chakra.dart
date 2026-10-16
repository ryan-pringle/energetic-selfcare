/// Points that can light on the body figure.
///
/// Feet and hands are separate ids so both sides can light together while
/// still sharing one mantra label.
enum ChakraId {
  divineGateway,
  galactic,
  universal,
  soulStar,
  causal,
  crown,
  thirdEye,
  throat,
  heart,
  solarPlexus,
  naval,
  sacral,
  root,
  leftHand,
  rightHand,
  leftFoot,
  rightFoot,
  earthStar,
  magnetic,
  gaiaGateway,
}

extension ChakraIdLabel on ChakraId {
  /// Short name used in mantras and captions.
  String get label => switch (this) {
    ChakraId.divineGateway => 'Divine Stellar Gateway',
    ChakraId.galactic => 'Galactic',
    ChakraId.universal => 'Universal',
    ChakraId.soulStar => 'Soul Star',
    ChakraId.causal => 'Causal',
    ChakraId.crown => 'Crown',
    ChakraId.thirdEye => 'Third Eye',
    ChakraId.throat => 'Throat',
    ChakraId.heart => 'Heart',
    ChakraId.solarPlexus => 'Solar Plexus',
    ChakraId.naval => 'Naval',
    ChakraId.sacral => 'Sacral',
    ChakraId.root => 'Root',
    ChakraId.leftHand || ChakraId.rightHand => 'Hands',
    ChakraId.leftFoot || ChakraId.rightFoot => 'Feet',
    ChakraId.earthStar => 'Earth Star',
    ChakraId.magnetic => 'Magnetic',
    ChakraId.gaiaGateway => 'Gaia Gateway',
  };
}

/// Both feet, lit as one step.
const List<ChakraId> bothFeet = [ChakraId.leftFoot, ChakraId.rightFoot];

/// Both palms. They have no mantra in the written sequences.
const List<ChakraId> bothHands = [ChakraId.leftHand, ChakraId.rightHand];
