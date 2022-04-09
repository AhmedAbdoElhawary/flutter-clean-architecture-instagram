abstract class UseCase<R, P> {
  Future<R> call({required P params});
}

abstract class UseCaseTwoParams<R, A, B> {
  Future<R> call({required A paramsOne, required B paramsTwo});
}
