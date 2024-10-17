import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'map.dart';
import 'bottom_sheet.dart';

// Define a custom Form widget.
class ListVeterans extends StatefulWidget {
  final List veteranlist;
  const ListVeterans({Key? key, required this.veteranlist}) : super(key: key);

  @override
  ListVeteransState createState() {
    return ListVeteransState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class ListVeteransState extends State<ListVeterans> {
  GlobalKey<State> key = new GlobalKey();
  late int selectedIndex = -1;
  bool showDirection = true;
  final _gKey = new GlobalKey<ScaffoldState>();
  Thomb theThomb = Thomb();
  PersistentBottomSheetController? bottomSheetController;

  void displayBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        theThomb.clear();
        theThomb.name = widget.veteranlist[0][selectedIndex]['firstname'];
        theThomb.middlename =
            widget.veteranlist[0][selectedIndex]['middle_initial'];
        theThomb.surname = widget.veteranlist[0][selectedIndex]['surname'];
        theThomb.rank = widget.veteranlist[0][selectedIndex]['military_rank'];
        theThomb.branch =
            widget.veteranlist[0][selectedIndex]['military_branch'];
        theThomb.duty = widget.veteranlist[0][selectedIndex]['tours_of_duty'];
        theThomb.medals =
            widget.veteranlist[0][selectedIndex]['medal_of_honor'];
        if (widget.veteranlist[0][selectedIndex]['section'] != null) {
          theThomb.section = widget.veteranlist[0][selectedIndex]['section'];
        }
        //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
        if (widget.veteranlist[0][selectedIndex]['latitude'] != null &&
            widget.veteranlist[0][selectedIndex]['longitude'] != null &&
            widget.veteranlist[0][selectedIndex]['latitude'] != "" &&
            widget.veteranlist[0][selectedIndex]['longitude'] != "" &&
            widget.veteranlist[0][selectedIndex]['latitude'] != 0 &&
            widget.veteranlist[0][selectedIndex]['longitude'] != 0) {
          showDirection = true;
          theThomb.coordinates = LatLng(
              double.parse(widget.veteranlist[0][selectedIndex]['latitude']
                  .replaceAll(',', '.')),
              double.parse(widget.veteranlist[0][selectedIndex]['longitude']
                  .replaceAll(',', '.')));
        } else {
          showDirection = false;
        }
        if (widget.veteranlist[0][selectedIndex]['description'] != null) {
          theThomb.description =
              widget.veteranlist[0][selectedIndex]['description'];
        }
        if (widget.veteranlist[0][selectedIndex]['image'] != null) {
          theThomb.images =
              widget.veteranlist[0][selectedIndex]['image'].cast<String>();
        }
        if (widget.veteranlist[0][selectedIndex]['audio_video'] != null) {
          theThomb.videos = widget.veteranlist[0][selectedIndex]['audio_video']
              .cast<String>();
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.23,
          width: double.infinity,
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.red),
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.95),
                BlendMode
                    .dstIn, // Bu dstIn olmazsa arka planda bir önceki renk girdisinde belirtilen renk çıkoyor.
              ),
              image: AssetImage('assets/icons/notch.png'),
              fit: BoxFit.none,
            ),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              /*IconButton(
                icon: Icon(Icons.close),
                tooltip: 'Close',
                color: Colors.yellow.shade800,
                onPressed: () => Navigator.pop(context),
              ),*/
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image(
                    alignment: Alignment.center,
                    image: AssetImage('assets/icons/logoOverlay20x.png'),
                  ),
                  MyBottomSheet(
                    searchedThomb: theThomb,
                    hasLocationInfo: showDirection,
                    routeNotDrawn: true,
                    distance: 0,
                    turnType: '',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /*void displayBottomSheet() {
    bottomSheetController = _gKey.currentState!.showBottomSheet((context) {
      theThomb.clear();
      theThomb.name = widget.veteranlist[0][selectedIndex]['firstname'];
      theThomb.middlename =
          widget.veteranlist[0][selectedIndex]['middle_initial'];
      theThomb.surname = widget.veteranlist[0][selectedIndex]['surname'];
      theThomb.rank = widget.veteranlist[0][selectedIndex]['military_rank'];
      theThomb.branch = widget.veteranlist[0][selectedIndex]['military_branch'];
      theThomb.duty = widget.veteranlist[0][selectedIndex]['tours_of_duty'];
      theThomb.medals = widget.veteranlist[0][selectedIndex]['medal_of_honor'];
      theThomb.section = widget.veteranlist[0][selectedIndex]['section'];
      //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
      if (widget.veteranlist[0][selectedIndex]['latitude'] != null &&
          widget.veteranlist[0][selectedIndex]['longitude'] != null &&
          widget.veteranlist[0][selectedIndex]['latitude'] != "" &&
          widget.veteranlist[0][selectedIndex]['longitude'] != "" &&
          widget.veteranlist[0][selectedIndex]['latitude'] != 0 &&
          widget.veteranlist[0][selectedIndex]['longitude'] != 0) {
        showDirection = true;
        theThomb.coordinates = LatLng(
            double.parse(widget.veteranlist[0][selectedIndex]['latitude']
                .replaceAll(',', '.')),
            double.parse(widget.veteranlist[0][selectedIndex]['longitude']
                .replaceAll(',', '.')));
      } else {
        showDirection = false;
      }
      if (widget.veteranlist[0][selectedIndex]['description'] != null) {
        theThomb.description =
            widget.veteranlist[0][selectedIndex]['description'];
      }
      if (widget.veteranlist[0][selectedIndex]['image'] != null) {
        theThomb.images =
            widget.veteranlist[0][selectedIndex]['image'].cast<String>();
      }
      if (widget.veteranlist[0][selectedIndex]['audio_video'] != null) {
        theThomb.videos =
            widget.veteranlist[0][selectedIndex]['audio_video'].cast<String>();
      }
      return Container(
        height: MediaQuery.of(context).size.height * 0.23,
        width: double.infinity,
        //color: Color.fromARGB(255, 0, 19, 61).withOpacity(0.8),
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.red),
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.95),
              BlendMode
                  .dstIn, // Bu dstIn olmazsa arka planda bir önceki renk girdisinde belirtilen renk çıkoyor.
            ),
            image: AssetImage('assets/icons/notch.png'),
            fit: BoxFit.none,
          ),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: Icon(Icons.close),
              tooltip: 'Close',
              color: Colors.yellow.shade800,
              onPressed: () {
                //Navigator.of(context).pop();
                //Navigator.of(context, rootNavigator: true).pop();
                bottomSheetController?.close();
              },
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  alignment: Alignment.center,
                  image: AssetImage('assets/icons/logoOverlay20x.png'),
                ),
                MyBottomSheet(
                  searchedThomb: theThomb,
                  hasLocationInfo: showDirection,
                  routeNotDrawn: true,
                  distance: 0,
                  turnType: '',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }*/

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _gKey,
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        //backgroundColor: Colors.transp  arent,
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 0, 19, 61),
        title: Text(
          'Mandan, ND - Veterans Cemetery',
          style: TextStyle(
            color: Color.fromARGB(255, 194, 149, 36),
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * 0.018,
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
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  colorFilter: new ColorFilter.mode(
                      Colors.amber.withOpacity(0.2), BlendMode.color),
                  image: AssetImage(
                    'assets/images/header.png',
                  ),
                ),
              ),
              child: Text(
                'Results',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: widget.veteranlist[0].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.grey[100],
                  child: Card(
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    color: Colors.grey[200],
                    shadowColor: Colors.transparent,
                    //elevation: 20,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.asset('assets/icons/noProfile.png'),
                          visualDensity: VisualDensity(vertical: 4),
                          title: Text(
                            widget.veteranlist[0][index]['firstname']
                                    .toString() +
                                ' ' +
                                widget.veteranlist[0][index]['surname']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          tileColor:
                              selectedIndex == index ? Colors.grey[350] : null,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              displayBottomSheet();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: widget.veteranlist[0].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.grey[100],
                child: Card(
                  margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  color: Colors.grey[200],
                  shadowColor: Colors.transparent,
                  //elevation: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        visualDensity: VisualDensity(vertical: 4),
                        title: Text(
                          widget.veteranlist[0][index]['firstname'].toString() +
                              ' ' +
                              widget.veteranlist[0][index]['surname']
                                  .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        tileColor:
                            selectedIndex == index ? Colors.grey[350] : null,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            displayBottomSheet();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),*/
