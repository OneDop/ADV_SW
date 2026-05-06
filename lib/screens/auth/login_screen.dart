import 'package:advsw/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:advsw/screens/auth/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //colors
  final Color primaryTeal = const Color(0xFF004253);
  final Color grayText = const Color(0xFF6E797C);
  final Color bgColor = const Color(0xFFF2F4F6);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
          body: SafeArea(child:SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
        children: [
          SizedBox(height: 20,),
          Icon(Icons.folder,color: primaryTeal,size: 70,),
          SizedBox(height: 10,),
          Text('ADV SW',style: TextStyle(
            color: primaryTeal,
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          Text('yap yap yap',style: TextStyle(color: grayText ,fontSize: 10)),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow:[ BoxShadow(color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: Offset(0, 8))
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildLabel(label: 'EMAIL'),
              BuildTextField(hint: 'nigga@mail.com', icon: Icons.mail, controller: emailController),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                BuildLabel(label: 'PASSWORD'),
                TextButton(
                    onPressed:(){},
                    child:Text(
                      'forgot password?',
                      style: TextStyle(
                          fontSize:10,
                          color:primaryTeal,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ]),
              BuildTextField(
                hint: '********',
                icon: Icons.password,
                controller: passwordController,
                ispassword: true,
                obscurePassword: _obsecurePassword,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                  elevation: 3
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('log in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),SizedBox(width: 8),Icon(Icons.login,size: 20)],
                  ),
                ),
              ),
              SizedBox(height: 10)
            ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('dont have acc?'), SizedBox(width: 4), TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));}, child: Text('sign up'))],)

        ],
    ),
          )));
  }
}

