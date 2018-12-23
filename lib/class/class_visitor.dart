import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'dart:async';
import 'output_visitor.dart';

/// Generating code by visiting a class and its elements
abstract class ClassVisitor<T> extends ThrowingElementVisitor<T>
    with VisitingStrategies<T> {
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

mixin VisitingStrategies<T> implements ElementVisitor<T> {
  visitAll(List<Element> elements) => elements.map((e) => e.accept(this));

  visitDirectExecutables(ClassElement element) => <ExecutableElement>[]
      .followedBy(element.accessors)
      .followedBy(element.methods)
      .map((e) => e.accept(this));

  visitAllExecutables(ClassElement element) => <ExecutableElement>[]
      .followedBy(element.accessors)
      .followedBy(element.methods)
      .followedBy(element.allSupertypes.expand((e) => e.accessors))
      .followedBy(element.allSupertypes.expand((e) => e.methods))
      .map((e) => e.accept(this));
}
