import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

bool isAnnotatedWithType<T>(Element element) {
  return TypeChecker.fromRuntime(T).annotationsOf(element).isNotEmpty;
}

bool isAnnotatedWithConstant(Element element, String constantValue) {
  return element.metadata
      .map((e) => e.constantValue.toString().trim())
      .contains(constantValue);
}
