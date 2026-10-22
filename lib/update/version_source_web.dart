import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'version_source.dart';

VersionSource? createVersionSource() => _WebVersionSource();

/// Reads `version.json` next to the page (never another host), skipping
/// the browser's cache.
class _WebVersionSource implements VersionSource {
  @override
  Future<String?> latest() async {
    try {
      final url = 'version.json?t=${DateTime.now().millisecondsSinceEpoch}';
      final response = await web.window
          .fetch(url.toJS, web.RequestInit(cache: 'no-store'))
          .toDart;
      if (!response.ok) return null;
      final json = jsonDecode((await response.text().toDart).toDart);
      if (json is! Map) return null;
      return '${json['version']}+${json['build_number']}';
    } catch (_) {
      return null;
    }
  }

  @override
  void reload() => web.window.location.reload();
}
