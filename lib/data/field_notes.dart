import 'package:flutter/material.dart';

import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/models/chakra.dart';

/// A short reading for the Aura & Chakras screen.
class FieldNote {
  const FieldNote({
    required this.title,
    required this.location,
    required this.summary,
    this.mantra,
    required this.colour,
    this.ring,
  });

  final String title;
  final String location;
  final String summary;
  final String? mantra;
  final Color colour;
  final Color? ring;
}

/// Calm summaries of the field, the shield, and each point.
///
/// Wording here is the in-app guide. Colours come from [Editable].
List<FieldNote> fieldNotes() {
  FieldNote chakra(
    ChakraId id,
    String title,
    String location,
    String summary,
    String? mantra,
  ) {
    return FieldNote(
      title: title,
      location: location,
      summary: summary,
      mantra: mantra,
      colour: Editable.colourOf(id),
      ring: Editable.ringOf(id),
    );
  }

  return [
    FieldNote(
      title: 'Energy Field',
      location: 'Around the whole body',
      summary: 'The aura is a soft white field that surrounds you in every direction. It begins faint, then brightens as a wash of white light moves from crown to feet and old energy leaves.',
      colour: Colors.white,
    ),
    const FieldNote(
      title: 'Shield',
      location: 'A gold light around the aura',
      summary: 'The shield is the gold ring of protection. Only what is for your highest good may enter. Anything else meets the shield and returns to the Universe with love.',
      mantra: 'My Protection',
      colour: Editable.shieldGold,
    ),
    chakra(
      ChakraId.divineGateway,
      'Divine Stellar Gateway',
      'Above the Galactic Chakra, about 60cm above the head',
      'A gateway to other dimensions, enlightenment, abundance, manifestation, and creation.',
      'My Abundance',
    ),
    chakra(
      ChakraId.galactic,
      'Galactic',
      'Above the Universal Chakra, about 45cm above the head',
      'Awareness of the bigger picture, spiritual purpose, and connection to the spiritual guidance team.',
      'My Team',
    ),
    chakra(
      ChakraId.universal,
      'Universal',
      'Above the Soul Star',
      'Life force beyond the clock. Perception, healing energy, and the sense of being part of a living universe.',
      'My Energy',
    ),
    chakra(
      ChakraId.soulStar,
      'Soul Star',
      'A little above the crown',
      'Purpose, peace, and the clear knowing of why you are here. It is drawn as a pale ring of light.',
      'My Purpose',
    ),
    chakra(
      ChakraId.causal,
      'Causal',
      'Just above the crown, slightly back along the spine',
      'The soul’s trust in the body. Inner guidance, surrender, and the feeling of belonging to your own life. Drawn as a ring.',
      'I Am',
    ),
    chakra(
      ChakraId.crown,
      'Crown',
      'Top of the head',
      'Wisdom, faith, and the quiet connection to something greater than the thinking mind.',
      'I Know',
    ),
    chakra(
      ChakraId.thirdEye,
      'Third Eye',
      'Between the eyebrows',
      'Intuition and inner sight. The place of imagination, reflection, and trusting what you perceive.',
      'I See',
    ),
    chakra(
      ChakraId.throat,
      'Throat',
      'Base of the throat',
      'Honest, kind speech. Being heard, and speaking in a way that others can hear.',
      'I Speak',
    ),
    chakra(
      ChakraId.heart,
      'Heart',
      'Centre of the chest',
      'Love that does not keep score. Compassion, acceptance, and the willingness to give and receive.',
      'I Love',
    ),
    chakra(
      ChakraId.solarPlexus,
      'Solar Plexus',
      'Above the naval, below the ribs',
      'Will, warmth, and self-respect. Joy that can be expressed without forcing it.',
      'I Express',
    ),
    chakra(
      ChakraId.naval,
      'Naval',
      'At the naval, between the solar plexus and the sacral point',
      'The light you share. Service, steadiness, and the confidence to let your gifts be useful.',
      'I Shine',
    ),
    chakra(
      ChakraId.sacral,
      'Sacral',
      'Below the belly',
      'Creativity, relationship, and the pleasure of movement and change.',
      'I Create',
    ),
    chakra(
      ChakraId.root,
      'Root',
      'Base of the torso',
      'The right to be here. Stability, patience, and the energy to live a real life.',
      'I Thrive',
    ),
    chakra(
      ChakraId.leftHand,
      'Hand Chakras',
      'Both palms',
      'They appear on the Transition figure. Both palms light together while the aura is cleansed. This practice gives them no separate mantra.',
      null,
    ),
    chakra(
      ChakraId.leftFoot,
      'Feet',
      'Soles of both feet',
      'Where the body meets the earth and can receive from it. Both feet light together.',
      'I Link',
    ),
    chakra(
      ChakraId.earthStar,
      'Earth Star',
      'Below the feet, just under the shield',
      'Ground, boundaries, and compassion for yourself. It is drawn as a small horizontal oval.',
      'My Grounding',
    ),
    chakra(
      ChakraId.magnetic,
      'Magnetic',
      'Toward the core of the earth',
      'Balance of opposites. Healing, safety, and the peace of being one life rather than two halves.',
      'My Awareness',
    ),
    chakra(
      ChakraId.gaiaGateway,
      'Gaia Gateway',
      'The deepest point, at the centre of the earth',
      'A gateway of love and inner strength. The place this practice calls your true power.',
      'My Connection',
    ),
  ];
}
