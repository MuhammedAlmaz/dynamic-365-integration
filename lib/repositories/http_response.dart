

class HttpResponseRepository<T> {
  bool hasError;
  int statusCode;
  String errorCode;
  String errorMessage;
  T? response;

  HttpResponseRepository({
    this.hasError = false,
    this.statusCode = 200,
    this.errorCode = "",
    this.errorMessage = "",
    required this.response,
  });
}
