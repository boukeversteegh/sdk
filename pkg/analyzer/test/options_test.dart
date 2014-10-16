// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library options_test;

import 'package:unittest/unittest.dart';
import 'package:analyzer/options.dart';

main() {

  group('AnalyzerOptions.parse()', () {

    test('defaults', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', 'foo.dart']);
      expect(options, isNotNull);
      expect(options.dartSdkPath, isNotNull);
      expect(options.disableHints, isFalse);
      expect(options.displayVersion, isFalse);
      expect(options.enableAsync, isFalse);
      expect(options.enableEnum, isFalse);
      expect(options.enableTypeChecks, isFalse);
      expect(options.ignoreUnrecognizedFlags, isFalse);
      expect(options.log, isFalse);
      expect(options.machineFormat, isFalse);
      expect(options.packageRootPath, isNull);
      expect(options.perf, isFalse);
      expect(options.shouldBatch, isFalse);
      expect(options.showPackageWarnings, isFalse);
      expect(options.showSdkWarnings, isFalse);
      expect(options.sourceFiles, equals(['foo.dart']));
      expect(options.warmPerf, isFalse);
      expect(options.warningsAreFatal, isFalse);
    });

    test('batch', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--batch']);
      expect(options.shouldBatch, isTrue);
    });

    test('defined variables', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '-Dfoo=bar', 'foo.dart']);
      expect(options.definedVariables['foo'], equals('bar'));
      expect(options.definedVariables['bar'], isNull);
    });

    test('enable async', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--enable-async', 'foo.dart']);
      expect(options.enableAsync, isTrue);
    });

    test('enable enum', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--enable-enum', 'foo.dart']);
      expect(options.enableEnum, isTrue);
    });

    test('enable type checks', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--enable_type_checks', 'foo.dart']);
      expect(options.enableTypeChecks, isTrue);
    });

    test('log', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--log', 'foo.dart']);
      expect(options.log, isTrue);
    });

    test('machine format', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--format=machine', 'foo.dart']);
      expect(options.machineFormat, isTrue);
    });

    test('no-hints', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--no-hints', 'foo.dart']);
      expect(options.disableHints, isTrue);
    });

    test('package root', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '-p', 'bar', 'foo.dart']);
      expect(options.packageRootPath, equals('bar'));
    });

    test('package warnings', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--package-warnings', 'foo.dart']);
      expect(options.showPackageWarnings, isTrue);
    });

    test('perf', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--perf', 'foo.dart']);
      expect(options.perf, isTrue);
    });

    test('sdk warnings', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--warnings', 'foo.dart']);
      expect(options.showSdkWarnings, isTrue);
    });

    test('sourceFiles', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--log', 'foo.dart', 'foo2.dart', 'foo3.dart']);
      expect(options.sourceFiles, equals(['foo.dart', 'foo2.dart', 'foo3.dart']));
    });

    test('warningsAreFatal', () {
      CommandLineOptions options = CommandLineOptions
          .parse(['--dart-sdk', '.', '--fatal-warnings', 'foo.dart']);
      expect(options.warningsAreFatal, isTrue);
    });

//    test('notice unrecognized flags', () {
//      CommandLineOptions options = new CommandLineOptions.parse(['--bar', '--baz',
//        'foo.dart']);
//      expect(options, isNull);
//    });
//
//    test('ignore unrecognized flags', () {
//      CommandLineOptions options = new CommandLineOptions.parse([
//        '--ignore_unrecognized_flags', '--bar', '--baz', 'foo.dart']);
//      expect(options, isNotNull);
//      expect(options.sourceFiles, equals(['foo.dart']));
//    });

  });

}
