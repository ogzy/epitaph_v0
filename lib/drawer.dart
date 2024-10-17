import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String iconFileName, String routeName) {
  //var isSelected = routeName == currentRoute;

  return ListTile(
    contentPadding:
        EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.033),
    leading: IconButton(
      icon: Image.asset('assets/icons/' + iconFileName + '.png'),
      iconSize: 16,
      onPressed: () {},
    ),
    minLeadingWidth: 0,
    horizontalTitleGap: MediaQuery.of(context).size.width * 0.025,
    title: title,
    textColor: Colors.white,
    //selected: isSelected,
    onTap: () {
      //if (isSelected) {
      //Navigator.pop(context);
      //} else {
      Navigator.pushNamed(context, routeName);
      //}
    },
  );
}

Widget _buildMultiLevelItem(
    BuildContext context, Widget title, List routeName) {
  return ListTileTheme(
    textColor: Colors.white,
    contentPadding: EdgeInsets.all(0),
    minLeadingWidth: 0,
    horizontalTitleGap: MediaQuery.of(context).size.width * 0.015,
    child: ExpansionTile(
      initiallyExpanded: true,
      tilePadding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.033),
      childrenPadding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
      leading: IconButton(
        onPressed: () {},
        icon: Image.asset('assets/icons/locate.png'),
        iconSize: 16,
      ),
      title: title,
      textColor: Color.fromARGB(255, 194, 149, 36),
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      //subtitle: Text('Expanding tile subtitle'),
      children: <Widget>[
        ListTile(
          hoverColor: Color.fromARGB(255, 194, 149, 36),
          leading: Icon(Icons.directions, size: 16),
          iconColor: Color.fromARGB(255, 194, 149, 36),
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.013),
          minLeadingWidth: 0,
          horizontalTitleGap: MediaQuery.of(context).size.width * 0.015,
          title: Text(
            'LOCATE HEADSTONE',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeName[0]);
          },
        ),
        ListTile(
          hoverColor: Color.fromARGB(255, 194, 149, 36),
          leading: Icon(Icons.map, size: 16),
          iconColor: Color.fromARGB(255, 194, 149, 36),
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.013),
          minLeadingWidth: 0,
          horizontalTitleGap: MediaQuery.of(context).size.width * 0.015,
          title: Text(
            'EXPLORE MAP',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
          ),
          onTap: () {
            //Navigator.of(context).pop();
            Navigator.pushNamed(context, routeName[1]);
          },
        ),
        /*ListTile(
          leading: Icon(Icons.wc, size: 16),
          iconColor: Color.fromARGB(255, 194, 149, 36),
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.013),
          minLeadingWidth: 0,
          horizontalTitleGap: MediaQuery.of(context).size.width * 0.015,
          title: Text(
            'RESTROOM',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeName[2]);
          },
        ),
        ListTile(
          leading: Icon(Icons.local_parking, size: 16),
          iconColor: Color.fromARGB(255, 194, 149, 36),
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.013),
          minLeadingWidth: 0,
          horizontalTitleGap: MediaQuery.of(context).size.width * 0.015,
          title: Text(
            'PARKING',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeName[3]);
          },
        ),*/
      ],
    ),
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    backgroundColor: Color.fromARGB(255, 0, 19, 61).withOpacity(1.0),
    child: Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(
              0, 0, MediaQuery.of(context).size.height * 0.015, 0),
          children: <Widget>[
            Container(
              child: DrawerHeader(
                child: ClipOval(
                  child: Material(
                    child: Image.asset('assets/images/EI-Logo-3c-FC.png'),
                    color: Color.fromARGB(255, 0, 19, 61).withOpacity(1.0),
                  ),
                ),
              ),
              color: Color.fromARGB(255, 0, 19, 61).withOpacity(1.0),
            ),
            _buildMenuItem(
              context,
              Text(
                'ND VETERANS CEMETERY',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033),
              ),
              'history',
              'history',
            ),
            /*_buildMenuItem(
              context,
              Text(
                'WELCOME FROM DIRECTOR',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033),
              ),
              'welcome',
              'welcome',
            ),*/
            _buildMultiLevelItem(
              context,
              Text(
                'LOCATE',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033,
                    fontWeight: FontWeight.bold),
              ),
              //['headstone', 'exploremap', 'restroom', 'parking'],
              ['headstone', 'exploremap'],
            ),
            _buildMenuItem(
              context,
              TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033,
                    color: Color.fromARGB(255, 0, 19, 61),
                    backgroundColor: Color.fromARGB(255, 0, 19, 61),
                    decorationColor: Color.fromARGB(255, 0, 19, 61),
                  ),
                  iconColor: Color.fromARGB(255, 0, 19, 61),
                  shadowColor: Color.fromARGB(255, 0, 19, 61),
                  overlayColor: Color.fromARGB(255, 0, 19, 61),
                  foregroundColor: Colors.grey.shade300,
                  surfaceTintColor: Color.fromARGB(255, 0, 19, 61),
                  disabledIconColor: Color.fromARGB(255, 0, 19, 61),
                  disabledBackgroundColor: Color.fromARGB(255, 0, 19, 61),
                  disabledForegroundColor: Color.fromARGB(255, 0, 19, 61),
                  backgroundColor:
                      Color.fromARGB(255, 0, 19, 61).withOpacity(1.0),
                ),
                onPressed: () {
                  launchUrlString(
                      'https://www.epitaphinnovation.com/shareastory');
                },
                child: const Text('UPLOAD A STORY'),
              ),
              'story',
              'story',
            ),
            /*_buildMenuItem(
              context,
              Text(
                'DONATE',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033),
              ),
              'donate',
              'donate',
            ),*/
            _buildMenuItem(
              context,
              Text(
                'ABOUT US',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033),
              ),
              'aboutus',
              'aboutus',
            ),
          ],
          /*),
        Padding(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03,
              0, 0, MediaQuery.of(context).size.height * 0.04),
          //child: Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Wrap(
              children: [
                /*IconButton(
                  icon: Image.asset('assets/icons/FB.png'),
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset('assets/icons/IG.png'),
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset('assets/icons/TW.png'),
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  onPressed: () {},
                ),*/
              ],
            ),
          ),*/
        ),
        //),
        //SizedBox(height: MediaQuery.of(context).size.width * 0.2),
      ],
    ),
  );
}
