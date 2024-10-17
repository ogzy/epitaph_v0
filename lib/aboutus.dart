import 'package:epitaph_v0/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildAvatar(context),
                        buildName(context),
                      ],
                    ),
                    buildBottomNotch(context),
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
        //padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * 0.33,
        decoration: BoxDecoration(
          //color: Colors.amber.shade300.withOpacity(0.5),
          image: DecorationImage(
            //fit: BoxFit.values[1],
            alignment: Alignment.topCenter,
            colorFilter: new ColorFilter.mode(
              Colors.amber.withOpacity(0.2),
              BlendMode.color,
            ),
            image: AssetImage(
              'assets/images/header.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*Text(
              'Thank you',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            /*Wrap(
              spacing: MediaQuery.of(context).size.width * 0.02,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ],
            ),*/
            //SizedBox(height: MediaQuery.of(context).size.height * 0.13),
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

  Widget buildName(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0,
            MediaQuery.of(context).size.width * 0.05, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Us:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "We exist to preserve the memories of loved ones, so that they can be remembered for generations to come.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Text(""),
            Text(
              "Thank you for sharing the stories and legacies that deserve to live on for generations to come.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            Text(""),
            Text(""),
            buildButton(context),
          ],
        ),
      );

  Widget buildButton(context) => Padding(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05,
            0, MediaQuery.of(context).size.width * 0.05, 0),
        child: Container(
          width: double.infinity,
          child: FloatingActionButton.extended(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(3)),
            label: Row(
              children: [
                Text(
                  'Share a Story',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 194, 149, 36),
            onPressed: () {
              launchUrlString('https://www.epitaphinnovation.com/shareastory');
            },
          ),
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