import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'dart:async';
import 'output_visitor.dart';

/// Generating code by visiting a class and its elements
abstract class ClassVisitor extends ThrowingElementVisitor<FutureOr<String>> {
  final Completer<ClassElement> classElementCompleter = new Completer();
  final Completer<String> classDeclarationCompleter = new Completer();
  Future<ClassElement> get classElement => classElementCompleter.future;
  Future<String> get classDeclaration => classDeclarationCompleter.future;

  get className async => (await classElement).name;

  @override
  FutureOr<String> visitClassElement(ClassElement element) {
    classElementCompleter.complete(element);
    return '';
  }
}
