import 'package:fpdart/fpdart.dart';
import 'package:the_haha_guys/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
