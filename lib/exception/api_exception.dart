class ApiException implements Exception
{
  String message;

  ApiException({this.message = 'An error occured during connection to server'});
}