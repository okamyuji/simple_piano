import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// ユースケースの基底クラス
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// パラメータなしのユースケース
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// パラメータなしを表すクラス
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
