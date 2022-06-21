import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd/domain/notes/i_note_repository.dart';
import 'package:ddd/domain/notes/note_failure.dart';
import 'package:ddd/domain/notes/note.dart';
import 'package:ddd/infrastructure/note/note_dtos.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:ddd/infrastructure/core/firestore_helpers.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  const NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = _firestore.userDocument();
    yield* userDoc.noteCollection
        .snapshots()
        .map<Either<NoteFailure, KtList<Note>>>(
          (snapshot) => right(
            snapshot.docs
                .map(
                  (doc) => NoteDTO.fromFirestore(doc).toDomain(),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (error, stackTrace) {
        if (error is PlatformException &&
            (error.message?.contains('permission_denied') ?? false)) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = _firestore.userDocument();
    yield* userDoc.noteCollection
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) => NoteDTO.fromFirestore(doc).toDomain(),
          ),
        )
        .map<Either<NoteFailure, KtList<Note>>>(
          (notes) => right(
            notes
                .where(
                  (note) =>
                      note.todos.getOrCrash().any((todoItem) => !todoItem.done),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (error, stackTrace) {
        if (error is PlatformException &&
            (error.message?.contains('permission_denied') ?? false)) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
