import 'package:test/test.dart';
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
    test('', () {
      var e = classElements['FullAbstractClass'];
      print(e.lookUpGetter('aGetter', e.library));
      print(e.lookUpInheritedConcreteGetter('aGetter', e.library));
      e = classElements['FullAbstractImplemented'];
      print(e.lookUpGetter('aGetter', e.library));
      print(e.lookUpInheritedConcreteGetter('aGetter', e.library));
      e = classElements['PartiallyImplemented'];
      print(e.lookUpGetter('aGetter', e.library));
      print(e.lookUpInheritedConcreteGetter('aGetter', e.library));
    });
  });
}
