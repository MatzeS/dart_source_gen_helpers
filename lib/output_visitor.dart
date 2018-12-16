import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'dart:async';
import 'class_visitor.dart';

class ClassOutputVisitor implements ElementVisitor<Future<void>> {
  ClassVisitor delegate;
  ClassOutputVisitor(this.delegate);

  StringBuffer _buffer = new StringBuffer();
  get output async {
    return (await delegate.classDeclaration.future) +
        '{' +
        _buffer.toString() +
        '}';
  }

  Future<void> visitElements(List<Element> elements) async {
    List<Future<void>> accepted = elements
        .where((e) => e is! ClassMemberElement || delegate.where(e))
        .map((e) => e.accept(this))
        .toList();
    return await Future.wait(accepted);
  }

  @override
  visitClassElement(ClassElement element) async =>
      _buffer.writeln(await delegate.visitClassElement(element) ?? '');

  @override
  visitCompilationUnitElement(CompilationUnitElement element) async => _buffer
      .writeln(await delegate.visitCompilationUnitElement(element) ?? '');

  @override
  visitConstructorElement(ConstructorElement element) async =>
      _buffer.writeln(await delegate.visitConstructorElement(element) ?? '');

  @override
  visitExportElement(ExportElement element) async =>
      _buffer.writeln(await delegate.visitExportElement(element) ?? '');

  @override
  visitFieldElement(FieldElement element) async =>
      _buffer.writeln(await delegate.visitFieldElement(element) ?? '');

  @override
  visitFieldFormalParameterElement(FieldFormalParameterElement element) async =>
      _buffer.writeln(
          await delegate.visitFieldFormalParameterElement(element) ?? '');

  @override
  visitFunctionElement(FunctionElement element) async =>
      _buffer.writeln(await delegate.visitFunctionElement(element) ?? '');

  @override
  visitFunctionTypeAliasElement(FunctionTypeAliasElement element) async =>
      _buffer
          .writeln(await delegate.visitFunctionTypeAliasElement(element) ?? '');

  @override
  visitGenericFunctionTypeElement(GenericFunctionTypeElement element) async =>
      _buffer.writeln(
          await delegate.visitGenericFunctionTypeElement(element) ?? '');

  @override
  visitImportElement(ImportElement element) async =>
      _buffer.writeln(await delegate.visitImportElement(element) ?? '');

  @override
  visitLabelElement(LabelElement element) async =>
      _buffer.writeln(await delegate.visitLabelElement(element) ?? '');

  @override
  visitLibraryElement(LibraryElement element) async =>
      _buffer.writeln(await delegate.visitLibraryElement(element) ?? '');

  @override
  visitLocalVariableElement(LocalVariableElement element) async =>
      _buffer.writeln(await delegate.visitLocalVariableElement(element) ?? '');

  @override
  visitMethodElement(MethodElement element) async =>
      _buffer.writeln(await delegate.visitMethodElement(element) ?? '');

  @override
  visitMultiplyDefinedElement(MultiplyDefinedElement element) async => _buffer
      .writeln(await delegate.visitMultiplyDefinedElement(element) ?? '');

  @override
  visitParameterElement(ParameterElement element) async =>
      _buffer.writeln(await delegate.visitParameterElement(element) ?? '');

  @override
  visitPrefixElement(PrefixElement element) async =>
      _buffer.writeln(await delegate.visitPrefixElement(element) ?? '');

  @override
  visitPropertyAccessorElement(PropertyAccessorElement element) async => _buffer
      .writeln(await delegate.visitPropertyAccessorElement(element) ?? '');

  @override
  visitTopLevelVariableElement(TopLevelVariableElement element) async => _buffer
      .writeln(await delegate.visitTopLevelVariableElement(element) ?? '');

  @override
  visitTypeParameterElement(TypeParameterElement element) async =>
      _buffer.writeln(await delegate.visitTypeParameterElement(element) ?? '');
}
