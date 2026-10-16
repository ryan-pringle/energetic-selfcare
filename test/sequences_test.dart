import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/data/sequences.dart';
import 'package:energetic_selfcare/models/chakra.dart';
import 'package:energetic_selfcare/models/sequence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('colour sheet accents are present', () {
    expect(Editable.accentPurple, const Color(0xFF7F00FF));
    expect(Editable.accentTeal, const Color(0xFF009999));
    expect(Editable.accentIndigo, const Color(0xFF293890));
    expect(Editable.accentYellow, const Color(0xFFFFCB2E));
    expect(Editable.shieldGold, const Color(0xFFD4AF37));
    expect(Editable.colourOf(ChakraId.crown), const Color(0xFF7F00FF));
    expect(Editable.colourOf(ChakraId.heart), const Color(0xFF3DDC6A));
  });

  test('protection lights feet, earth star, shield, then crown', () {
    final beats = Sequences.protection.beats;
    expect(beats.last.prompt, 'I am Protected');
    expect(beats.first.light, bothFeet);
    expect(
      beats.indexWhere((beat) => beat.focus == 'Feet') <
          beats.indexWhere((beat) => beat.focus == 'Earth Star'),
      isTrue,
    );
    expect(
      beats.indexWhere((beat) => beat.focus == 'Earth Star') <
          beats.indexWhere((beat) => beat.shield),
      isTrue,
    );
    expect(
      beats.indexWhere((beat) => beat.shield) <
          beats.indexWhere((beat) => beat.focus == 'Crown'),
      isTrue,
    );
    expect(beats.any((beat) => beat.auraCleanse), isTrue);
    expect(beats.any((beat) => beat.prompt.contains('highest good')), isTrue);
  });

  test('selfcare energises with level_one JSON mantras', () {
    final energise = Sequences.selfcare.beats
        .where((beat) => beat.phase == SequencePhase.energise)
        .toList();
    expect(energise.map((beat) => '${beat.focus} – ${beat.mantra}').toList(), [
      'Earth Star – My Grounding',
      'Feet – I Link',
      'Root – I Thrive',
      'Sacral – I Create',
      'Naval – I Shine',
      'Solar Plexus – I Express',
      'Heart – I Love',
      'Throat – I Speak',
      'Third Eye – I See',
      'Crown – I Know',
      'Causal – I Am',
      'Soul Star – My Purpose',
    ]);
    expect(
      Sequences.selfcare.beats.last.prompt,
      'I trust and believe in myself',
    );
  });

  test('transition uses level_two JSON mantras and finishes infinite', () {
    final open = Sequences.transition.beats
        .where((beat) => beat.phase == SequencePhase.open)
        .map((beat) => beat.focus)
        .toList();
    expect(open.first, 'Divine Stellar Gateway');
    expect(open.last, 'Gaia Gateway');

    final energise = Sequences.transition.beats
        .where((beat) => beat.phase == SequencePhase.energise)
        .toList();
    expect(energise.first.focus, 'Gaia Gateway');
    expect(energise.first.mantra, 'My Connection');
    expect(energise.last.focus, 'Divine Stellar Gateway');
    expect(energise.last.mantra, 'My Abundance');
    expect(
      energise.any(
        (beat) => beat.focus == 'Galactic' && beat.mantra == 'My Team',
      ),
      isTrue,
    );
    expect(
      energise.any((beat) => beat.focus == 'Feet' && beat.mantra == 'I Link'),
      isTrue,
    );
    expect(
      energise.any((beat) => beat.focus == 'Causal' && beat.mantra == 'I Am'),
      isTrue,
    );
    expect(energise.any((beat) => beat.focus == 'Hands'), isFalse);
    expect(Sequences.transition.beats.last.prompt, 'I am Infinite');

    final sweep = Sequences.transition.beats.singleWhere(
      (beat) => beat.auraCleanse,
    );
    expect(sweep.light, bothHands);
  });
}
