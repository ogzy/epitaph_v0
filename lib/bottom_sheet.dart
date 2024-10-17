import 'package:epitaph_v0/map.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class MyBottomSheet extends StatefulWidget {
  static MyBottomSheetState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyBottomSheetState>();

  final Thomb searchedThomb;
  final bool hasLocationInfo;
  final bool routeNotDrawn;
  final double distance;
  final String turnType;

  MyBottomSheet({
    //required Key key,
    required this.searchedThomb,
    required this.hasLocationInfo,
    required this.routeNotDrawn,
    required this.distance,
    required this.turnType,
  });

  @override
  State<StatefulWidget> createState() {
    return MyBottomSheetState();
  }
}

class MyBottomSheetState extends State<MyBottomSheet> {
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
    String strsurname = widget.searchedThomb.surname.toUpperCase();
    String strname = widget.searchedThomb.name.toUpperCase();
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.04,
            MediaQuery.of(context).size.width * 0.02,
            MediaQuery.of(context).size.height * 0.02),
        //decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        //alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Wrap(
                //  spacing: MediaQuery.of(context).size.width * 0.02,
                //  children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NAME",
                      style: TextStyle(
                        color: Color.fromARGB(255, 194, 149, 36),
                        fontSize: MediaQuery.of(context).size.width * 0.026,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      (strname + strsurname).isEmpty
                          ? 'No Data Currently'
                          : (strsurname + ', ' + strname),
                      //' ' +
                      //widget.searchedThomb.middlename.toUpperCase(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.036,
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                //Icon(Icons.account_circle, color: Colors.white),
                //  ],
                //),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  //decoration: BoxDecoration(border: Border.all()),
                  child: Wrap(
                    spacing: MediaQuery.of(context).size.width * 0.1,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SECTION",
                            style: TextStyle(
                                color: Color.fromARGB(255, 194, 149, 36),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.026,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            widget.searchedThomb.section == ''
                                ? ''
                                : widget.searchedThomb.section[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SPACE",
                            style: TextStyle(
                              color: Color.fromARGB(255, 194, 149, 36),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.026,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            widget.searchedThomb.section == ''
                                ? ''
                                : widget.searchedThomb.section
                                    .substring(
                                      1,
                                      widget.searchedThomb.section.length,
                                    )
                                    .toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  //spacing: MediaQuery.of(context).size.width * 0.0,
                  children: [
                    //Align(
                    //widthFactor: MediaQuery.of(context).size.width * 0.002,
                    //heightFactor: MediaQuery.of(context).size.height * 0.001,
                    //alignment: Alignment.bottomCenter,
                    /*child:  SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.04,
                child: */
                    FloatingActionButton.extended(
                      extendedPadding: EdgeInsets.zero,
                      heroTag: 'Profile_Button',
                      label: Row(
                        children: [
                          Text(
                            'VIEW PROFILE',
                            style: TextStyle(
                                color: Color.fromARGB(255, 194, 149, 36),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.026,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                      backgroundColor:
                          Color.fromARGB(255, 0, 19, 61).withOpacity(0.0),
                      foregroundColor: Colors.white,
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ProfilePage(
                              theThomb: widget.searchedThomb,
                              hasLocationInfo: widget.hasLocationInfo,
                              routeNotDrawn: widget.routeNotDrawn,
                            ),
                          ),
                        ),
                      },
                      //),
                    ),
                    //),
                    /*Icon(Icons.arrow_forward,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),*/
                    Visibility(
                      visible: widget.hasLocationInfo & widget.routeNotDrawn,
                      child: /*Align(
                  widthFactor: 1,
                  heightFactor: 1,
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 130,
                    height: 32,
                    child: */
                          FloatingActionButton.extended(
                        heroTag: 'Direction_Button',
                        label: Row(
                          children: [
                            Text(
                              'LOCATE HEADSTONE',
                              style: TextStyle(
                                color: Color.fromARGB(255, 194, 149, 36),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.026,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ],
                        ),
                        backgroundColor:
                            Color.fromARGB(255, 0, 19, 61).withOpacity(0.0),
                        foregroundColor: Colors.white,
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveLocationPage(
                                title: widget.searchedThomb.name +
                                    ' ' +
                                    widget.searchedThomb.surname,
                                searchedThomb: widget.searchedThomb,
                              ),
                            ),
                          ),
                        },
                      ),
                      //),
                      //),
                    ),
                    /*Visibility(
                  visible: true,
                  child: Icon(Icons.arrow_forward, color: Colors.white)),*/
                  ],
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  (widget.routeNotDrawn ? 0.0 : 0.2),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  //visible: widget.routeNotDrawn == false,
                  visible: false,
                  child: Wrap(
                    children: [
                      Icon(
                        Icons.directions_walk_outlined,
                        color: Color.fromARGB(255, 194, 149, 36),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 194, 149, 36),
                      )
                    ],
                  ),
                ),
                Text(''),
                /*Text(
                  //widget.distance.toString() +
                  widget.turnType,
                  style: TextStyle(
                      color: Color.fromARGB(255, 194, 149, 36),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),*/
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      (widget.routeNotDrawn ? 0.085 : 0.06),
                ),
                Align(
                  //widthFactor: 1,
                  //heightFactor: 1,
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: FloatingActionButton.extended(
                      heroTag: 'profileButton',
                      label: Row(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height * 0.025,
                          ),
                        ],
                      ),
                      backgroundColor: Color.fromARGB(255, 194, 149, 36),
                      foregroundColor: Colors.white,
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ProfilePage(
                              theThomb: widget.searchedThomb,
                              hasLocationInfo: widget.hasLocationInfo,
                              routeNotDrawn: widget.routeNotDrawn,
                            ),
                          ),
                        ),
                      },
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

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  /*Container _buildDialogContent(Thomb thomb) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(5.0),
      width: 120.0,
      height: 194.16,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30.0),
        color: Color.fromARGB(255, 20, 39, 119).withOpacity(0.8),
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
  }*/

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

  /*Container _buildAvatar() {
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
  }*/

  /*Expanded _buildNameAndLocation(Thomb thomb) {
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
  }*/
}
