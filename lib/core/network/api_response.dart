class ApiResponse<T> {
  final T? data;
  final String? errorMessage;
  final int statusCode;
  final bool isSuccess;

  ApiResponse.success(this.data)
      : isSuccess = true,
        errorMessage = null,
        statusCode = 200;

  ApiResponse.error(this.errorMessage, {this.statusCode = 500})
      : isSuccess = false,
        data = null;
}
