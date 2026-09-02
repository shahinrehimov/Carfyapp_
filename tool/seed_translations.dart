// Bulk-uploads every entry from `TranslationDefaults` to the backend.
//
// Endpoint: POST {baseUrl}/control/translations/add
// Body shape:
// {
//   "key": "<translation key>",
//   "group": "app",
//   "translations": [
//     {"language_id": 1, "text": "<az>"},
//     {"language_id": 2, "text": "<en>"},
//     {"language_id": 3, "text": "<ru>"}
//   ]
// }
//
// Run:
//   dart run tool/seed_translations.dart

import 'dart:convert';
import 'dart:io';

import 'package:carfy/common/translations/default_translations.dart';

const _bearerToken = '429|pm9v2hy5pQ0KtkZrxZxEKEupJRrq7lYUzwxYqCXce5cf3eba';
const _securityToken = 'development-token-test-1907-fb';
const _baseUrl = 'https://api.carfy.az/api';
const _group = 'app';

const _languageIds = {
  'az': 1,
  'en': 2,
  'ru': 3,
};

Future<void> main() async {
  final az = TranslationDefaults.defaults['az'] ?? const {};
  final en = TranslationDefaults.defaults['en'] ?? const {};
  final ru = TranslationDefaults.defaults['ru'] ?? const {};

  final keys = az.keys.toList()..sort();
  final endpoint = Uri.parse('$_baseUrl/control/translations/add');
  final client = HttpClient();

  stdout.writeln('Endpoint: $endpoint');
  stdout.writeln('Group:    $_group');
  stdout.writeln('Keys:     ${keys.length}');
  stdout.writeln('');

  var ok = 0;
  final failures = <_Failure>[];

  for (var i = 0; i < keys.length; i++) {
    final key = keys[i];
    final body = {
      'key': key,
      'group': _group,
      'translations': [
        if (az.containsKey(key)) {'language_id': _languageIds['az'], 'text': az[key]},
        if (en.containsKey(key)) {'language_id': _languageIds['en'], 'text': en[key]},
        if (ru.containsKey(key)) {'language_id': _languageIds['ru'], 'text': ru[key]},
      ],
    };

    final label = '[${(i + 1).toString().padLeft(3)}/${keys.length}] $key';

    try {
      final req = await client.postUrl(endpoint);
      req.headers.contentType = ContentType.json;
      req.headers.set(HttpHeaders.acceptHeader, 'application/json');
      req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_bearerToken');
      req.headers.set('Token', _securityToken);
      req.add(utf8.encode(jsonEncode(body)));

      final res = await req.close();
      final text = await res.transform(utf8.decoder).join();
      final code = res.statusCode;

      if (code >= 200 && code < 300) {
        stdout.writeln('$label  -> $code');
        ok++;
      } else {
        stdout.writeln('$label  -> $code  ${_oneLine(text)}');
        failures.add(_Failure(key: key, status: code, body: text));
      }
    } catch (e) {
      stdout.writeln('$label  -> ERROR  $e');
      failures.add(_Failure(key: key, status: 0, body: e.toString()));
    }
  }

  client.close();

  stdout.writeln('');
  stdout.writeln('Summary');
  stdout.writeln('  ok:     $ok');
  stdout.writeln('  failed: ${failures.length}');

  if (failures.isNotEmpty) {
    stdout.writeln('');
    stdout.writeln('Failures:');
    for (final f in failures) {
      stdout.writeln('  ${f.key}  [${f.status}]  ${_oneLine(f.body)}');
    }
    exit(2);
  }
}

class _Failure {
  final String key;
  final int status;
  final String body;
  _Failure({required this.key, required this.status, required this.body});
}

String _oneLine(String s) {
  final trimmed = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (trimmed.length <= 200) return trimmed;
  return '${trimmed.substring(0, 200)}…';
}
