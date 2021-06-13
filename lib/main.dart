// @dart=2.9
import 'dart:convert';
import 'package:battle_app/helper/database_helper.dart';
import 'package:battle_app/models/model_album.dart';
import 'package:battle_app/screens/album_details.dart';
import 'package:http/http.dart' as http;

import 'package:battle_app/models/model_photo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Aqemur Reza Himel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool splash= true;
  List<ModelPhoto> photos=[];
  List<ModelPhoto> photosFromDb=[];
  List<ModelAlbum> albums=[];
  List<ModelAlbum> albumsFromDb=[];

  List<ModelPhoto> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<ModelPhoto>((json) => ModelPhoto.fromJson(json)).toList();

    // PhotosList photosList = PhotosList.fromJson(parsed);
    // print(photosList.photos.length);
     //return photosList.photos;
  }

  Future<List<ModelPhoto>> fetchPhotos(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));


    setState(() {
     photos= parsePhotos(response.body);
    });
    // if(photos.isNotEmpty){
    //   photos.forEach((element) {
    //     DatabaseHelper.instance.insertPhoto(element);
    //   });
    // }
    print(photos.length);
    // Use the compute function to run parsePhotos in a separate isolate.
    return photos;
  }
  List<ModelAlbum> parseAlbums(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    //AlbumsList albumsList = AlbumsList.fromJson(parsed);
    return parsed.map<ModelAlbum>((json) => ModelAlbum.fromJson(json)).toList();
    //print(albumsList.albums.length);
    //return albumsList.albums;

   // return parsed.map<ModelAlbum>((json) => ModelAlbum.fromJson(json)).toList();
  }

  Future<List<ModelAlbum>> fetchAlbums(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    //print(response.statusCode);

    setState(() {
      albums=parseAlbums(response.body);
    });
   if(albums.isNotEmpty){
     DatabaseHelper.instance.insertAlbum(albums[0]);

      // albums.forEach((element) {
      //   DatabaseHelper.instance.insertAlbum(element);
      // });
    }
    print(albums.length);
    // Use the compute function to run parsePhotos in a separate isolate.
    return albums;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //DatabaseHelper.instance.database;
    this.fetchAlbums(http.Client());
    this.fetchPhotos(http.Client());
    Future.delayed(Duration(seconds: 10),(){
      setState(() {
        splash=false;
      });
    });
    //albumsFromDb=DatabaseHelper.instance.retrieveAlbum();
    //photosFromDb=DatabaseHelper.instance.retrievePhoto() as List<ModelPhoto>;
    // if(albumsFromDb.isEmpty){
    //   print("album empty");
    // }else{
    //   print("album full");
    // }
  }

  @override
  Widget build(BuildContext context) {

    return splash?Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child:
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome",style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
             //CircularProgressIndicator(),
            ],
          ),
        )

    ):Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:  Container(
        child: ListView.separated(itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: 'details'),
                      builder: (context) => Details(
                        album: albums[index],
                        list: photos,
                      )));
            },
            child: Container(

              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  Container(
                    child: Text(albums[index].id.toString()),
                  ),
                  Container(
                    child: Text(albums[index].userId.toString()),
                  ),
                  Container(
                    child: Text(albums[index].title),
                  ),
                ],
              ),
            ),
          );
        }, separatorBuilder: (BuildContext context,int index){
          return const Divider();
        }, itemCount: albums.length),
      )


    );
  }
}
