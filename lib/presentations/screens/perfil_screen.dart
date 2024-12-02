import 'dart:ffi';

import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_info_edit.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/login_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/perfil_editar_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/registro_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Api_Request api = Api_Request();
  User_Info_Edit? userInfo;
  bool _isLoading = true;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfoUser();
  }

   Future<void> _getInfoUser() async {
    try {
      print("Tratando de cargar la información del usuario");
      User_Info_Edit infoUser = await api.getUserInfo(widget.user.token);
      setState(() {
        userInfo = infoUser;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las carreras: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  _isLoading ? const Center(child: CircularProgressIndicator()) : SafeArea(
        child: Column(
          children: [
            _buildHeader(widget.user),
            Expanded(
              child: _buildProfileContent(context, api, widget, userInfo!),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildHeader(User user) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF9C241C), Color(0xFFBF2E24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Color(0xFF9C241C),
            ),
          ),
        ),
        const SizedBox(height: 3),
        
        Text(
          "${userInfo?.nombres} ${userInfo?.apellidos}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 3,
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3), 
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), 
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.email,
                size: 14, 
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 3),
              Text(
                '${userInfo?.email}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 1), 
      ],
    ),
  );
}
}

  Widget _buildProfileContent(BuildContext context, Api_Request api, dynamic widget, User_Info_Edit userInfo) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _buildSection('Información Personal', [
          _buildListTile(context,api,widget,userInfo,Icons.person_outline, 'Editar Perfil'),
        ]),
        const SizedBox(height: 15),
        _buildSection('Cuenta', [
          _buildListTile(context,api,widget,userInfo,Icons.logout, 'Cerrar Sesión', color: Colors.red),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C241C),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, Api_Request api,dynamic widget,User_Info_Edit userInfo, IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF9C241C)),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async{
        if (title == 'Cerrar Sesión') {
          if(await api.logout(widget.user.token)){
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('user_token');
            Navigator.pushReplacement(context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => EditProfileScreen(user: widget.user, userinfo: userInfo)));
        }

      },
    );
  }

