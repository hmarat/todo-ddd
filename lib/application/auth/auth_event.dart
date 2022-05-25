part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkRequested() = _AuthCheckRequested;
  const factory AuthEvent.signedOut() = _SignedOut;
}
