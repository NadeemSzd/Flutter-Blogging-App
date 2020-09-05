import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MoreOperations extends StatefulWidget {
  @override
  _MoreOperationsState createState() => _MoreOperationsState();
}

class _MoreOperationsState extends State<MoreOperations>
{


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text('More Operations'),
      ),

      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(5, (index)
        {
          return Container(
            color: Colors.pink,
          );
        }),
      ),

    );
  }

  static Future<int> getTotalPosts() async
  {
    var users = [];

    final response = await FirebaseDatabase.instance.reference().child("Updated Posts").once().then((DataSnapshot dataSnapShot)
    {
      var keys = dataSnapShot.key;

      print(keys.toString());

      /*response.key.forEach((v) => users.add(v));

      for(var user in users)
      {
        print(user.toString());
        print('*********************************');
        print("Total Posts "+ users.length.toString());
        print('*********************************');
      }*/

    });
    return users.length;
  }

}

