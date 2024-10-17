import 'package:epitaph_v0/map.dart';
import 'package:flutter/material.dart';
//import 'package:video_player/video_player.dart';
//import 'profile_page.dart';

class CustomPopup extends StatefulWidget {
  static CustomPopupState? of(BuildContext context) =>
      context.findAncestorStateOfType<CustomPopupState>();

  final Thomb thomb;

  CustomPopup({required Key key, required this.thomb}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomPopupState();
  }
}

class CustomPopupState extends State<CustomPopup> {
  //late Future<void> _initializeVideoPlayerFuture;
  //late VideoPlayerController controller;
  //IconData playerIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    /*controller = VideoPlayerController.asset(
      'assets/video/bike_acrobatics.mp4',
    );
    _initializeVideoPlayerFuture = controller.initialize();

    controller.setLooping(true);*/
  }

  @override
  Widget build(BuildContext context) {
    return _buildDialogContent(widget.thomb);
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  Container _buildDialogContent(Thomb thomb) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(5.0),
      width: 120.0,
      height: 194.16,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30.0),
        color: Color.fromARGB(255, 2, 39, 119).withOpacity(0.8),
      ),
      child: Column(
        children: <Widget>[
          //_buildVideoContainer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              _buildNameAndLocation(thomb),
            ],
          ),
          Row(
            children: [
              /*Text(
                  'Korean veteran 1950. Father of 3. Born in Fargo and served in several places including...',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.50)*/
            ],
          ),
          Row(children: []),
        ],
      ),
    );
  }

  /*Widget _buildVideoContainer() {
    return Container(
      color: Colors.white,
      width: 172.0,
      height: 172.0,
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? VideoPlayer(controller)
                  : Center(child: CircularProgressIndicator());
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                  playerIcon = Icons.play_arrow;
                } else {
                  controller.play();
                  playerIcon = Icons.pause;
                }
              });
            },
            child: Stack(
              children: <Widget>[
                Center(
                  child:
                      Image.asset('assets/images/ic_blurred_gray_circle.png'),
                ),
                Center(
                  child: Container(
                    child: Icon(
                      playerIcon,
                      color: Color.fromRGBO(34, 43, 47, 100),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }*/

  Container _buildAvatar() {
    return new Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0), //or 15.0
        child: Container(
          height: 60.0,
          width: 60.0,
          color: Color.fromARGB(255, 194, 191, 192),
          child: Container(
            child: new Image.asset("assets/images/avatar_1.jpeg"),
          ),
        ),
      ),
      /*child: CircleAvatar(
          backgroundImage: new NetworkImage("https://i.imgur.com/BoN9kdC.png"),
        ),
        width: 55.0,
        height: 55.0,
        padding: const EdgeInsets.all(2.0),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        )*/
    );
  }

  Expanded _buildNameAndLocation(Thomb thomb) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 3.0, top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(thomb.name + ' ' + thomb.surname,
                      textScaleFactor: 0.65,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12.0,
                          height: 1.4,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Row(
              children: [Text('', textScaleFactor: 0.35)],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Color.fromRGBO(102, 122, 133, 100),
                  size: 13.0,
                ),
                Text("Fargo",
                    textAlign: TextAlign.justify, textScaleFactor: 0.50),
                Expanded(
                  child:
                      Text('', textAlign: TextAlign.end, textScaleFactor: 0.65),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
