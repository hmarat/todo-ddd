import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd/domain/auth/auth_failures.dart';
import 'package:ddd/domain/auth/i_auth_facade.dart';
import 'package:ddd/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((event, emit) {
      event.map(
        emailChanged: (e) async* {
          emit(
            state.copyWith(
              emailAddress: EmailAddress(e.emailStr),
              authFailureOrSuccess: none(),
            ),
          );
        },
        passwordChanged: (e) async* {
          emit(
            state.copyWith(
              password: Password(e.passwordStr),
              authFailureOrSuccess: none(),
            ),
          );
        },
        registerWithEmailAndPasswordPressed: (e) async* {
          _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.registerWithEmailAndPassword,
            emit: emit,
          );
        },
        signInWithEmailAndPasswordPressed: (e) async* {
          _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.signInWithEmailAndPassword,
            emit: emit,
          );
        },
        signInWithGooglePressed: (e) async* {
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
        },
      );
    });
  }

  _performActionOnAuthFacadeWithEmailAndPassword(
      Future<Either<AuthFailure, Unit>> Function({
    required EmailAddress emailAddress,
    required Password password,
  })
          forwardedCall,
      {required emit}) async* {
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
