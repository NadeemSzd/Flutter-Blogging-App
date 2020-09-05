import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simpleblogingapp/screens/Authentication/LoginScreen.dart';
import 'package:simpleblogingapp/screens/home.dart';
import 'package:simpleblogingapp/screens/size_config.dart';


class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost>
{

  File sampleImage;
  String _myValue;
  String imageUrl;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(title: Text('Upload Post'), centerTitle: true,),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: ()
        {
          getImage();
        },
      ),

      body: Center(
        child: sampleImage == null ? Text('No Image Selected') : enableUpload(),
      )

    );
  }

  void getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });

  }

  bool validateAndSave()
  {
    final form = formKey.currentState;

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

  void uploadStatusImage() async
  {
    if(validateAndSave())
      {
        final StorageReference reference = FirebaseStorage.instance.ref().child('Post Images');

        var timeKey = DateTime.now();
        final StorageUploadTask uploadTask = reference.child(timeKey.toString()+"jpg").putFile(sampleImage);

        imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        print('Image Url --------> '+imageUrl);

        saveToFirebaseDatabase(imageUrl);

        Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));
      }
  }

  void saveToFirebaseDatabase(String imageUrl)
  {
    var dbDateTime = DateTime.now();

    var date = DateFormat('MMM d, yyyy').format(dbDateTime);
    var time = DateFormat('EEEE, hh: mm aaa').format(dbDateTime);
    var profilerUser = LoginScreen.userName;

    var dataModel = {
      'image' : imageUrl,
      'descripton' : _myValue,
      'date' : date,
      'time' : time,
      'isFavorite' : false,
      'userName' : profilerUser
    };

    DatabaseReference reference = FirebaseDatabase.instance.reference();

    reference.child("Posts").push().set(dataModel);
  }

  enableUpload()
  {
    return Container(
      margin: EdgeInsets.all(5),
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
           
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.file(sampleImage,height: 63 * SizeConfigure.blockSizeVertical,
                width:  97.5 * SizeConfigure.blockSizeHorizontal,fit: BoxFit.fill,)),

            SizedBox(height: 20,),

            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value)
              {
                return value.isEmpty ? 'Description required':null;
              },
              onSaved: (value)
              {
                return _myValue = value;
              },
            ),

            SizedBox(height: 30,),

            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: RaisedButton(
                color: Colors.pink,
                textColor: Colors.white,
                onPressed: uploadStatusImage,
                child: Text('Add New Post'),
              ),
            ),

          ],
        ),
      ),
    );
  }


}
