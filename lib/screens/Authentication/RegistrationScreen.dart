import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpleblogingapp/screens/Authentication/LoginScreen.dart';
import 'package:simpleblogingapp/screens/size_config.dart';


class RegistrationScreen extends StatefulWidget
{
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
{

  final formkey = new GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  Future<bool> registerUser(String email, String pass, String name, String url) async
  {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try
    {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);

      FirebaseUser user = result.user;

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = name;
      updateInfo.photoUrl = url;

      user.updateProfile(updateInfo);
      return true;
    }
    catch(e)
    {
      print("***************************");
      print(e);
      print("***************************");
      return false;
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
        title: Text('Registration'),
        automaticallyImplyLeading: false,
      ),

      body: LayoutBuilder(
        builder: (context, constraints)
        {
          return OrientationBuilder(
            builder: (context, orientation)
            {
              SizeConfigure().init(constraints, orientation);

              return Container(
                padding: EdgeInsets.only(left: 50,right: 50,top: 35),
                child: Center(
                  child: Form(
                    key: formkey,
                    child: ListView(

                      children: <Widget>[

                        Center(
                            child: Text('Registration',
                              style: TextStyle(fontSize: 5.4 * SizeConfigure.blockSizeVertical,
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
                                  borderSide: BorderSide(color: Colors.pink,width: 1)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              )
                          ),
                        ),

                        SizedBox(height: 1.66 * SizeConfigure.blockSizeVertical,),

                        TextFormField(
                          controller: _passController,
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

                        SizedBox(height: 1.66 * SizeConfigure.blockSizeVertical,),

                        TextFormField(
                          controller: _nameController,
                          validator: (value)
                          {
                            return value.isEmpty ? 'Name Required' : null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Name',
                              labelText: 'Name',
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

                        SizedBox(height: 1.66 * SizeConfigure.blockSizeVertical,),

                        TextFormField(
                          controller: _imageController,
                          validator: (value)
                          {
                            return value.isEmpty ? 'Image Required' : null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Image Url',
                              labelText: 'Image',
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
                            child: Text('Register',style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 2.99 * SizeConfigure.blockSizeVertical),),
                            color: Colors.pink,
                            textColor: Colors.white,
                            onPressed: () async
                            {

                              if(validateForm())
                              {
                                final email = _emailController.text.toString().trim();
                                final password = _passController.text.toString().trim();
                                final name = _nameController.text.toString().trim();
                                final url = _imageController.text.toString().trim();

                                bool result = await registerUser(email, password, name, url);

                                if(result)
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                                }
                                else
                                {
                                  print("*****************************");
                                  print("--------- Error ---------");
                                  print("*****************************");
                                }
                              }
                              else
                              {
                                print("*******************");
                                print('Form Has Some Problems ...');
                                print("*******************");
                              }

                            },
                          ),
                        ),

                        SizedBox(height: 4.2 * SizeConfigure.blockSizeVertical,),

                        Center(
                          child: GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                            },
                            child: Text('Already have an Account ?',style: TextStyle(color: Colors.red,
                                fontSize: 2.7 * SizeConfigure.blockSizeVertical),),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              );
            },

          );
        },

      )
    );
  }
}
