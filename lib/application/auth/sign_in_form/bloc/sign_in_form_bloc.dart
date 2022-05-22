import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd/domain/auth/auth_failures.dart';
import 'package:ddd/domain/auth/i_auth_facade.dart';
import 'package:ddd/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<_EmailChanged>(_handleEmailChanged);

    on<_PasswordChanged>(_handlePasswordChanged);

    on<_SignInWithEmailAndPasswordPressed>(
      _handleSignInWithEmailAndPasswordChanged,
    );

    on<_RegisterWithEmailAndPasswordPressed>(
      _handleRegisterWithEmailAndPasswordPressed,
    );

    on<_SignInWithGooglePressed>(_handleSignInWIthGooglePressed);
  }

  void _handleEmailChanged(e, emit) {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(e.emailStr),
        authFailureOrSuccess: none(),
      ),
    );
  }

  void _handlePasswordChanged(e, emit) {
    emit(
      state.copyWith(
        password: Password(e.passwordStr),
        authFailureOrSuccess: none(),
      ),
    );
  }

  void _handleRegisterWithEmailAndPasswordPressed(e, emit) async {
    await _performActionOnAuthFacadeWithEmailAndPassword(
      _authFacade.registerWithEmailAndPassword,
      emit: emit,
    );
  }

  void _handleSignInWithEmailAndPasswordChanged(e, emit) async {
    await _performActionOnAuthFacadeWithEmailAndPassword(
      _authFacade.signInWithEmailAndPassword,
      emit: emit,
    );
  }

  _handleSignInWIthGooglePressed(e, emit) async {
    emit(
      state.copyWith(
        authFailureOrSuccess: none(),
        isSubmitting: true,
      ),
    );

    final failureOrSuccess = await _authFacade.signInWithGoogle();

    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccess: some(failureOrSuccess),
      ),
    );
  }

  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
      Future<Either<AuthFailure, Unit>> Function({
    required EmailAddress emailAddress,
    required Password password,
  })
          forwardedCall,
      {required emit}) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccess: none(),
        ),
      );

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccess: optionOf(failureOrSuccess),
      ),
    );
  }
}
