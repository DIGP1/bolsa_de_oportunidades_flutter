import 'package:bolsa_de_oportunidades_flutter/presentations/models/aplicacion_model.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/carreras.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/proyects_model.dart';
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
      print("Error en el registro. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception('Error en el registro');
    }
  }
  Future<User> loginUser(User_login request, BuildContext context) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['data']);
    } else {
      if(response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos', style: TextStyle(color: Colors.white),textAlign: TextAlign.center, textScaler: TextScaler.linear(1.5),),
            backgroundColor: Colors.red,
          ),
        );
      }
      print("Error en el login. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception('Error en el login');
    }
  }
    Future<User> loginUserOpened(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}me'),
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if(data is Map<String, dynamic>) {
        data['token'] = token;
      }
      return User.fromJson(data);

    } else {
      //print('Error al obtener los datos del usuario: ${response.statusCode}');
      //print('Cuerpo de la respuesta: ${response.body}');
      return User.fromJson({'token': token});
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
  Future<List<ProyectsModel>> getProyects(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}proyectos'),
      headers: {
        'Authorization' : 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> proyectosJson = jsonResponse['data'];
      return proyectosJson.map((json) => ProyectsModel.fromJson(json)).toList();
    } else {
      print("Error al obtener las carreras. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception('Error al obtener las carreras');
    }
  }

  Future<bool> editUserInfo(User_Info_Edit request, String token) async {
    final response = await http.patch(
      Uri.parse('${baseUrl}estudiantes/${request.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al editar la información del usuario: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      return false;
    }
  }

  Future<bool> applyProyect(AplicacionModel aplicacion, String token, BuildContext context) async {
    final response = await http.post(
      Uri.parse('${baseUrl}aplicaciones'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(aplicacion.toJson()),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Error al aplicar al proyecto: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al aplicar al proyecto', style: TextStyle(color: Colors.white),textAlign: TextAlign.center, textScaler: TextScaler.linear(1.5),),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
  Future<List<AplicacionModel>> getAplicacionStudent(String token, int id_estudiante) async {
    List<AplicacionModel> aplicaciones = [];
    final response = await http.get(
      Uri.parse('${baseUrl}aplicaciones/estudiante/$id_estudiante'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> aplicacionesJson = jsonResponse['data'];
      return aplicacionesJson.map((json) => AplicacionModel.fromJson(json)).toList();
    } else {
      print("Error al obtener las aplicaciones. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      return aplicaciones;
    }
  }
  Future<bool> deleteAplicacion(int id, String token) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}aplicaciones/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al eliminar la aplicación: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      return false;
    }
  }
}