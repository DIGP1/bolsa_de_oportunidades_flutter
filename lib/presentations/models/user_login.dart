class User_login{
  final String email;
  final String password;

  User_login({
    required this.email,
    required this.password
  });
   Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
   }
}