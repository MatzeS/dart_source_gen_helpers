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

List<Element> filterConcreteElements(
    ClassElement classElement, List<Element> elements) {
  return elements.where((e) {
    List<Element> equalDeclarations =
        elements.where((e2) => e.toString() == e2.toString()).toList();
    if (equalDeclarations.isEmpty || equalDeclarations.length == 1) return true;

    equalDeclarations.sort((a, b) {
      var c = a.getAncestor((a) => true);
      var d = b.getAncestor((a) => true);
      if (c is ClassElement) {
        if (d is ClassElement) {
          if (c.type == d.type) return 0;
          // if (classElement.name.contains('RC')) if (c.type.isSubtypeOf(d.type))
          //   print(
          //       '$e: ${c.name} is below ${d.name}, ${(a as dynamic).isAbstract} ${(b as dynamic).isAbstract}');
          return c.type.isSubtypeOf(d.type) ? 1 : -1;
        }
      }
      throw new Exception('$c or $d are not class elements');
    });

    // print(equalDeclarations.first.getAncestor((a) => true).name.toString() +
    //     ' is first in line vs ${e.getAncestor((a) => true).name}');
    return equalDeclarations.last == e;
  }).toList();
}

ExecutableElement lookUp(ExecutableElement e, ClassElement ce) {
  if (e is MethodElement) return ce.lookUpMethod(e.name, ce.library);
  if (e is PropertyAccessorElement) {
    if (e.isGetter) return ce.lookUpGetter(e.name, ce.library);
    if (e.isSetter) return ce.lookUpSetter(e.name, ce.library);
  }
  throw new Exception('invalid argument');
}

bool isConcrete(ExecutableElement e, ClassElement ce) {
  var list = [];
  ce.methods.forEach(list.add);
  ce.accessors.forEach(list.add);
  ce.allSupertypes.map((st) => st.methods).forEach(list.addAll);
  ce.allSupertypes.map((st) => st.accessors).forEach(list.addAll);
  return list.any((c) => c.name == e.name && !c.isAbstract);
}
