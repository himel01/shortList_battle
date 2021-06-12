import 'dart:convert';
import 'package:battle_app/models/model_album.dart';
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
  MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ModelPhoto> photos=[];
  List<ModelAlbum> albums=[];

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
    print(response.statusCode);

    setState(() {
      albums=parseAlbums(response.body);
    });
    print(albums.length);
    // Use the compute function to run parsePhotos in a separate isolate.
    return albums;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchAlbums(http.Client());
    this.fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:  Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           albums.isNotEmpty? Text(
              albums[0].title,
            ):CircularProgressIndicator(),
            photos.isNotEmpty?Text(
              photos[0].title,
            ):CircularProgressIndicator(),

          ],
        ),


    );
  }
}
