import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'dart:async';
import 'class_visitor.dart';
import 'helper.dart';

class OverrideVisitor extends ClassVisitor {
  final ClassVisitor delegate;
  OverrideVisitor(this.delegate) : super(delegate.classElement);

  @override
  bool where(ClassMemberElement element) => delegate.where(element);

  List<String> visited = [];
  bool _visitOnce(Element element) {
    String dec = generateDeclaration(element);
    bool result = visited.contains(dec);
    visited.add(dec);
    return result;
  }

  @override
  Completer<String> get classDeclaration => delegate.classDeclaration;

  @override
  visitClassElement(ClassElement element) {
    return delegate.visitClassElement(element);
  }

  @override
  visitMethodElement(MethodElement element) async {
    if (_visitOnce(element)) return '';
    return generateMethod(element, delegate.visitMethodElement(element));
  }

  @override
  visitPropertyAccessorElement(PropertyAccessorElement element) async {
    if (_visitOnce(element)) return '';
    return generateMethod(
        element, delegate.visitPropertyAccessorElement(element));
  }

  @override
  visitFieldElement(FieldElement element) async {
    return delegate.visitFieldElement(element);
  }

  @override
  FutureOr<String> visitConstructorElement(ConstructorElement element) {
    return delegate.visitConstructorElement(element);
  }

  Future<String> generateMethod(
      ExecutableElement element, FutureOr<String> body) async {
    String declaration = generateDeclaration(element);
    String bodyText = await body;
    if (bodyText.isEmpty) return '';
    String tail = methodTail(await body);
    return '''$declaration $tail''';
  }

//TODO cleanup
  String methodTail(String methodBody) {
    if (methodBody.isEmpty) return '';
    return methodBody;
  }
}
