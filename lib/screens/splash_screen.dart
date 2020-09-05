import 'package:flutter/material.dart';
import 'package:simpleblogingapp/screens/home.dart';


class SplashScreen extends StatefulWidget
{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin
{

  Animation animation,animation1;
  AnimationController animationController;

  @override
  void initState()
  {
    super.initState();


    // Code to move next screen after some time
    Future.delayed(Duration(seconds: 5),()
    {
      Navigator.push(context, PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation,Widget child )
          {
            return SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),end: Offset.zero).animate(animation),
              child: child,
            );
          },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation)
          {
            return HomePage();
          }
      ));

    });

    animationController = AnimationController(vsync: this,duration: Duration(seconds: 2))
      ..addListener((){setState(() {});});

    animation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
        parent: animationController,curve: Curves.fastOutSlowIn));

    animation1 = Tween(begin: 1.0,end: 0.0).animate(CurvedAnimation(
        parent: animationController,curve: Curves.fastOutSlowIn));

    animationController.forward();
  }

  @override
  void dispose()
  {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.pink,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Transform(
                transform: Matrix4.translationValues(screenWidth * animation.value, 0.0, 0.0),
                child: ScaleTransition(
                  scale: animationController,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset('assets/images/logo.png',
                      height: 400,width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                  ),
                ),
              ),

             SizedBox(height: 50,),

             Transform(
               transform: Matrix4.translationValues(0.0, animation1.value * screenWidth, 0.0),
               child: ScaleTransition(
                 scale: animationController,
                 child: RotationTransition(
                   turns: animationController,
                   child: Text('Welcome to Blog App',
                       style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                 ),
               )
             ),

            ],
          ),
        ),
      ),

    );
  }
}
