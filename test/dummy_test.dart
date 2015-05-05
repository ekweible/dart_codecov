library dart_codecov.test.service_test;

import 'package:test/test.dart';

import '../bin/src/executable.dart';
import '../bin/src/service.dart' as service;
import '../bin/dart_codecov.dart' as dart_codecov;


void main() {
  group('dart_codecov service', () {
    test('should pass but barely cover anything', () {
      expect(service.sendToCodecov(null, 'lcov', 'commit', 'branch', 'token', '1', false), throws);
    });
  });
}