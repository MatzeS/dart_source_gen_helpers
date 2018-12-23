import 'package:test/test.dart';
import '../lib/test/generation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'dart:async';
import 'package:test/test.dart';

import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'dart:io';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen_helpers/class/util.dart';
import 'package:front_end/src/fasta/compiler_context.dart';

main() {
  group('', () {
    Map<String, ClassElement> classElements;
    setUpAll(() async {
      classElements = await testClassElements;
    });
    test('number of children, FullClass', () async {
      print(allClassChildren(classElements['FullClass']));
      expect(allClassChildren(classElements['FullClass']).length, 12);
    });
    test('number of children, FullAbstractClass', () async {
      expect(allClassChildren(classElements['FullAbstractClass']).length, 13);
    });
    test('number of children, FullAbstractImplemented', () async {
      expect(allClassChildren(classElements['FullAbstractImplemented']).length,
          10);
    });
    test('number of children, PartiallyImplemented', () async {
      expect(allClassChildren(classElements['PartiallyImplemented']).length, 2);
    });
  }, tags: 'current');
}
