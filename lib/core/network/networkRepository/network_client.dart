import 'package:flutter/cupertino.dart';

abstract class NetworkClient{

  String getHttpErrorMessage({ @required int statusCode});

}