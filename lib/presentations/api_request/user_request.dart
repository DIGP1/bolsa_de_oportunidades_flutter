import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRequest {
  static const String baseUrl = 'https://bolsa-de-oportunidades.fusionartsv.com/api/';
  final http.Client client;
  UserRequest({http.Client? client}) : this.client = client ?? http.Client();

  
}