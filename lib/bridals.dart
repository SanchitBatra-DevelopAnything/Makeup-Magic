import 'package:flutter/material.dart';
import './main_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './Utility.dart';
import 'DBHelper.dart';
import 'photo.dart';
import 'dart:async';



class Bridals extends StatefulWidget {
  @override
  _BridalsState createState() => _BridalsState();
}

class _BridalsState extends State<Bridals> {
  
  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  List<Photo> images;

  @override
  void initState() {
    // TODO: implement initState
    images = [];
    dbHelper = DBHelper();
    refreshImages();
    super.initState();
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return InkWell(
              onTap: (){
                Navigator.of(context).pushNamed('/open-image', arguments:photo.photoName); 
              },
              child: Container(
                height: 25,
                width: 25,
                child: GridTile(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Utility.imageFromBase64String(photo.photoName),
                ),
            ),
              ),
          );
        }).toList(),
      ),
    );
  }

  refreshImages() {
    dbHelper.getPhotosOfBrides().then((imgs){
      setState(() {
        images.clear();
        images.addAll(imgs);
      });   
    });
  }

  pickImageFromGallery()
  {
      showDialog(context: context , builder: (ctx)=>AlertDialog(title: Text('A reminder!'),content: Text('Please Upload Whatsapp Photos Only'),actions: <Widget>[
        FlatButton(child: Text('Okay'),onPressed: (){
          Navigator.of(context).pop();
        },)
      ],),).then((_){
        ImagePicker.pickImage(source: ImageSource.gallery , maxHeight: 1024 , maxWidth: 768).then((imgFile){
        String imgString = Utility.base64String(imgFile.readAsBytesSync());
        Photo photo = Photo(id: 0,photoName: imgString);
        dbHelper.saveInBride(photo);
        refreshImages();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Bridals Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImageFromGallery();
            },
          ),
          // IconButton(icon: Icon(Icons.delete),onPressed:() => dbHelper.clearDataOfBride().then((_){
          //   refreshImages();
          // }),),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            )
          ],
        ),
      ),
    );
  }
}