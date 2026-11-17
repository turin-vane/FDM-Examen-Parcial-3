import 'package:aplicacion2/core/storage/local_storage_service.dart';
import 'package:aplicacion2/features/auth/screens/login_screen.dart';
import 'package:aplicacion2/features/workouts/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AuthCheckScreen extends StatefulWidget{
  const AuthCheckScreen({super.key});
  @override
  
  State<StatefulWidget> createState()=> _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<StatefulWidget>{
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState(){
    super.initState();
    _checkToken();
  }

Future<void> _checkToken() async{
  final token = await _storage.getToken();

  if(!mounted) return;

  if(token != null && token.isNotEmpty){
    //Home
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context)=> HomeScreen()),
      );
  } else{
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context)=> LoginScreen()),
      );
  }
}

  @override
  Widget build(BuildContext context){
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}