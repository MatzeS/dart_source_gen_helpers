// import 'package:test/test.dart';
// import 'dart:async';
// import 'package:test/test.dart';

// import 'package:source_gen/source_gen.dart';
// import 'package:build/build.dart';
// import 'package:build_test/build_test.dart';

// import 'package:analyzer/dart/element/element.dart';
// import 'package:build/build.dart';
// import 'package:source_gen/source_gen.dart';

// import 'package:blackbird_common/member_identifier.dart';
// import 'dart:io';
// import 'package:analyzer/dart/element/element.dart';
// import 'package:analyzer/dart/element/type.dart';
// import 'package:source_gen/source_gen.dart';
// import 'package:source_gen_helpers/class/util.dart';
// import 'package:front_end/src/fasta/compiler_context.dart';
main() {}
// String source = '''
// abstract class Top {
//   void aMethod() {}
//   void anOverwrittenMethod();
//   void anAbstractMethod();
// }

// class Bottom {
//   @override
//   void anOverwrittenMethod() {}
// }
// ''';

// main() async {
//   test('', () async {
//     await generate(source);
//     ClassElement classElement = classElements['Bottom'];

//     var list =
//         filterConcreteElements(classElement, allClassMember(classElement))
//             .toList();

//     print(allClassMember(classElement));
//     print(list);
//   }, tags: 'current');
// }

// final Builder builder =
//     new PartBuilder([new ClassElementProvider()], '.g.test.dart');

// Map<String, ClassElement> classElements = {};

// class ClassElementProvider extends Generator {
//   @override
//   FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
//     library.classElements.forEach((e) {
//       classElements.putIfAbsent(e.name, () => e);
//     });
//     return "";
//   }
// }

// final String pkgName = 'pkg';

// generate(String source) async {
//   final srcs = <String, String>{
//     '$pkgName|lib/sometestfile.dart': source,
//     'blackbird_common|lib/member_identifier.dart':
//         await new File('../common/lib/member_identifier.dart').readAsString(),
//   };

//   final writer = new InMemoryAssetWriter();
//   await testBuilder(builder, srcs, rootPackage: pkgName, writer: writer);
// }
