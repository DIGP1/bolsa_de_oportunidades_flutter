import 'package:bolsa_de_oportunidades_flutter/presentations/models/carreras.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_info_edit.dart';
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
  
  Future<User_Info_Edit> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}me'),
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['user'];
      var userList = data['info_estudiante'];

      if (userList.isNotEmpty) {
        var user = userList[0]; 
        return User_Info_Edit.fromJson(user); 
      } else {
        throw Exception('La lista info_estudiante está vacía');
      }
    } else {
      print('Error al obtener los datos del usuario: ${response.statusCode}');
      throw Exception('Error al obtener los datos del usuario');
    }
  }
  Future<bool> logout(String token) async {
    final response = await http.post(
      Uri.parse('${baseUrl}logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al cerrar sesión: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      throw Exception('Error al cerrar sesión');
    }
  }
}