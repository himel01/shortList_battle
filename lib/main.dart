// @dart=2.9
import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:battle_app/helper/database_helper.dart';
import 'package:battle_app/models/model_album.dart';
import 'package:battle_app/screens/album_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      home: AnimatedSplashScreen(
          duration: 8000,
          splash: Icons.home,
          nextScreen: MyHomePage(title: 'Aqemur Reza Himel'),
          splashTransition: SplashTransition.sizeTransition,
          animationDuration: Duration(milliseconds: 5000),
          backgroundColor: Colors.blue),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // FirebaseMessaging messaging;
  //bool splash = true;
  List<ModelPhoto> photos = [];

  //List<ModelPhoto> photosFromDb = [];
  List<ModelAlbum> albums = [];

  //List<ModelAlbum> albumsFromDb = [];

  List<ModelPhoto> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<ModelPhoto>((json) => ModelPhoto.fromJson(json)).toList();
  }

  Future<List<ModelPhoto>> fetchPhotos(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    setState(() {
      photos = parsePhotos(response.body);
    });
    // if(photos.isNotEmpty){
    //   photos.forEach((element) {
    //     DatabaseHelper.instance.insertPhoto(element);
    //   });
    // }
    //print(photos.length);
    return photos;
  }

  List<ModelAlbum> parseAlbums(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ModelAlbum>((json) => ModelAlbum.fromJson(json)).toList();
  }

  Future<List<ModelAlbum>> fetchAlbums(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    //print(response.statusCode);

    setState(() {
      albums = parseAlbums(response.body);
    });
    // if (albums.isNotEmpty) {
    //   albums.forEach((element) {
    //    // DatabaseHelper.instance.insertAlbum(element);
    //     DatabaseHelper.instance.insertAlbum({
    //       DatabaseHelper.instance.columnUserId: albums[0].userId.toString(),
    //       DatabaseHelper.instance.columnId: albums[0].id.toString(),
    //       DatabaseHelper.instance.columnTitle: albums[0].title
    //     });
    //   });
    // }
    return albums;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //messaging = FirebaseMessaging.instance;
    //messaging.getToken().then((value){
    // print(value);
    //});
    this.fetchAlbums(http.Client());
    this.fetchPhotos(http.Client());
    // DatabaseHelper.instance.retrieveAlbum().then((value) {

    //
    //   albumsFromDb=value;
    // });

    // Future.delayed(Duration(seconds: 10), () {
    //   setState(() {
    //     splash = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
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
                      border: Border.all(color: Colors.lightBlueAccent),
                      color: Colors.black38,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(albums[index].id.toString(),style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                        Container(
                          child: Text(albums[index].userId.toString(),),
                        ),
                        Container(
                          child: Text(albums[index].title,style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: albums.length),
        ));
  }
}
