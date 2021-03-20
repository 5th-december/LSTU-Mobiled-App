import 'package:lk_client/model/response/business_logic_error.dart';

class BusinessLogicException implements Exception
{
  final BusinessLogicError error;

  BusinessLogicException({this.error});
}