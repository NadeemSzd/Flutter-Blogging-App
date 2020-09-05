import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simpleblogingapp/posts.dart';
import 'package:simpleblogingapp/screens/Authentication/LoginScreen.dart';
import 'package:simpleblogingapp/screens/liked_post.dart';
import 'package:simpleblogingapp/screens/size_config.dart';
import 'package:simpleblogingapp/screens/ulpoad_post.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{

  List<Posts> postsList = [];
  List<String> allKeys = [];

  bool isLiked = false;
  bool clicked = false;
  int updateIndex = 0;

  DatabaseReference postReference;

  getData()
  {
    postReference = FirebaseDatabase.instance.reference().child("Posts");

    postReference.once().then((DataSnapshot snapshot)
    {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;

      postsList.clear();
      allKeys.clear();

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
        //print(keys.toString());
        allKeys.add(keys);
        postsList.add(posts);
      }
    });
  }

  @override
  void initState()
  {
    super.initState();

    getData();
  }


  @override
  Widget build(BuildContext context)
  {

    return Scaffold(

      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: false
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            IconButton(
              icon: Icon(Icons.directions_car),
              color: Colors.white,
              iconSize: 28,
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
              },
            ),

            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.white,
              iconSize: 28,
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>LikedPost()));
              },
            ),

            IconButton(
              icon: Icon(Icons.add_a_photo),
              color: Colors.white,
              iconSize: 28,
              onPressed: ()
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
                      return UploadPost();
                    }
                ));
              },
            ),

          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context,constraints)
        {
          return OrientationBuilder(
            builder: (context,orientation)
            {
              SizeConfigure().init(constraints, orientation);
              return Container(
                color: Colors.pink[300],
                child: postsList.length==0

                    ? Center(child: Text('No Blog Posts',style: TextStyle(color: Colors.white,
                             fontSize: 3.85 * SizeConfigure.blockSizeVertical),))

                    : orientation == Orientation.landscape
                        ? GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(postsList.length, (index)
                           {
                            return PostsUI(postsList[index].image, postsList[index].description,
                              postsList[index].date, postsList[index].time,postsList[index].username,isLiked,index);
                           }),
                          )

                        : ListView.builder(
                           itemCount: postsList.length,
                           itemBuilder: (_,index)
                            {
                             if(clicked==false || updateIndex != index)
                              {
                                isLiked = postsList[index].isFavorite;
                              }

                             return PostsUI(postsList[index].image, postsList[index].description,
                                    postsList[index].date, postsList[index].time,postsList[index].username,isLiked,index);
                            },
                          ),
              );
            },
          );
        },

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Flexible(
              flex: 1,
              child: Row(
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
                              size: 6.55 * SizeConfigure.blockSizeVertical,
                              color: Colors.purpleAccent[700],)
                              ,backgroundColor: Colors.white,),

                            SizedBox(width: 3,),

                            Text(userName == null ? 'UserName' : userName ,
                              style: TextStyle(color: Colors.purpleAccent[700],
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
                            fontSize: 2 * SizeConfigure.textMultiplier),),

                        Text(time,style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,
                            fontSize: 2 * SizeConfigure.textMultiplier),),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10,),

            Flexible(
              flex: 5,
              child: Image.network(image,fit: BoxFit.fill,height: 63 * SizeConfigure.blockSizeVertical,
                width: MediaQuery.of(context).size.width,),
            ),

            Flexible(
              flex: 1,
              child: Row(
                crossAxisAlignment:  CrossAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5,right: 10),
                        child: Text(description,style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 3.1 *SizeConfigure.textMultiplier , color: Colors.pink),)
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(right: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          IconButton(
                            icon: Icon(isFavorite == false ? Icons.favorite_border : Icons.favorite ,
                              size: 3.7 * SizeConfigure.textMultiplier, color: Colors.pink,),
                            onPressed: ()
                            {
                              setState(()
                              {
                                if(isFavorite == false)
                                  {
                                    isLiked = true;
                                    postReference.child(allKeys[index]).update({'isFavorite' : true});
                                  }
                                else if(isFavorite == true)
                                  {
                                    isLiked = false;
                                    postReference.child(allKeys[index]).update({'isFavorite' : false});
                                  }
                                updateIndex = index;
                                getData();
                                clicked = true;
                              });
                              //clicked = false;
                              //print('Root Node name : ' + allKeys[index].toString());
                            },
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.share,color: Colors.pink,size: 3.7 * SizeConfigure.textMultiplier,),
                          SizedBox(width: 20,),
                          Icon(Icons.comment,color: Colors.pink,size: 3.7 * SizeConfigure.textMultiplier,),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget PostsUI_LandScape(String image,String description,String date,String time,String userName,bool isFavorite,int index)
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
                            size: 6.55 * SizeConfigure.blockSizeVertical,
                            color: Colors.purpleAccent[700],)
                            ,backgroundColor: Colors.white,),

                          SizedBox(width: 3,),

                          Text(userName == null ? 'UserName' : userName ,
                            style: TextStyle(color: Colors.purpleAccent[700],
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
              width: MediaQuery.of(context).size.width,),

            Row(
              crossAxisAlignment:  CrossAxisAlignment.center,
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 5,right: 10),
                      child: Text(description,style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 3.1 *SizeConfigure.textMultiplier , color: Colors.pink),)
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                        IconButton(
                          icon: Icon(isFavorite == false ? Icons.favorite_border : Icons.favorite ,
                            size: 3.7 * SizeConfigure.textMultiplier, color: Colors.pink,),
                          onPressed: ()
                          {
                            setState(()
                            {
                              if(isFavorite == false)
                              {
                                isLiked = true;
                                postReference.child(allKeys[index]).update({'isFavorite' : true});
                              }
                              else if(isFavorite == true)
                              {
                                isLiked = false;
                                postReference.child(allKeys[index]).update({'isFavorite' : false});
                              }
                              updateIndex = index;
                              getData();
                              clicked = true;
                            });
                            //clicked = false;
                            //print('Root Node name : ' + allKeys[index].toString());
                          },
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.share,color: Colors.pink,size: 3.7 * SizeConfigure.textMultiplier,),
                        SizedBox(width: 20,),
                        Icon(Icons.comment,color: Colors.pink,size: 3.7 * SizeConfigure.textMultiplier,),

                      ],
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

}
