import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/custom_exception.dart';
part 'resource.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T body) = Success<T>;
  const factory Result.error(CustomException error) = Error<T>;
}
