/// Simple DateTime parser/formatter supporting a subset of Intl patterns.
/// Supported tokens: yyyy, yy, MMMM, MMM, MM, M, dd, d, HH, H, hh, h, mm, m, ss, s, SSS, a
library;

import 'dart:math';

const List<String> _monthFull = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

final List<String> _monthShort = _monthFull.map((m) => m.substring(0, min(3, m.length))).toList();

String _pad(int value, int width) => value.toString().padLeft(width, '0');

String formatDateTime(DateTime dt, String pattern) {
  var replacements = <String, String>{
    'yyyy': _pad(dt.year, 4),
    'yy': _pad(dt.year % 100, 2),
    'MMMM': _monthFull[dt.month - 1],
    'MMM': _monthShort[dt.month - 1],
    'MM': _pad(dt.month, 2),
    'M': dt.month.toString(),
    'dd': _pad(dt.day, 2),
    'd': dt.day.toString(),
    'HH': _pad(dt.hour, 2),
    'H': dt.hour.toString(),
    'hh': _pad(dt.hour % 12 == 0 ? 12 : dt.hour % 12, 2),
    'h': (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString(),
    'mm': _pad(dt.minute, 2),
    'm': dt.minute.toString(),
    'ss': _pad(dt.second, 2),
    's': dt.second.toString(),
    'SSS': _pad(dt.millisecond, 3),
    'a': dt.hour < 12 ? 'AM' : 'PM',
  };

  // Replace longest tokens first to avoid partial replacement
  var tokens = replacements.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
  var out = StringBuffer();
  var i = 0;
  while (i < pattern.length) {
    var matched = false;
    for (var t in tokens) {
      if (i + t.length <= pattern.length && pattern.substring(i, i + t.length) == t) {
        out.write(replacements[t]);
        i += t.length;
        matched = true;
        break;
      }
    }
    if (!matched) {
      out.write(pattern[i]);
      i++;
    }
  }
  return out.toString();
}

DateTime parseDateTime(String input, String pattern) {
  // Build regex with capture groups
  var tokenRegex = <String, String>{
    'yyyy': r'(\d{4})',
    'yy': r'(\d{2})',
    'MMMM': r'([A-Za-z]+)',
    'MMM': r'([A-Za-z]{3})',
    'MM': r'(\d{2})',
    'M': r'(\d{1,2})',
    'dd': r'(\d{2})',
    'd': r'(\d{1,2})',
    'HH': r'(\d{2})',
    'H': r'(\d{1,2})',
    'hh': r'(\d{2})',
    'h': r'(\d{1,2})',
    'mm': r'(\d{2})',
    'm': r'(\d{1,2})',
    'ss': r'(\d{2})',
    's': r'(\d{1,2})',
    'SSS': r'(\d{1,3})',
    'a': r'(AM|PM|am|pm)',
  };

  var tokens = tokenRegex.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
  var patternBuffer = StringBuffer('^');
  var groups = <String>[];
  var i = 0;
  while (i < pattern.length) {
    var matched = false;
    for (var t in tokens) {
      if (i + t.length <= pattern.length && pattern.substring(i, i + t.length) == t) {
        patternBuffer.write(tokenRegex[t]);
        groups.add(t);
        i += t.length;
        matched = true;
        break;
      }
    }
    if (!matched) {
      var ch = pattern[i];
      // escape regex special chars
      if (r'\\.[]{}()*+?^$|'.contains(ch)) patternBuffer.write('\\');
      patternBuffer.write(ch);
      i++;
    }
  }
  patternBuffer.write(r'$');

  var reg = RegExp(patternBuffer.toString());
  var m = reg.firstMatch(input);
  if (m == null) throw const FormatException('Input does not match pattern');

  int year = 1970;
  int month = 1;
  int day = 1;
  int hour = 0;
  int minute = 0;
  int second = 0;
  int millisecond = 0;

  for (var gi = 0; gi < groups.length; gi++) {
    var token = groups[gi];
    var val = m.group(gi + 1) ?? '';
    switch (token) {
      case 'yyyy':
        year = int.parse(val);
        break;
      case 'yy':
        year = 2000 + int.parse(val);
        break;
      case 'MMMM':
        var idx = _monthFull.indexWhere((m) => m.toLowerCase() == val.toLowerCase());
        if (idx >= 0) {
          month = idx + 1;
        } else {
          throw const FormatException('Invalid month name');
        }
        break;
      case 'MMM':
        var idx = _monthShort.indexWhere((m) => m.toLowerCase() == val.toLowerCase());
        if (idx >= 0) {
          month = idx + 1;
        } else {
          throw const FormatException('Invalid month name');
        }
        break;
      case 'MM':
      case 'M':
        month = int.parse(val);
        break;
      case 'dd':
      case 'd':
        day = int.parse(val);
        break;
      case 'HH':
      case 'H':
        hour = int.parse(val);
        break;
      case 'hh':
      case 'h':
        hour = int.parse(val);
        break;
      case 'mm':
      case 'm':
        minute = int.parse(val);
        break;
      case 'ss':
      case 's':
        second = int.parse(val);
        break;
      case 'SSS':
        millisecond = int.parse(val.padRight(3, '0'));
        break;
      case 'a':
        var up = val.toUpperCase();
        if (up == 'PM' && hour < 12) hour += 12;
        if (up == 'AM' && hour == 12) hour = 0;
        break;
    }
  }

  try {
    return DateTime(year, month, day, hour, minute, second, millisecond);
  } catch (e) {
    throw FormatException('Invalid date components: $e');
  }
}
