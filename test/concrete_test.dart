import 'dart:io';
import 'package:test/test.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen_helpers/test/generation.dart';
import 'package:source_gen_helpers/class/util.dart';

String source = '''
abstract class Top {
  void aMethod() {}
  void anOverwrittenMethod();
  void anAbstractMethod();
}

class Bottom {
  @override
  void anOverwrittenMethod() {}
}
''';

main() async {
  test('', () async {
    var g = new Generation();
    final srcs = <String, String>{
      'pkg|lib/sometestfile.dart': source,
    };
    await g.generate(srcs);
    ClassElement classElement = g.classElements['Bottom'];

    List<Element> list =
        filterConcreteElements(classElement, allClassMember(classElement))
            .toList();

    expect(
        list.where((e) => e.name.contains('anAbstractMethod')).isEmpty, true);
  });
}
