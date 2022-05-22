import 'package:ddd/domain/auth/user.dart';
import 'package:ddd/domain/core/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

extension FirebaseUserDomainX on firebaseAuth.User {
  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
