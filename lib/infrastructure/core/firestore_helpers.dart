import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ddd/domain/core/errors.dart';
import 'package:ddd/infrastructure/auth/firebase_auth_facade.dart';
import 'package:ddd/injection.dart';

extension FirestoreX on FirebaseFirestore {
  DocumentReference userDocument() {
    final userOption = getIt<FirebaseAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
