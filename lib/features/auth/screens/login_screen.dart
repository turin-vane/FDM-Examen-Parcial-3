import 'package:aplicacion2/features/auth/services/auth_service.dart';
import 'package:aplicacion2/features/auth/widgets/custom_text_field.dart';
import 'package:aplicacion2/features/workouts/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState()=> _LoginScreenState();


}

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController _usernameController = TextEditingController(text: "emilys");
  final TextEditingController _passwordController = TextEditingController(text: "emilyspass");

  final AuthService _authService= AuthService();
  bool _isLoading = false;
  
  void _iniciarSesion() async{
    setState(() {
      _isLoading = true;
    });

    bool success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if(!mounted) return;

    setState((){
      _isLoading = false;
    });

    if(success){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inicio de sesión exitoso")));
      Navigator.pushReplacement(context,
      MaterialPageRoute(
        builder: (context) => HomeScreen())
      );
    } else{
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al inicio de sesión"),
          backgroundColor: Colors.red,
          ),
        );
    }
  }


 @override  
  Widget build(BuildContext context){
   return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.stretch,
          children:[
            Text(
              'FitTrack Pro',
              style:TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              ),
            SizedBox(height: 40,),
            CustomTextField(controller: _usernameController, label: "Usuario"),
            SizedBox(height: 16,),
            CustomTextField(controller: _passwordController, label: "Contraseña"),
            SizedBox(height: 32),
            _isLoading 
            ? Center(child: CircularProgressIndicator()) 
            : ElevatedButton(
              style : ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical:16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                ),
                onPressed: _iniciarSesion,
                child: Text(
                  "Iniciar Sesión",
                  style: TextStyle(fontSize: 18),
                ),
            ),
          ],
          ),
      ),
    ),
   );
  }
}

