import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simpleblogingapp/screens/Authentication/RegistrationScreen.dart';
import 'package:simpleblogingapp/screens/home.dart';

import '../size_config.dart';


class LoginScreen extends StatefulWidget {

  static var userName;
  setUserName(String user)
  {
    userName = user;
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  final formkey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  Future<FirebaseUser> login(String email, String password) async
  {
    FirebaseAuth _auth = FirebaseAuth.instance;

    LoginScreen loginScreen = new LoginScreen();

   try
   {
     AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user; // currently logged-in user

     loginScreen.setUserName(user.displayName);

     return user;
   }
   catch(e)
   {
    print("********* Logged In Exception ************");
    print(e);
    print("*************************");
    return null;
   }

  }

  bool validateForm()
  {
    final form = formkey.currentState;

    if(form.validate())
      {
        form.save();
        return true;
      }
    else
      {
        return false;
      }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),

        body: Container(
          padding: EdgeInsets.only(left: 50,right: 50,top: 80),
          child: Center(
            child: Form(
              key: formkey,
              child: ListView(

                children: <Widget>[

                  Center(
                      child: Text('Login',style: TextStyle(fontSize: 5.4 * SizeConfigure.blockSizeVertical,
                          fontWeight: FontWeight.bold,color: Colors.pink),)),

                  SizedBox(height: 8 * SizeConfigure.blockSizeVertical,),

                  TextFormField(
                    controller: _emailController,
                    validator: (value)
                    {
                      return value.isEmpty ? 'Email Required' : null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 2.99 * SizeConfigure.blockSizeVertical),
                      contentPadding: EdgeInsets.symmetric(horizontal: 2.5 * SizeConfigure.blockSizeVertical,
                            vertical: 2.5 * SizeConfigure.blockSizeVertical),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(width: 1,color: Colors.pink)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.purpleAccent,width: 1)
                      )
                    ),
                  ),

                  SizedBox(height: 1.66 * SizeConfigure.blockSizeVertical,),

                  TextFormField(
                    controller: _passwordController,
                    validator: (value)
                    {
                      return value.isEmpty ? 'Password Required' : null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 2.99 * SizeConfigure.blockSizeVertical),
                      contentPadding: EdgeInsets.symmetric(horizontal: 2.5 * SizeConfigure.blockSizeVertical,
                            vertical: 2.5 * SizeConfigure.blockSizeVertical),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.pink,width: 1)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7)
                      )
                    ),
                  ),

                  SizedBox(height: 8.3 * SizeConfigure.blockSizeVertical,),

                  ButtonTheme(
                    height: 7.5 * SizeConfigure.blockSizeVertical,
                    child: RaisedButton(
                      child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 2.99 * SizeConfigure.blockSizeVertical),),
                      color: Colors.pink,
                      textColor: Colors.white,
                      onPressed: () async
                      {
                        if(validateForm())
                          {
                            final email = _emailController.text.toString().trim();
                            final password = _passwordController.text.toString().trim();

                            FirebaseUser user = await login(email, password);

                            if(user != null)
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));
                            }
                            else
                            {
                              print("*********** Error ************");
                            }
                          }
                        else
                          {
                            print("********************");
                            print('Error in Login Process');
                            print("********************");
                          }
                      },
                    ),
                  ),

                  SizedBox(height: 4.2 * SizeConfigure.blockSizeVertical,),

                  Center(
                    child: GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>RegistrationScreen()));
                      },
                      child: Text('Dont have any account ?',style: TextStyle(color: Colors.red,
                          fontSize: 2.7 * SizeConfigure.blockSizeVertical),),
                    ),
                  )
                ],
              ),
            ),
          ),
        )

    );
  }
}
