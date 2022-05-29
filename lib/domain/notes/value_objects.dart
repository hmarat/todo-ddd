import 'package:dartz/dartz.dart';
import 'package:ddd/domain/core/failures.dart';
import 'package:ddd/domain/core/value_objects.dart';
import 'package:ddd/domain/core/value_transformers.dart';
import 'package:ddd/domain/core/value_validators.dart';
import 'package:flutter/rendering.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 1000;

  factory NoteBody(String input) => NoteBody._(
        validateStringMaxLength(input, maxLength).flatMap(
          validateStringNotEmpty,
        ),
      );

  const NoteBody._(this.value);
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 30;

  factory TodoName(String input) => TodoName._(
        validateStringMaxLength(input, maxLength)
            .flatMap(validateStringNotEmpty)
            .flatMap(validateSingleLine),
      );

  const TodoName._(this.value);
}

class NoteColor extends ValueObject<Color> {
  @override
  final Either<ValueFailure<Color>, Color> value;

  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  factory NoteColor(Color input) => NoteColor._(
        right(makeColorOpaque(input)),
      );

  const NoteColor._(this.value);
}

class List3<T> extends ValueObject<IList<T>> {
  @override
  final Either<ValueFailure<IList<T>>, IList<T>> value;

  static const maxLength = 3;

  factory List3(IList<T> input) => List3._(
        validateMaxListLength(input, 3),
      );

  const List3._(this.value);

  int get length => value.getOrElse(() => IList.from([])).length();

  bool get isFull => length == maxLength;
}
