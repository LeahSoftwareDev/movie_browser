abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Connection timed out. Please try again.');
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure() : super('Invalid API key. Please check your configuration.');
}