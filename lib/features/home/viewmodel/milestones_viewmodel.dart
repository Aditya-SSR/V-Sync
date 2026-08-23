import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/features/home/model/milestone.dart';

final milestonesProvider =
    NotifierProvider<MilestonesNotifier, List<Milestone>>(
  MilestonesNotifier.new,
);

class MilestonesNotifier extends Notifier<List<Milestone>> {
  static const _storageKey = 'milestones_v1';

  @override
  List<Milestone> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return;

      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => a.targetDate.compareTo(b.targetDate));
      state = list;
    } catch (e) {
      debugPrint('Failed to load milestones: $e');
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode(state.map((m) => m.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Failed to save milestones: $e');
    }
  }

  Future<void> addMilestone({
    required String title,
    String? info,
    required DateTime targetDate,
  }) async {
    final normalizedInfo = info?.trim();
    final milestone = Milestone(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      info: (normalizedInfo == null || normalizedInfo.isEmpty)
          ? null
          : normalizedInfo,
      targetDate: DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      ),
    );

    final updated = [...state, milestone]
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));
    state = updated;
    await _persist();
  }

  Future<void> removeMilestone(String id) async {
    state = state.where((m) => m.id != id).toList();
    await _persist();
  }
}
