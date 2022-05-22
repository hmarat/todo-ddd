// Unique id

import 'package:ddd/domain/core/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@immutable
@freezed
abstract class User with _$User {
  const factory User({
    required UniqueId id,
  }) = _User;
}
