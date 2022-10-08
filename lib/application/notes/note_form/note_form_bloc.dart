import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd/domain/notes/note.dart';
import 'package:ddd/domain/notes/note_failure.dart';
import 'package:ddd/domain/notes/value_objects.dart';
import 'package:ddd/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  NoteFormBloc() : super(NoteFormState.initial()) {
    on<_Initialized>(_handleInitialized);
    on<_BodyChanged>(_handleBodyChanged);
    on<_TodosChanged>(_handleTodosChanged);
  }

  _handleInitialized(_Initialized event, Emitter emit) {
    emit(
      event.noteOption.fold(
        () => state,
        (n) => state.copyWith(note: n),
      ),
    );
  }

  _handleBodyChanged(_BodyChanged event, Emitter emit) {
    emit(
      state.copyWith(
        note: state.note.copyWith(
          body: NoteBody(event.bodyStr),
        ),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  _handleTodosChanged(_TodosChanged event, Emitter emit) {
    //
  }
}
