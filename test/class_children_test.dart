import 'package:test/test.dart';
import '../lib/test/generation.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen_helpers/class/util.dart';

main() {
  group('', () {
    Map<String, ClassElement> classElements;
    setUpAll(() async {
      classElements = await testClassElements;
    });
    test('number of children, FullClass', () async {
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
  });
}
