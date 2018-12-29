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
  List<Element> elements = allClassChildren(element);
  elements.addAll(element.allSupertypes.expand((e) => e.accessors));
  elements.addAll(element.allSupertypes.expand((e) => e.methods));
  return elements;
}

List<ExecutableElement> directExecutables(ClassElement element) =>
    <ExecutableElement>[]
        .followedBy(element.accessors)
        .followedBy(element.methods)
        .toList();

List<ExecutableElement> allExecutables(ClassElement element) =>
    <ExecutableElement>[]
        .followedBy(element.accessors)
        .followedBy(element.methods)
        .followedBy(element.constructors)
        .followedBy(element.allSupertypes.expand((e) => e.accessors))
        .followedBy(element.allSupertypes.expand((e) => e.methods))
        .toList();

Future<void> visitElements(
    ElementVisitor<Future<void>> visitor, List<Element> elements) async {
  List<Future<void>> accepted = elements.map((e) => e.accept(visitor)).toList();
  return await Future.wait(accepted);
}

/// Reduces a list of elements down to the most concrete elements
List<T> filterConcreteElements<T extends Element>(
    ClassElement classElement, List<T> elements) {
  return elements.where((e) {
    List<T> equalDeclarations =
        elements.where((e2) => e.toString() == e2.toString()).toList();
    if (equalDeclarations.isEmpty || equalDeclarations.length == 1) return true;

    equalDeclarations.sort((a, b) {
      var c = a.getAncestor((a) => true);
      var d = b.getAncestor((a) => true);
      if (c is ClassElement) {
        if (d is ClassElement) {
          if (c.type == d.type) return 0;
          return c.type.isSubtypeOf(d.type) ? 1 : -1;
        }
      }
      throw new Exception('$c or $d are not class elements');
    });

    return equalDeclarations.last == e;
  }).toList();
}

/// Returns most concrete executable version with respect to the given class element
ExecutableElement lookUpMostConcrete(ExecutableElement e, ClassElement ce) {
  if (e is MethodElement) return ce.lookUpMethod(e.name, ce.library);
  if (e is PropertyAccessorElement) {
    if (e.isGetter) return ce.lookUpGetter(e.name, ce.library);
    if (e.isSetter) return ce.lookUpSetter(e.name, ce.library);
  }
  throw new Exception('invalid argument');
}

/// Returns true, if the element is not implemented in the given class
bool isConcrete(ExecutableElement e, ClassElement ce) {
  var list = [];
  ce.methods.forEach(list.add);
  ce.accessors.forEach(list.add);
  ce.allSupertypes.map((st) => st.methods).forEach(list.addAll);
  ce.allSupertypes.map((st) => st.accessors).forEach(list.addAll);
  return list.any((c) => c.name == e.name && !c.isAbstract);
}
