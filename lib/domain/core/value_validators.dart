import 'package:dartz/dartz.dart';
import 'package:ddd/domain/core/failures.dart';

Either<ValueFailure<String>, String> validateStringMaxLength(
    String input, int maxLength) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.exceedingLength(failedValue: input, max: maxLength),
    );
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(
      ValueFailure.empty(failedValue: input),
    );
  }
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiline(failedValue: input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<IList<T>>, IList<T>> validateMaxListLength<T>(
    IList<T> list, int maxLength) {
  if (list.length() <= maxLength) {
    return right(list);
  } else {
    return left(
      ValueFailure.listTooLong(failedValue: list, max: maxLength),
    );
  }
}

Either<ValueFailure<String>, String> validateEmail(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length < 8) {
    return left(
      ValueFailure.shortPassword(failedValue: input),
    );
  } else {
    return right(input);
  }
}
