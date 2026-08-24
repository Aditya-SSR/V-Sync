import 'package:flutter/foundation.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_ap_student_app/features/home/model/mess_menu.dart';
import 'package:vit_ap_student_app/features/home/services/mess_menu_service.dart';

final messMenuProvider =
    NotifierProvider<MessMenuNotifier, MessMenu?>(MessMenuNotifier.new);

class MessMenuNotifier extends Notifier<MessMenu?> {
  final _service = MessMenuService();

  @override
  MessMenu? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final menu = await _service.load();
    state = menu;
  }

  /// Parses an uploaded .xlsx file, stores it and returns true on success.
  Future<bool> importFromBytes(Uint8List bytes) async {
    try {
      final menu = await compute(MessMenuService.parseXlsx, bytes);
      await _service.save(menu);
      state = menu;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> delete() async {
    await _service.clear();
    state = null;
  }
}
