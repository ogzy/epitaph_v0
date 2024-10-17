import 'package:epitaph_v0/main.dart';
import 'package:epitaph_v0/map.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key,
      required this.theThomb,
      required this.hasLocationInfo,
      required this.routeNotDrawn})
      : super(key: key);
  final Thomb theThomb;
  final bool hasLocationInfo;
  final bool routeNotDrawn;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool imageExists = false;
  late VideoPlayerController videoPlayerController0;
  late VideoPlayerController videoPlayerController1;
  String url0 = "";
  String url1 = "";
  var urls = [];
  var videoPlayerControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.theThomb.images.isNotEmpty) {
      imageExists = true;
    }
    //var urls = [];
    //var videoPlayerControllers = [];
    for (var i = 0; i < widget.theThomb.videos.length; i++) {
      urls.add(widget.theThomb.videos[i]);
      videoPlayerControllers
          .add(VideoPlayerController.network(urls[i] == "" ? "asd" : urls[i])
            ..initialize().then((_) {
              videoPlayerControllers[i].setVolume(1);
            }));
    }
    if (widget.theThomb.videos.isNotEmpty) {
      url0 = widget.theThomb.videos[0];
    }
    if (widget.theThomb.videos.length > 1) {
      url1 = widget.theThomb.videos[1];
    }
    videoPlayerController0 =
        VideoPlayerController.network(url0 == "" ? "asd" : url0)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            videoPlayerController0.setVolume(1);
            //setState(() {});
          });

    videoPlayerController1 =
        VideoPlayerController.network(url1 == "" ? "012" : url1)
          ..initialize().then((_) {
            videoPlayerController1.setVolume(1);
            //  setState(() {});
          });
  }

  @override
  void dispose() {
    videoPlayerController0.dispose();
    videoPlayerController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return ThemeSwitchingArea(
      child: Text("data"),
    );*/
    String strsurname = widget.theThomb.surname.toUpperCase().isEmpty
        ? 'NO-SURNAME'
        : widget.theThomb.surname.toUpperCase();
    String strname = widget.theThomb.name.toUpperCase().isEmpty
        ? 'NO-NAME'
        : widget.theThomb.name.toUpperCase();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 19, 61),
        title: Text(
          'Mandan, ND - Veterans Cemetery',
          style: TextStyle(
            color: Color.fromARGB(255, 194, 149, 36),
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * 0.0158,
          ),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.yellow.shade800,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchVeteranForm(
                          title: 'ND Veterans Cemetery',
                        )),
              );
            },
            icon: Icon(
              Icons.home,
              color: Colors.yellow.shade800,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //physics: BouncingScrollPhysics(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAvatarAndMedals(widget.theThomb),
            buildName(widget.theThomb),
            buildRank(widget.theThomb),
            buildDuty(widget.theThomb),
            buildBranch(widget.theThomb),
            buildAbout(widget.theThomb),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            buildImages(widget.theThomb),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ListView.builder(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, int index) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildVideoPlayer(index),
                      /*Icon(
                    Icons.image,
                    color: Colors.red,
                    size: 50,
                  ),*/
                    ],
                  ),
                );
              },
              itemCount: videoPlayerControllers.length,
            ),
            /*buildVideoPlayer0(widget.theThomb),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            buildVideoPlayer1(widget.theThomb),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),*/
            buildGetDirections(widget.theThomb),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01)
          ],
        ),
      ),
    );
  }

  Widget buildAvatarAndMedals(Thomb theThomb) => Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.height * 0.025, 0, 0),
        alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height * 0.38,
        decoration: BoxDecoration(
          //color: Colors.amber.shade300.withOpacity(0.5),
          image: DecorationImage(
            //fit: BoxFit.values[1],
            alignment: Alignment.topLeft,
            colorFilter: new ColorFilter.mode(
                Colors.amber.withOpacity(0.7), BlendMode.color),
            image: AssetImage(
              'assets/images/header.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: MediaQuery.of(context).size.width * 0.02,
              children: [
                /*Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),*/
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.white),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: theThomb.images.length > 1 &&
                            theThomb.images.first.contains('profile')
                        ? Image.network(
                            theThomb.images.first,
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/icons/blankProfile.png',
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                buildMedals(widget.theThomb),
              ],
            ),
          ],
        ),
      );

  Widget buildName(Thomb theThomb) => Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0.05, 0, 0),
        child: Text(
          //Eğer göbek adı boşsa sadece ad soyadı yazdır
          theThomb.middlename == ''
              ? theThomb.name + ' ' + theThomb.surname
              : theThomb.name +
                  ' ' +
                  theThomb.middlename +
                  ' ' +
                  theThomb.surname,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.grey.shade600,
          ),
        ),
      );

  Widget buildRank(Thomb theThomb) => Visibility(
        visible: theThomb.rank.isNotEmpty,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
          child: Text(theThomb.rank.trim(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold)),
        ),
      );

  Widget buildDuty(Thomb theThomb) => Visibility(
        visible: theThomb.duty.isNotEmpty,
        child: Container(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.width * 0.05, 0, 0),
          child: Column(
            children: [
              Text(theThomb.duty,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic))
            ],
          ),
        ),
      );

  Widget buildBranch(Thomb theThomb) => Visibility(
        visible: theThomb.branch.isNotEmpty,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
          child: Column(
            children: [
              Text(theThomb.branch,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic))
            ],
          ),
        ),
      );

  Widget buildAbout(Thomb theThomb) => Visibility(
        visible: true, //TO DO: theThomb.description.isNotEmpty
        child: Container(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.width * 0.05, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.theThomb.description,
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      );

  Wrap buildMedals(Thomb theThomb) {
    //var medals = theThomb.medals.split(',');
    //print(theThomb.medals.toString().contains('AFC'));
    //theThomb.medals.toString().contains('AFC')
    //    ? print(medals)
    //    : print('NOOOOO AFC');
    return Wrap(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.06),
        theThomb.medals.contains('AFC')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/medal_afc.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
        theThomb.medals.contains('AFC')
            ? SizedBox(width: MediaQuery.of(context).size.width * 0.03)
            : Text(''),
        theThomb.medals.contains('DSC')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/medal_dsc.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
        theThomb.medals.contains('DSC')
            ? SizedBox(width: MediaQuery.of(context).size.width * 0.03)
            : Text(''),
        theThomb.medals.contains('Navy Cross')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/medal_navycross.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
        theThomb.medals.contains('Navy Cross')
            ? SizedBox(width: MediaQuery.of(context).size.width * 0.03)
            : Text(''),
        theThomb.medals.contains('Silver Star')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/medal_silverstar.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
        theThomb.medals.contains('Silver Star')
            ? SizedBox(width: MediaQuery.of(context).size.width * 0.03)
            : Text(''),
        theThomb.medals.contains('MAF')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/MOH-AF-sm133.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
        theThomb.medals.contains('MAF')
            ? SizedBox(width: MediaQuery.of(context).size.width * 0.03)
            : Text(''),
        theThomb.medals.contains('M Army')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/MOH-Army-sm133.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
        theThomb.medals.contains('M Army')
            ? SizedBox(width: MediaQuery.of(context).size.width * 0.03)
            : Text(''),
        theThomb.medals.contains('M Navy')
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/icons/MOH-Navy-sm133.gif',
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.12,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Text(''),
      ],
    );
  }

  Widget buildImages(Thomb theThomb) => Visibility(
        visible: imageExists,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Text(
              'Images',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                color: Colors.grey.shade600,
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, int index) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(theThomb.images[index]),
                      /*Icon(
                    Icons.image,
                    color: Colors.red,
                    size: 50,
                  ),*/
                    ],
                  ),
                );
              },
              itemCount: theThomb.images.length,
            ),
          ],
        ),
      );
  Widget buildVideoPlayer(int i) => Visibility(
        visible: urls[i].isNotEmpty,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                color: Colors.grey.shade600,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.05,
                  0),
              child: Center(
                child: videoPlayerControllers[i].value.isInitialized
                    ? AspectRatio(
                        aspectRatio:
                            videoPlayerControllers[i].value.aspectRatio,
                        child: VideoPlayer(videoPlayerControllers[i]),
                      )
                    : Container(),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.05,
                  0),
              width: double.infinity,
              child: FloatingActionButton.extended(
                heroTag: 'video',
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                label: Row(
                  children: [
                    Text(
                      'HERE IS THE STORY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      videoPlayerControllers[i].value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 194, 149, 36),
                onPressed: () {
                  setState(() {
                    videoPlayerControllers[i].value.isPlaying
                        ? videoPlayerControllers[i].pause()
                        : videoPlayerControllers[i].play();
                  });
                },
              ),
            ),
          ],
        ),
      );

  /*Widget buildVideoPlayer0(Thomb theThomb) => Visibility(
        visible: url0.isNotEmpty,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Video',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                color: Colors.grey.shade600,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.05,
                  0),
              child: Center(
                child: videoPlayerController0.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: videoPlayerController0.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController0),
                      )
                    : Container(),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.05,
                  0),
              width: double.infinity,
              child: FloatingActionButton.extended(
                heroTag: 'video',
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                label: Row(
                  children: [
                    Text(
                      'HEAR-VIEW THE STORY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      videoPlayerController0.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 194, 149, 36),
                onPressed: () {
                  setState(() {
                    videoPlayerController0.value.isPlaying
                        ? videoPlayerController0.pause()
                        : videoPlayerController0.play();
                  });
                },
              ),
            ),
          ],
        ),
      );*/

  /*Widget buildVideoPlayer1(Thomb theThomb) => Visibility(
        visible: url1.isNotEmpty,
        child: Column(
          children: [
            Center(
              child: videoPlayerController1.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoPlayerController1.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController1),
                    )
                  : Container(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  0,
                  MediaQuery.of(context).size.width * 0.05,
                  0),
              width: double.infinity,
              child: FloatingActionButton.extended(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                heroTag: 'audio',
                label: Row(
                  children: [
                    Text(
                      'VIEW-HEAR THE STORY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      videoPlayerController1.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 194, 149, 36),
                onPressed: () {
                  setState(() {
                    videoPlayerController1.value.isPlaying
                        ? videoPlayerController1.pause()
                        : videoPlayerController1.play();
                  });
                },
              ),
            ),
          ],
        ),
      );*/

  Widget buildGetDirections(Thomb theThomb) {
    return Visibility(
      visible: widget.hasLocationInfo &
          widget
              .routeNotDrawn, //Konum bilgisi yoksa veya güzergah zaten çizilmişse güzergah çizme tuşunu gösterme.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(),
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                0,
                MediaQuery.of(context).size.width * 0.05,
                0),
            width: double.infinity,
            child: FloatingActionButton.extended(
              heroTag: 'getDirections',
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              label: Row(
                children: [
                  Text(
                    'LOCATE HEADSTONE   ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Icon(
                    Icons.map,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
              backgroundColor: Color.fromARGB(255, 194, 149, 36),
              //foregroundColor: Colors.white,
              onPressed: () => {
                if (widget
                    .routeNotDrawn) //Aranan mefta için hazırda bir güzergah çizili değilse harita sayfasını aç ve güzergah çizdir.
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveLocationPage(
                          title: 'Title',
                          searchedThomb: theThomb,
                        ),
                      ),
                    ),
                  }
                else //Aranan mefta için zaten bir güzergah çiziliyse doğrudan harita sayfasına dön. Tekrar güzergah çizdirme.
                  {
                    Navigator.of(context).pop(),
                  }
              },
            ),
          ),
        ],
      ),
    );
  }
}
