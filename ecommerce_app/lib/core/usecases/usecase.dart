import 'package:equatable/equatable.dart';

abstract class Usecase<type, Params> {
  Future<type> call(Params params);
}

class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}