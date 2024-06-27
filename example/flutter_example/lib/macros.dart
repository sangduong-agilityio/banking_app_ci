import 'dart:async';

import 'package:macros/macros.dart';

macro class HelloWorldMacro implements ClassDeclarationsMacro{

  const HelloWorldMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) {
    builder.declareInType(DeclarationCode.fromParts([
      'void hello() {',
      'print("Hello");','}'
    ]));
  }

}
