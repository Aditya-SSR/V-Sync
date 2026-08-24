import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/features/home/model/mess_menu.dart';
import 'package:xml/xml.dart';

/// Parses the monthly VIT-AP mess menu Excel sheet and persists it locally.
///
/// The .xlsx format is a ZIP of XML files; this reader walks
/// `xl/workbook.xml`, `xl/sharedStrings.xml` and the worksheet XML directly
/// so no extra dependencies are needed.
class MessMenuService {
  static const _storageKey = 'mess_menu_v1';

  // ---------------------------------------------------------------- storage

  Future<MessMenu?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return null;
      return MessMenu.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Failed to load mess menu: $e');
      return null;
    }
  }

  Future<void> save(MessMenu menu) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(menu.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  // ----------------------------------------------------------------- parse

  /// Parses the raw bytes of an .xlsx file into a [MessMenu].
  static MessMenu parseXlsx(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);

    ArchiveFile? findFile(String name) {
      for (final file in archive) {
        if (file.name.endsWith(name)) return file;
      }
      return null;
    }

    // Shared strings
    final sharedStrings = <String>[];
    final sharedStringsFile = findFile('xl/sharedStrings.xml');
    if (sharedStringsFile != null) {
      final doc = XmlDocument.parse(utf8.decode(sharedStringsFile.content));
      for (final si in doc.findAllElements('si', namespaceUri: '*')) {
        // Concatenate all text runs inside the shared string.
        final text = si.descendantElements
            .where((e) => e.name.local == 't')
            .map((e) => e.innerText)
            .join();
        sharedStrings.add(text);
      }
    }

    // Workbook: sheet name -> r:id
    final workbookFile = findFile('xl/workbook.xml');
    if (workbookFile == null) {
      throw const FormatException('Not a valid Excel workbook');
    }
    final workbook = XmlDocument.parse(utf8.decode(workbookFile.content));
    final sheetEntries = <({String name, String rid})>[];
    for (final sheet in workbook.findAllElements('sheet', namespaceUri: '*')) {
      final name = sheet.getAttribute('name', namespaceUri: '*') ?? '';
      String? rid;
      for (final attr in sheet.attributes) {
        if (attr.name.local == 'id') rid = attr.value;
      }
      if (rid != null) sheetEntries.add((name: name, rid: rid));
    }

    // Relationships: r:id -> target path
    final relsFile = findFile('xl/_rels/workbook.xml.rels');
    if (relsFile == null) {
      throw const FormatException('Workbook relationships missing');
    }
    final rels = XmlDocument.parse(utf8.decode(relsFile.content));
    final ridToTarget = <String, String>{};
    for (final rel in rels.findAllElements('Relationship', namespaceUri: '*')) {
      final id = rel.getAttribute('Id', namespaceUri: '*');
      final target = rel.getAttribute('Target', namespaceUri: '*');
      if (id != null && target != null) {
        ridToTarget[id] = target.startsWith('/xl/') 
            ? target.substring(1)
            : 'xl/${target.replaceFirst(RegExp(r'^xl/'), '')}';
      }
    }

    // Pick the sheet: prefer the regular "Veg & Non-Veg" menu, fall back to
    // the first sheet that parses.
    sheetEntries.sort((a, b) {
      const preferred = 'veg & non-veg';
      final aPreferred = a.name.toLowerCase().contains(preferred) ? 0 : 1;
      final bPreferred = b.name.toLowerCase().contains(preferred) ? 0 : 1;
      return aPreferred.compareTo(bPreferred);
    });

    Object? lastError;
    for (final entry in sheetEntries) {
      final target = ridToTarget[entry.rid];
      if (target == null) continue;
      final sheetFile = findFile(target);
      if (sheetFile == null) continue;
      try {
        final sheet = _readSheet(utf8.decode(sheetFile.content), sharedStrings);
        final menu = _menuFromGrid(sheet.grid, sheet.dayBlockRanges);
        if (menu != null) return menu;
      } catch (e) {
        lastError = e;
      }
    }
    throw FormatException(
        'Could not find a mess menu table in this file. $lastError');
  }

  /// Reads a worksheet into a grid of strings indexed [row][col], and
  /// collects the merged ranges of column A (the day-label column), which
  /// mark the exact row span of each day group.
  static ({List<List<String>> grid, List<(int, int)> dayBlockRanges})
      _readSheet(String xml, List<String> sharedStrings) {
    final doc = XmlDocument.parse(xml);
    final grid = <List<String>>[];

    for (final row in doc.findAllElements('row', namespaceUri: '*')) {
      final rowAttr = row.getAttribute('r', namespaceUri: '*');
      final rowIndex = (int.tryParse(rowAttr ?? '') ?? grid.length + 1) - 1;
      while (grid.length <= rowIndex) {
        grid.add(<String>[]);
      }
      final cells = grid[rowIndex];

      for (final c in row.findElements('c', namespaceUri: '*')) {
        final ref = c.getAttribute('r', namespaceUri: '*') ?? '';
        final col = _columnIndexFromRef(ref);
        final type = c.getAttribute('t', namespaceUri: '*');

        String value = '';
        if (type == 'inlineStr') {
          value = c.descendantElements
              .where((e) => e.name.local == 't')
              .map((e) => e.innerText)
              .join();
        } else {
          XmlElement? v;
          for (final el in c.findElements('v', namespaceUri: '*')) {
            v = el;
            break;
          }
          if (v != null) {
            value = v.innerText;
            if (type == 's') {
              final idx = int.tryParse(value);
              value = (idx != null && idx < sharedStrings.length)
                  ? sharedStrings[idx]
                  : '';
            }
          }
        }

        while (cells.length <= col) {
          cells.add('');
        }
        cells[col] = value.trim();
      }
    }

    // Merged ranges of column A: "A4:A16" -> (3, 15). Each range is one
    // day group's exact row span.
    final dayBlockRanges = <(int, int)>[];
    for (final merge in doc.findAllElements('mergeCell', namespaceUri: '*')) {
      final ref = merge.getAttribute('ref', namespaceUri: '*') ?? '';
      if (!ref.toUpperCase().startsWith('A')) continue;
      final parts = ref.split(':');
      if (parts.length != 2) continue;
      final r1 = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
      final r2 = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), ''));
      if (r1 != null && r2 != null && r2 > r1) {
        dayBlockRanges.add((r1 - 1, r2 - 1));
      }
    }
    dayBlockRanges.sort((a, b) => a.$1.compareTo(b.$1));

    return (grid: grid, dayBlockRanges: dayBlockRanges);
  }

  /// Converts a cell reference like "BC12" into a zero-based column index.
  static int _columnIndexFromRef(String ref) {
    final letters = ref.replaceAll(RegExp(r'[^A-Za-z]'), '');
    var index = 0;
    for (var i = 0; i < letters.length; i++) {
      index = index * 26 + (letters.toUpperCase().codeUnitAt(i) - 64);
    }
    return index - 1;
  }

  /// Builds the [MessMenu] from a raw grid, or null when the grid doesn't
  /// look like a mess menu.
  static MessMenu? _menuFromGrid(
    List<List<String>> grid,
    List<(int, int)> dayBlockRanges,
  ) {
    // 1. Locate the header row (contains "Breakfast").
    var headerRow = -1;
    var breakfastCol = -1, lunchCol = -1, snacksCol = -1, dinnerCol = -1;
    for (var r = 0; r < grid.length; r++) {
      for (var c = 0; c < grid[r].length; c++) {
        final cell = grid[r][c].toLowerCase();
        if (cell == 'breakfast') breakfastCol = c;
        if (cell == 'lunch') lunchCol = c;
        if (cell == 'snacks') snacksCol = c;
        if (cell == 'dinner') dinnerCol = c;
      }
      if (breakfastCol != -1 && lunchCol != -1) {
        headerRow = r;
        break;
      }
    }
    if (headerRow == -1) return null;

    // 2. Month from the title row ("... FOR THE MONTH OF AUGUST").
    final months = const [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december',
    ];
    var month = DateTime.now().month;
    var monthName = months[month - 1];
    for (var r = 0; r < headerRow; r++) {
      for (final cell in grid[r]) {
        final lower = cell.toLowerCase();
        for (var m = 0; m < months.length; m++) {
          if (lower.contains('month of ${months[m]}') ||
              lower.contains(months[m])) {
            month = m + 1;
            monthName = months[m];
          }
        }
      }
    }
    final now = DateTime.now();
    final year = month < now.month ? now.year + 1 : now.year;

    // 3. Assign item rows to day groups. When the sheet has merged cells in
    // the label column (the usual case), each merge marks a day group's
    // exact row span — use those. Otherwise fall back to blank-row
    // boundaries.
    final days = <int, Map<String, List<String>>>{};

    void addItemsToDays(List<int> targetDays, List<int> cols, int r) {
      final row = grid[r];
      String cellAt(int col) =>
          col >= 0 && col < row.length ? row[col] : '';
      for (final col in cols) {
        final value = cellAt(col);
        if (value.isEmpty) continue;
        final key = col == lunchCol
            ? 'lunch'
            : col == snacksCol
                ? 'snacks'
                : col == dinnerCol
                    ? 'dinner'
                    : 'breakfast';
        for (final day in targetDays) {
          days
              .putIfAbsent(day, () => {})
              .putIfAbsent(key, () => [])
              .add(value);
        }
      }
    }

    final mealCols = [breakfastCol, lunchCol, snacksCol, dinnerCol];

    if (dayBlockRanges.isNotEmpty) {
      for (final (start, end) in dayBlockRanges) {
        if (end <= headerRow) continue;
        // Day numbers live in the label text ("Mon" / "10, 24" — possibly
        // multiline within the merged cell).
        final labelBuffer = StringBuffer();
        for (var r = start; r <= end && r < grid.length; r++) {
          final row = grid[r];
          for (var c = 0; c < (breakfastCol > 0 ? breakfastCol : 1); c++) {
            if (c < row.length) labelBuffer.write('${row[c]} ');
          }
        }
        final dayNumbers = RegExp(r'\d+')
            .allMatches(labelBuffer.toString())
            .map((m) => int.parse(m.group(0)!))
            .where((n) => n >= 1 && n <= 31)
            .toList();
        if (dayNumbers.isEmpty) continue;

        for (var r = start; r <= end && r < grid.length; r++) {
          if (r <= headerRow) continue;
          addItemsToDays(dayNumbers, mealCols, r);
        }
      }
    } else {
      // Fallback: blank rows separate day groups.
      var currentDays = <int>[];
      var prevRowHadItems = false;

      for (var r = headerRow + 1; r < grid.length; r++) {
        final row = grid[r];
        String cellAt(int col) =>
            col >= 0 && col < row.length ? row[col] : '';

        final hasItems = mealCols.any((col) => cellAt(col).isNotEmpty);
        if (!hasItems) {
          prevRowHadItems = false;
          continue;
        }

        if (!prevRowHadItems) {
          final labelBuffer = StringBuffer();
          for (var lr = r; lr <= r + 3 && lr < grid.length; lr++) {
            final labelRow = grid[lr];
            for (var c = 0; c < (breakfastCol > 0 ? breakfastCol : 1); c++) {
              if (c < labelRow.length) {
                labelBuffer.write('${labelRow[c]} ');
              }
            }
          }
          currentDays = RegExp(r'\d+')
              .allMatches(labelBuffer.toString())
              .map((m) => int.parse(m.group(0)!))
              .where((n) => n >= 1 && n <= 31)
              .toList();
        }

        addItemsToDays(currentDays, mealCols, r);
        prevRowHadItems = true;
      }
    }

    if (days.isEmpty) return null;

    return MessMenu(
      monthName: monthName[0].toUpperCase() + monthName.substring(1),
      month: month,
      year: year,
      days: days.map((day, meals) => MapEntry(day, MessDayMenu(
            breakfast: meals['breakfast'] ?? const [],
            lunch: meals['lunch'] ?? const [],
            snacks: meals['snacks'] ?? const [],
            dinner: meals['dinner'] ?? const [],
          ))),
    );
  }
}

