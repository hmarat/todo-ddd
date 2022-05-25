import 'package:bloc/bloc.dart';
import 'package:ddd/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial()) {
    on<_AuthCheckRequested>(_handleAuthCheckRequested);
    on<_SignedOut>(_handleSignedOut);
  }

  void _handleAuthCheckRequested(event, emit) {
    final userOption = _authFacade.getSignedInUser();

    emit(
      userOption.fold(
        () => const AuthState.unauthenticated(),
        (_) => const AuthState.authenticated(),
      ),
    );
  }

  void _handleSignedOut(event, emit) async {
    await _authFacade.signOut();

    emit(const AuthState.unauthenticated());
  }
}
