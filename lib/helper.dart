import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'output_visitor.dart';

enum DeviceClassElement {
  property,
  runtime, //,state
  executive,
}

// bool isAnnotatedWith<T>(Element element) {
//   return TypeChecker.fromRuntime(T).annotationsOf(element).isNotEmpty;
// }

bool isAnnotatedWith(Element element, String constantValue) {
  if (element == null) return false;
  return element.metadata
      .map((e) => e.constantValue.toString().trim())
      .contains(constantValue);
}

String generateArgumentDeclarations(ExecutableElement element) {
  bool hasNamedArgs = element.parameters.any((p) => p.isNamed);
  bool hasPositionalArgs =
      element.parameters.any((p) => p.isPositional && p.isOptional);
  if (hasNamedArgs && hasPositionalArgs) {
    log.severe('named and positional arguments $element');
  }
  String argumentEncoder(Iterable<ParameterElement> elements) =>
      elements.map((p) => '${p.type.name} ${p.name}').join(', ');
  String declarationRequiredArguments =
      argumentEncoder(element.parameters.where((p) => p.isNotOptional));
  String declarationPositionalArguments = argumentEncoder(
      element.parameters.where((p) => p.isPositional && p.isOptional));
  String declarationNamedArguments =
      argumentEncoder(element.parameters.where((p) => p.isNamed));
  String argumentDeclarations = declarationRequiredArguments;
  if ((hasNamedArgs || hasPositionalArgs) &&
      declarationRequiredArguments.isNotEmpty) argumentDeclarations += ', ';
  if (hasPositionalArgs) {
    argumentDeclarations += '[' + declarationPositionalArguments + ']';
  }
  if (hasNamedArgs) {
    argumentDeclarations += '{' + declarationNamedArguments + '}';
  }

  return argumentDeclarations;
}

String generateDeclaration(ExecutableElement element) {
  String argumentDeclarations = generateArgumentDeclarations(element);

  bool isSetter = element is PropertyAccessorElement && element.isSetter;
  bool isGetter = element is PropertyAccessorElement && element.isGetter;

  StringBuffer output = new StringBuffer();
  if (isSetter) {
    output.write('set ');
  } else {
    output.write(element.returnType.toString() + ' ');
  }
  if (isGetter) output.write(' get ');
  output.write(element.displayName);
  if (!isGetter) {
    output.write(' ( ');
    output.write(argumentDeclarations);
    output.write(' ) ');
  }
  output.write(element.isAsynchronous ? ' async ' : '');
  return output.toString();
}

List<Element> allClassChildren(ClassElement element) {
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
  elements.addAll(element.constructors);
  elements.addAll(element.methods);
  elements.addAll(element.accessors);
  elements.addAll(element.fields);
  elements = elements
      .where((e) => e.metadata.every((a) {
            return a.constantValue != null
                ? !TypeChecker.fromUrl('asset:blackbird/lib/device.dart#Ignore')
                    .isAssignableFromType(a.constantValue.type)
                : true;
          }))
      .toList();
  elements = elements.where((e) {
    if (e.enclosingElement is! ClassElement) return true;
    ClassElement classElement = e.enclosingElement as ClassElement;
    return !classElement.type.isObject;
  }).toList();
  return elements;
}
