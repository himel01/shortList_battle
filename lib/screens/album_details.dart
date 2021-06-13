import 'dart:ui';

import 'package:battle_app/models/model_album.dart';
import 'package:battle_app/models/model_photo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final ModelAlbum album;
  final List<ModelPhoto> list;

  const Details({Key? key, required this.album, required this.list})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState(album, list);
}

class _DetailsState extends State<Details> {
  final ModelAlbum album;
  final List<ModelPhoto> list;
  List<ModelPhoto> albumList = [];

  _DetailsState(this.album, this.list);

  Future<Widget?> _showDialog(BuildContext c) async {
    //await Future.delayed(Duration(seconds: 1));
    return await showDialog<Widget>(
        context: c,
        //useRootNavigator: true,
        barrierDismissible: true,
        builder: (c) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              //content: Text("Are You Sure Want To Proceed?"),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              elevation: 24.0,
              content: Builder(
                builder: (c) {
                  return Container(
                    height: MediaQuery.of(c).size.width * 0.6,
                    width: MediaQuery.of(c).size.width,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          height: 150.0,
                          //pageSnapping : false,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                          //aspectRatio: 16/9,
                          viewportFraction: 0.85,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal),
                      itemCount: albumList.length,
                      itemBuilder: (BuildContext context, int itemIndex, r) {
                        return (albumList.isNotEmpty)
                            ? InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          albumList[itemIndex].thumbnailUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : CircularProgressIndicator();
                      },
                    ),
                  );
                },
              ),
              backgroundColor: Colors.white,
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(c, rootNavigator: true).pop();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      width: MediaQuery.of(c).size.width * 0.7,
                      height: MediaQuery.of(c).size.height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffbe9fdb)),
                      child: Center(
                          child: Text(
                        "Back",
                        style: TextStyle(
                          color: Color(0xff7300E6),
                          fontSize: MediaQuery.of(c).size.width * 0.04,
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.forEach((element) {
      if (element.albumId == album.id) {
        albumList.add(element);
      }
    });
    print(albumList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Aqemur Reza Himel"),
        ),
        body: GridView.count(
            primary: true,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: List.generate(albumList.length, (index) {
              return InkWell(
                onTap: (){
                  _showDialog(context);
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(albumList[index].thumbnailUrl))),
                ),
              );
            })));
  }
}
