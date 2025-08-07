abstract class Failure {
  final String message;
  Failure(this.message);
}

class AssetFailure extends Failure {
  AssetFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
