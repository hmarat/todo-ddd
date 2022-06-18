import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd/domain/notes/i_note_repository.dart';
import 'package:ddd/domain/notes/note.dart';
import 'package:ddd/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription? _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository)
      : super(const NoteWatcherState.initial()) {
    on<_WatchAllStarted>(_handleWatchAllStarted);
    on<_WatchUncompletedStarted>(_handleWatchUncompletedStarted);
    on<_NotesReceived>(_handleNotesReceived);
  }

  void _handleWatchAllStarted(event, emit) {
    emit(const NoteWatcherState.loadInProcess());
    _noteStreamSubscription = _noteRepository.watchAll().listen((event) {
      add(NoteWatcherEvent.notesReceived(event));
    });
  }

  void _handleWatchUncompletedStarted(event, emit) {
    emit(const NoteWatcherState.loadInProcess());
    _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
      (event) {
        add(NoteWatcherEvent.notesReceived(event));
      },
    );
  }

  void _handleNotesReceived(_NotesReceived event, emit) {
    emit(
      event.failureOrNotes.fold(
        (f) => NoteWatcherState.loadFailure(f),
        (notes) => NoteWatcherState.loadSuccess(notes),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
