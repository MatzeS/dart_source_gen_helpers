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

class ClassElementProvider extends Generator {
  Map<String, ClassElement> classElements = {};
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    library.classElements.forEach((e) {
      classElements.putIfAbsent(e.name, () => e);
    });
    return "";
  }
}

/// Helper class to test code generation
class Generation {
  var cep = new ClassElementProvider();
  Map<String, ClassElement> get classElements => cep.classElements;

  final String pkgName = 'pkg';

  generate(Map<String, String> srcs) async {
    Builder builder = new PartBuilder([cep], '.g.test.dart');

    final writer = new InMemoryAssetWriter();
    await testBuilder(builder, srcs, rootPackage: pkgName, writer: writer);
  }
}

Future<Map<String, ClassElement>> get testClassElements async =>
    loadClassesFromFile('lib/test/test_classes.dart');
Future<Map<String, ClassElement>> loadClassesFromFile(String path) async {
  var g = new Generation();
  await g.generate({
    'pkg|lib/test_classes.dart': await new File(path).readAsString(),
  });
  return g.classElements;
}
