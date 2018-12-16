import 'package:analyzer/dart/element/element.dart';

List<Element> allClassChildren(ClassElement classElement) {
  List<Element> result = [];
  result.addAll(classElement.methods);
  result.addAll(classElement.accessors);
  result.addAll(classElement.fields);
  result.addAll(classElement.constructors);
  return result;
}

List<Element> allClassMember(ClassElement element) {
  List<Element> elements = [];
  elements.addAll(element.allSupertypes
      .map((e) => e.accessors)
      .fold<List<Element>>([], (a, b) {
    a.addAll(b);
    return a;
  }));
  elements.addAll(element.allSupertypes
      .map((e) => e.methods)
      .fold<List<Element>>([], (a, b) {
    a.addAll(b);
    return a;
  }).toList());
  elements.addAll(element.methods);
  elements.addAll(element.accessors);
  elements.addAll(element.constructors);
  elements.addAll(element.fields);
  return elements;
}

Future<void> visitElements(
    ElementVisitor<Future<void>> visitor, List<Element> elements) async {
  List<Future<void>> accepted = elements.map((e) => e.accept(visitor)).toList();
  return await Future.wait(accepted);
}
