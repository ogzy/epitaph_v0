import 'package:epitaph_v0/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.network(
        "http://www.nevalan.site/demo/media/20220502_021640.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        videoPlayerController.setVolume(1);
        if (videoPlayerController.value.duration ==
            videoPlayerController.value.position) {}
        //setState(() {});
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return ThemeSwitchingArea(
      child: Text("data"),
    );*/

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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildAvatar(context),
                    buildWelcomeTitle(context),
                    buildVideoPlayer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    buildContent(context),
                    buildBottomNotch(context)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAvatar(BuildContext context) => Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * 0.33,
        decoration: BoxDecoration(
          //color: Colors.amber.shade300.withOpacity(0.5),
          image: DecorationImage(
            //fit: BoxFit.values[1],
            alignment: Alignment.topCenter,
            colorFilter: new ColorFilter.mode(
                Colors.amber.withOpacity(0.2), BlendMode.color),
            image: AssetImage(
              'assets/images/header.png',
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //SizedBox(height: MediaQuery.of(context).size.height * 0.11),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.25,
              child: ClipOval(
                child: Material(
                  child: Image.asset('assets/images/EI-Logo-3c-FC.png'),
                  color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.0),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildWelcomeTitle(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.05,
          MediaQuery.of(context).size.width * 0.0,
          MediaQuery.of(context).size.width * 0.05,
          MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome from the Director",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );

  Widget buildVideoPlayer(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06,
            0, MediaQuery.of(context).size.width * 0.06, 0),
        child: videoPlayerController.value.duration !=
                videoPlayerController.value.position
            ? AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController),
              )
            : Center(
                child: InkWell(
                  child: Icon(
                    videoPlayerController.value.isPlaying
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    color: Colors.black,
                    size: 60,
                  ),
                  onTap: () {
                    setState(() {
                      videoPlayerController.value.isPlaying
                          ? videoPlayerController.pause()
                          : videoPlayerController.play();
                      //if (videoPlayerController.value.isPlaying) _showController = false;
                    });
                  },
                ),
              ),
      );

  Widget buildContent(BuildContext context) => Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.05,
          MediaQuery.of(context).size.width * 0.05,
          MediaQuery.of(context).size.width * 0.05,
          MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fname Lname",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.062,
                  color: Colors.grey.shade700),
            ),
            Text(
              "Director of ND Veterans Cemetery",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.042,
                color: Colors.grey.shade600,
                //fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "Morbi ullamcorper consequat pulvinar. Nunc interdum faucibus tortor, id sagittis est ornare quis. Pellentesque porta ligula nunc, ut vulputate ligula fermentum ac. Fusce elementum maximus lorem sit amet efficitur.",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.037,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "Donec metus sapien, elementum vitae diam finibus, egestas vestibulum magna. Morbi aliquet ultrices lacus, vel maximus odio rutrum venenatis. Pellentesque tincidunt nunc et nunc elementum imperdiet. Maecenas ac nisi iaculis, tempus augue vitae, placerat tortor.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.037,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "Vivamus finibus libero id dui imperdiet, nec sodales erat vulputate. Fusce vulputate ante eu diam bibendum malesuada. Pellentesque quam turpis, mattis eget tempus eget, accumsan eget mi. Vestibulum vitae est augue. Donec congue aliquet erat sed ultrices.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.037,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );

  Widget buildBottomNotch(BuildContext context) => Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.none,
            alignment: Alignment.topCenter,
            image: AssetImage(
              'assets/icons/notch.png',
            ),
          ),
        ),
      );
}
