import 'package:ddd/domain/core/failures.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const explanation =
        'Encountered A ValueFailure at an unrecoverable point. Terminating.';

    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}
