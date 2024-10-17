import 'package:epitaph_v0/main.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildAvatar(context),
                        buildName(context),
                      ],
                    ),
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
            fit: BoxFit.fitWidth,
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
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
            //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.1,
          0,
          MediaQuery.of(context).size.width * 0.1,
          0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "ND Veterans Cemetery",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "Dedicated to the men and women who have served this State and Nation with unequaled distinction and honor. The State of North Dakota, in tribute to the devotion shown by our veterans in defense of the ideals and values we hold so precious, honors them by providing a location where they may find eternal peace in a setting rich with military history and quiet dignity.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "The North Dakota Veteran's Cemetery was established by an act of the 1989 Legislative Assembly. The cemetery was opened in July 1992, and is operated by the Adjutant General of North Dakota. It is located 6.5 miles south of Mandan on Highway 1806 on a 70 acre tract of land in the southwest corner of Fort Abraham Lincoln State Park.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                //fontWeight: FontWeight.bold,
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
