import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simpleblogingapp/screens/size_config.dart';

import '../posts.dart';


class LikedPost extends StatefulWidget {
  @override
  _LikedPostState createState() => _LikedPostState();
}

class _LikedPostState extends State<LikedPost>
{

  List<Posts> postsList = [];
  List<String> allKeys = [];

  DatabaseReference postReference;

  @override
  void initState()
  {
    super.initState();

    postReference = FirebaseDatabase.instance.reference().child("Posts");

    postReference.once().then((DataSnapshot snapshot)
    {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;

      postsList.clear();

      for(var keys in KEYS)
      {

        Posts posts = new Posts(
            DATA[keys]['image'],
            DATA[keys]['descripton'],
            DATA[keys]['date'],
            DATA[keys]['time'],
            DATA[keys]['isFavorite'],
            DATA[keys]['userName']
        );

        if(posts.isFavorite == true)
          {
            postsList.add(posts);
          }
      }
    });

  }


  @override
  Widget build(BuildContext context)
  {

    return Scaffold(

      appBar: AppBar(
          title: Text('Favorite Posts'),
      ),

      body: Container(
        color: Colors.pink[300],
        child: postsList.length==0
            ? Center(child: Text('No Favorite Post',style: TextStyle(color: Colors.white,fontSize: 20),))
            : ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_,index)
          {
            return PostsUI(postsList[index].image, postsList[index].description,
                postsList[index].date, postsList[index].time,postsList[index].username,postsList[index].isFavorite,index);
          },
        ),
      ),

    );
  }


  Widget PostsUI(String image,String description,String date,String time,String userName,bool isFavorite,int index)
  {

    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 15,right: 15,top: 20),
      child: Container(
        padding: EdgeInsets.only(top:8,left: 8,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Row(
              children: <Widget>
              [

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Row(
                        children: <Widget>
                        [
                          CircleAvatar(child: Icon(Icons.account_circle,
                            size: 6.55 * SizeConfigure.blockSizeVertical,color: Colors.purpleAccent[700],),
                            backgroundColor: Colors.white,),
                          SizedBox(width: 3,),
                          Text(userName == null ? 'UserName' : userName ,style: TextStyle(color: Colors.purpleAccent[700],
                              fontWeight: FontWeight.bold,fontSize: 3.1 * SizeConfigure.textMultiplier),),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>
                    [
                      Text(date,style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,
                          fontSize: 2.55 * SizeConfigure.textMultiplier),),
                      Text(time,style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,
                          fontSize: 2.55 * SizeConfigure.textMultiplier),),
                    ],
                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Image.network(image,fit: BoxFit.fill,height: 63 * SizeConfigure.blockSizeVertical,
              width: 97.5 * SizeConfigure.blockSizeHorizontal,),

            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 5,right: 10,top: 10,bottom: 10),
                child: Text(description,style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 3.1 *SizeConfigure.textMultiplier,color: Colors.pink),)
            ),


          ],
        ),
      ),
    );
  }

}
