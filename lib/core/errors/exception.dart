class CacheException implements Exception {}

class JsonParsingException implements Exception {
  final String message;
  JsonParsingException(this.message);
  @override
  String toString() => 'JsonParsingException: $message';
}
