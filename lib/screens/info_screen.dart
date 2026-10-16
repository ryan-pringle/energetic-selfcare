import 'package:flutter/material.dart';

import 'package:energetic_selfcare/data/field_notes.dart';
import 'package:energetic_selfcare/layout/phone_scale.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final notes = fieldNotes();
    final scale = PhoneScale(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Aura & Chakras')),
      body: ListView(
        padding: scale.pageInsets(top: 8),
        children: [
          Text(
            'The white field holds you. The gold shield keeps the practice clear. Each point below is a place to rest your attention.',
            style: text.bodyLarge,
          ),
          const SizedBox(height: 18),
          for (final note in notes) ...[
            _NoteCard(note: note),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Text(
            'Sequences and the chakra map follow Jodi Pringle’s energetic practice.',
            style: text.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final FieldNote note;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final mantra = note.mantra;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: note.colour.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _Swatch(colour: note.colour, ring: note.ring),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title, style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(note.location, style: text.bodyMedium),
                  const SizedBox(height: 8),
                  Text(note.summary, style: text.bodyLarge),
                  if (mantra != null && mantra.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      mantra,
                      style: text.labelLarge?.copyWith(color: note.colour),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.colour, this.ring});

  final Color colour;
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colour,
        border: Border.all(
          color: ring ?? colour.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: colour.withValues(alpha: 0.7), blurRadius: 8),
        ],
      ),
    );
  }
}
