import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'dart:async';
import 'output_visitor.dart';

abstract class ClassVisitor extends ThrowingElementVisitor<FutureOr<String>> {
  Completer<String> classDeclaration = new Completer();

  final ClassElement classElement;
  get className => classElement.name;

  ClassVisitor(this.classElement);

  bool where(ClassMemberElement element) => true;
}
