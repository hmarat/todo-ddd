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
    on<_EmailChanged>((e, emit) {
      emit(
        state.copyWith(
          emailAddress: EmailAddress(e.emailStr),
          authFailureOrSuccess: none(),
        ),
      );
    });

    on<_PasswordChanged>((e, emit) {
      emit(
        state.copyWith(
          password: Password(e.passwordStr),
          authFailureOrSuccess: none(),
        ),
      );
    });

    on<_SignInWithEmailAndPasswordPressed>((e, emit) async {
      await _performActionOnAuthFacadeWithEmailAndPassword(
        _authFacade.signInWithEmailAndPassword,
        emit: emit,
      );
    });

    on<_RegisterWithEmailAndPasswordPressed>((e, emit) async {
      await _performActionOnAuthFacadeWithEmailAndPassword(
        _authFacade.registerWithEmailAndPassword,
        emit: emit,
      );
    });

    on<_SignInWithGooglePressed>((e, emit) async {
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
    });
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
