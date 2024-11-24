import 'package:bolsa_de_oportunidades_flutter/presentations/models/carreras.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_login.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api_Request {
  static const String baseUrl = 'https://bolsa-de-oportunidades.fusionartsv.com/api/';
  final http.Client client;
  Api_Request({http.Client? client}) : client = client ?? http.Client();

  Future<bool> registerUser(User_register request) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error en el registro');
    }
  }
  Future<User> loginUser(User_login request) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print("Error en el login. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception('Error en el login');
    }
  }
  Future<List<Carreras>> getCarreras() async {
    final response = await http.get(Uri.parse('${baseUrl}carreras'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> carrerasJson = jsonResponse['data'];
      return carrerasJson.map((json) => Carreras.fromJson(json)).toList();
    } else {
      print("Error al obtener las carreras. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception('Error al obtener las carreras');
    }
  }
}