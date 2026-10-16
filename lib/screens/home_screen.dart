import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:energetic_selfcare/config/assets.dart';
import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/data/sequences.dart';
import 'package:energetic_selfcare/layout/phone_scale.dart';
import 'package:energetic_selfcare/screens/guidance_screen.dart';
import 'package:energetic_selfcare/screens/info_screen.dart';
import 'package:energetic_selfcare/screens/practice_screen.dart';
import 'package:energetic_selfcare/screens/reminders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scale = PhoneScale(context);
    final logoSize = (88 * scale.factor).clamp(72.0, 104.0);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: scale.pageInsets(top: 12),
          children: [
            Center(
              child: Image.asset(
                AppAssets.logoFlower,
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(height: scale.gap(12)),
            Text(
              'Energetic Selfcare',
              textAlign: TextAlign.center,
              style: text.headlineMedium,
            ),
            SizedBox(height: scale.gap(8)),
            Text(
              'A quiet practice for morning and evening. Light the points, the white field, and the gold shield, and stay with the words.',
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
            SizedBox(height: scale.gap(22)),
            for (final sequence in Sequences.all) ...[
              _Destination(
                title: sequence.title,
                subtitle: sequence.summary,
                image: AppAssets.iconPractice,
                accent: switch (sequence.id) {
                  'protection' => Editable.accentIndigo,
                  'selfcare' => Editable.accentTeal,
                  _ => Editable.accentPurple,
                },
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => PracticeScreen(sequence: sequence),
                    ),
                  );
                },
              ),
              SizedBox(height: scale.gap(12)),
            ],
            const _Destination(
              title: 'Aura & Chakras',
              subtitle:
                  'A short guide to the field, the shield, and each point.',
              image: AppAssets.logoCp,
              accent: Editable.accentYellow,
              onTapRoute: InfoScreen(),
            ),
            SizedBox(height: scale.gap(12)),
            const _Destination(
              title: 'Spiritual Guidance Team',
              subtitle: 'Name the animal, archangel, master, and guide who walk with you.',
              image: AppAssets.iconSpiritAnimal,
              accent: Editable.shieldGold,
              onTapRoute: GuidanceScreen(),
            ),
            SizedBox(height: scale.gap(12)),
            const _Destination(
              title: 'Reminders',
              subtitle: 'Choose a morning time and an evening time.',
              icon: Icons.notifications_none,
              accent: Color(0xFFD7D2C8),
              onTapRoute: RemindersScreen(),
            ),
            SizedBox(height: scale.gap(26)),
            Text('Further along', style: text.titleMedium),
            SizedBox(height: scale.gap(8)),
            _LinkRow(
              icon: Icons.language,
              label: 'Website',
              url: Editable.websiteUrl,
            ),
            _LinkRow(
              icon: Icons.school_outlined,
              label: 'Course',
              url: Editable.courseUrl,
            ),
            SizedBox(height: scale.gap(18)),
            Center(
              child: ClipOval(
                child: Image.asset(
                  AppAssets.jodi,
                  width: 72 * scale.factor,
                  height: 72 * scale.factor,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: scale.gap(8)),
            Text(
              'With love, Jodi Pringle',
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Destination extends StatelessWidget {
  const _Destination({
    required this.title,
    required this.subtitle,
    required this.accent,
    this.icon,
    this.image,
    this.onTap,
    this.onTapRoute,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final String? image;
  final Color accent;
  final VoidCallback? onTap;
  final Widget? onTapRoute;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: const Color(0xFF101010),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap:
            onTap ??
            () {
              final route = onTapRoute;
              if (route == null) {
                return;
              }
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (context) => route));
            },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Editable.shieldGold.withValues(alpha: 0.28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: image != null
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(image!, fit: BoxFit.contain),
                        )
                      : Icon(
                          icon ?? Icons.circle_outlined,
                          color: accent,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.titleMedium),
                      const SizedBox(height: 3),
                      Text(subtitle, style: text.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right,
                  color: Editable.shieldGold.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.icon, required this.label, required this.url});

  final IconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Editable.shieldGold),
      title: Text(label),
      subtitle: Text(url, style: Theme.of(context).textTheme.bodyMedium),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => _open(context),
    );
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(url);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object {
      opened = false;
    }
    if (!opened) {
      try {
        opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
      } on Object {
        opened = false;
      }
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('The link could not open. $url')));
    }
  }
}
