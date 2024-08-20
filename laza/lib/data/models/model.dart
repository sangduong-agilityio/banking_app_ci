import 'dart:async';
import 'package:macros/macros.dart';

// Define the macro class `Model` that implements `ClassDeclarationsMacro`.
macro class Model implements ClassDeclarationsMacro {
  const Model();

  // List of base types for primitives.
  static const _baseTypes = ['bool', 'double', 'int', 'num', 'String'];
  // List of collection types (e.g., List) for special handling.
  static const _collectionTypes = ['List'];

  // This method is called to generate code for class being processed by the macro.
  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration classDeclaration,
    MemberDeclarationBuilder builder,
  ) async {
    // Get the name of the class.
    final className = classDeclaration.identifier.name;

    // Retrieve all fields of the class.
    final fields = await builder.fieldsOf(classDeclaration);

    // Initialize containers to store field names, types, and generic types.
    final fieldNames = <String>[];
    final fieldTypes = <String, String>{};
    final fieldGenerics = <String, List<String>>{};

    // Iterate through each field to categorize and store information.
    for (final field in fields) {
      final fieldName = field.identifier.name;
      fieldNames.add(fieldName);

      final fieldType = (field.type.code as NamedTypeAnnotationCode).name.name;
      fieldTypes[fieldName] = fieldType;

      // Check if the field is a collection and extract its generic types if applicable.
      if (_collectionTypes.contains(fieldType)) {
        final generics = (field.type.code as NamedTypeAnnotationCode)
            .typeArguments
            .map((e) => (e as NamedTypeAnnotationCode).name.name)
            .toList();
        fieldGenerics[fieldName] = generics;
      }
    }

    // Create a map that includes generic types for collection fields.
    final fieldTypesWithGenerics = fieldTypes.map(
      (name, type) {
        final generics = fieldGenerics[name];
        return MapEntry(
          name,
          generics == null ? type : '$type<${generics.join(', ')}>',
        );
      },
    );

    // Generate code for JSON deserialization, serialization, copyWith, toString, equality, and hashCode.
    _buildFromJson(builder, className, fieldNames, fieldTypes, fieldGenerics);
    _buildToJson(builder, fieldNames, fieldTypes);
    _buildCopyWith(builder, className, fieldNames, fieldTypesWithGenerics);
    _buildToString(builder, className, fieldNames);
    _buildEquals(builder, className, fieldNames);
    _buildHashCode(builder, fieldNames);
  }

  // Generate the `fromJson` factory constructor.
  void _buildFromJson(
    MemberDeclarationBuilder builder,
    String className,
    List<String> fieldNames,
    Map<String, String> fieldTypes,
    Map<String, List<String>> fieldGenerics,
  ) {
    final code = [
      'factory $className.fromJson(Map<String, dynamic> json) {'.indent(2),
      'return $className('.indent(4),
      for (final fieldName in fieldNames) ...[
        if (_baseTypes.contains(fieldTypes[fieldName])) ...[
          "$fieldName: json['$fieldName'] as ${fieldTypes[fieldName]},"
              .indent(6),
        ] else if (_collectionTypes.contains(fieldTypes[fieldName])) ...[
          "$fieldName: (json['$fieldName'] as List<dynamic>)".indent(6),
          '.whereType<Map<String, dynamic>>()'.indent(10),
          '.map(${fieldGenerics[fieldName]?.first}.fromJson)'.indent(10),
          '.toList(),'.indent(10),
        ] else ...[
          '$fieldName: ${fieldTypes[fieldName]}'
                  ".fromJson(json['$fieldName'] "
                  'as Map<String, dynamic>),'
              .indent(6),
        ],
      ],
      ');'.indent(4),
      '}'.indent(2),
    ].join('\n');
    builder.declareInType(DeclarationCode.fromString(code));
  }

  // Generate the `toJson` method.
  void _buildToJson(
    MemberDeclarationBuilder builder,
    List<String> fieldNames,
    Map<String, String> fieldTypes,
  ) {
    final code = [
      'Map<String, dynamic> toJson() {'.indent(2),
      'return {'.indent(4),
      for (final fieldName in fieldNames) ...[
        if (_baseTypes.contains(fieldTypes[fieldName])) ...[
          "'$fieldName': $fieldName,".indent(6),
        ] else if (_collectionTypes.contains(fieldTypes[fieldName])) ...[
          "'$fieldName': $fieldName.map((e) => e.toJson()).toList(),".indent(6),
        ] else ...[
          "'$fieldName': $fieldName.toJson(),".indent(6),
        ],
      ],
      '};'.indent(4),
      '}'.indent(2),
    ].join('\n');
    builder.declareInType(DeclarationCode.fromString(code));
  }

  // Generate the `copyWith` method.
  void _buildCopyWith(
    MemberDeclarationBuilder builder,
    String className,
    List<String> fieldNames,
    Map<String, String> fieldTypes,
  ) {
    final code = [
      '$className copyWith({'.indent(2),
      for (final fieldName in fieldNames) ...[
        '${fieldTypes[fieldName]}? $fieldName,'.indent(4),
      ],
      '}) {'.indent(2),
      'return $className('.indent(4),
      for (final fieldName in fieldNames) ...[
        '$fieldName: $fieldName ?? this.$fieldName,'.indent(6),
      ],
      ');'.indent(4),
      '}'.indent(2),
    ].join('\n');
    builder.declareInType(DeclarationCode.fromString(code));
  }

  // Generate the `toString` method.
  void _buildToString(
    MemberDeclarationBuilder builder,
    String className,
    List<String> fieldNames,
  ) {
    final code = [
      '@override'.indent(2),
      'String toString() {'.indent(2),
      "return '$className('".indent(4),
      for (final fieldName in fieldNames) ...[
        if (fieldName != fieldNames.last) ...[
          "'$fieldName: \$$fieldName, '".indent(8),
        ] else ...[
          "'$fieldName: \$$fieldName'".indent(8),
        ],
      ],
      "')';".indent(8),
      '}'.indent(2),
    ].join('\n');
    builder.declareInType(DeclarationCode.fromString(code));
  }

  // Generate the `==` operator method.
  void _buildEquals(
    MemberDeclarationBuilder builder,
    String className,
    List<String> fieldNames,
  ) {
    final code = [
      '@override'.indent(2),
      'bool operator ==(Object other) {'.indent(2),
      'return other is $className &&'.indent(4),
      'runtimeType == other.runtimeType &&'.indent(8),
      for (final fieldName in fieldNames) ...[
        if (fieldName != fieldNames.last) ...[
          '$fieldName == other.$fieldName &&'.indent(8),
        ] else ...[
          '$fieldName == other.$fieldName;'.indent(8),
        ],
      ],
      '}'.indent(2),
    ].join('\n');
    builder.declareInType(DeclarationCode.fromString(code));
  }

  // Generate the `hashCode` getter.
  void _buildHashCode(
    MemberDeclarationBuilder builder,
    List<String> fieldNames,
  ) {
    final code = [
      '@override'.indent(2),
      'int get hashCode {'.indent(2),
      'return Object.hash('.indent(4),
      'runtimeType,'.indent(6),
      for (final fieldName in fieldNames) ...[
        '$fieldName,'.indent(6),
      ],
      ');'.indent(4),
      '}'.indent(2),
    ].join('\n');
    builder.declareInType(DeclarationCode.fromString(code));
  }
}

// Helper extension to add indentation to generated code for readability.
extension on String {
  String indent(int length) {
    final space = StringBuffer();
    for (var i = 0; i < length; i++) {
      space.write(' ');
    }
    return '$space$this';
  }
}
