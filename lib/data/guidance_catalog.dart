import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:energetic_selfcare/config/assets.dart';

class GuidanceEntry {
  const GuidanceEntry({
    required this.name,
    required this.description,
    required this.action,
  });

  final String name;
  final String description;
  final String action;

  factory GuidanceEntry.fromJson(Map<String, dynamic> json) {
    return GuidanceEntry(
      name: (json['Name'] as String? ?? '').trim(),
      description: (json['Description'] as String? ?? '').trim(),
      action: (json['Action'] as String? ?? '').trim(),
    );
  }
}

/// Spirit animals, archangels, and ascended masters from the JSON packs.
class GuidanceCatalog {
  GuidanceCatalog({
    required this.animals,
    required this.archangels,
    required this.masters,
  });

  final List<GuidanceEntry> animals;
  final List<GuidanceEntry> archangels;
  final List<GuidanceEntry> masters;

  static GuidanceCatalog? _cached;

  static Future<GuidanceCatalog> load() async {
    final cached = _cached;
    if (cached != null) {
      return cached;
    }
    final catalog = GuidanceCatalog(
      animals: await _loadList(AppAssets.spiritAnimalsJson),
      archangels: await _loadList(AppAssets.archangelJson),
      masters: await _loadList(AppAssets.ascendedMasterJson),
    );
    _cached = catalog;
    return catalog;
  }

  static Future<List<GuidanceEntry>> _loadList(String asset) async {
    final raw = await rootBundle.loadString(asset);
    final decoded = jsonDecode(raw) as List<dynamic>;
    final entries = <GuidanceEntry>[];
    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      final entry = GuidanceEntry.fromJson(item);
      if (entry.name.isEmpty) {
        continue;
      }
      entries.add(entry);
    }
    return entries;
  }
}
