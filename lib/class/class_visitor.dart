import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'dart:async';

/// Generating a new class by visiting a class and its elements
///
/// Generally this is used together with [OverrideVisitor] and [OutputVisitor]
/// in order to create a duplicate class with some modifications.
abstract class ClassVisitor<T> extends ThrowingElementVisitor<T> {
  final Completer<ClassElement> classElementCompleter = new Completer();
  final Completer<String> classDeclarationCompleter = new Completer();
  Future<ClassElement> get classElement => classElementCompleter.future;
  Future<String> get classDeclaration => classDeclarationCompleter.future;

  get className async => (await classElement).name;

  @override
  visitClassElement(ClassElement element) {
    classElementCompleter.complete(element);
    return null;
  }
}
