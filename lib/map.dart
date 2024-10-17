import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';
import 'dart:math' show cos, sqrt, asin;

import 'history.dart';
import 'welcome.dart';
//import 'donate.dart';
import 'aboutus.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_map/src/core/positioned_tap_detector_2.dart'
    as flutter_map_tap;
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart'
    as positioned_tap_detector;
//import 'package:flutter_intro/flutter_intro.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'custom_tooltip.dart';
import 'package:is_first_run/is_first_run.dart';

//import 'custom_popup.dart';
import 'drawer.dart';
//import 'profile_page.dart';
import 'bottom_sheet.dart';
import 'detail_search.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ND VETERANS CEMETERY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
      ),
      home: LiveLocationPage(title: 'ND Veterans Cemetery Home Page'),
      routes: {
        'history': (context) => HistoryPage(),
        'welcome': (context) => WelcomePage(),
        //'donate': (context) => DonatePage(),
        'aboutus': (context) => AboutUsPage(),
        'headstone': (context) => DetSearchVeteranPage(),
        'exploremap': (context) =>
            LiveLocationPage(title: 'ND Veterans Cemetery'),
      },
    );
  }
}

class LiveLocationPage extends StatefulWidget {
  final String title;
  final Thomb? searchedThomb;
  LiveLocationPage({Key? key, required this.title, Thomb? this.searchedThomb})
      : super(key: key);
  static const String route = '/live_location';

  //get searchedThomb => null;

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage>
    with SingleTickerProviderStateMixin {
  late bool isFirstRun;
  final TooltipController _controller = TooltipController();
  bool displayRouteSigns = false;
  final geo.Geolocator geolocator = geo.Geolocator();
  geo.Position? _currentPosition;
  bool rendered = false;
  late final AnimationController
      _animationController; // Used to animate the current location icon.
  final _streamController =
      StreamController<double>(); // Used to get the new zoom level.
  Stream<double> get onZoomChanged => _streamController.stream;
  double? newZoomLevel;

  //LocationData? _currentLocation;
  late final MapController _mapController;
  //bool _permission = false;
  //final Location _locationService = Location();
  bool routeDrawn = false;

  List<LatLng> targetPoint = [];
  List<List> sectionPoints = [
    [LatLng(46.750997, -100.851295), 'A'],
    [LatLng(46.751204, -100.851001), 'A'],
    [LatLng(46.751419, -100.850680), 'B'],
    [LatLng(46.751640, -100.850359), 'B'],
    [LatLng(46.750811, -100.850675), 'C'],
    [LatLng(46.751222, -100.850064), 'D'],
    [LatLng(46.750469, -100.850168), 'E'],
    [LatLng(46.750900, -100.849558), 'F'],
    [LatLng(46.750157, -100.849659), 'G'],
    [LatLng(46.750512, -100.849067), 'H'],
    [LatLng(46.751384, -100.852149), 'J'],
    [LatLng(46.752281, -100.849640), 'M'],
    [LatLng(46.752288, -100.848235), 'N'],
    [LatLng(46.751402, -100.848058), 'P'],
    [LatLng(46.751766, -100.849505), 'O'],
    [LatLng(46.751990, -100.849033), 'O'],
    [LatLng(46.751769, -100.848668), 'O'],
    [LatLng(46.751412, -100.848958), 'O'],
    [LatLng(46.750530, -100.848084), 'Q'],
    [LatLng(46.749847, -100.848108), 'R'],
    [LatLng(46.749541, -100.849426), 'S'],
    [LatLng(46.749541, -100.850830), 'T'],
    [LatLng(46.750082, -100.851769), 'U'],
    [LatLng(46.750405, -100.851410), 'U'],
    [LatLng(46.750093, -100.850916), 'U'],
    [LatLng(46.749858, -100.851404), 'U'],
    [LatLng(46.749719, -100.852148), 'V'],
    [LatLng(46.750618, -100.852143), 'W']
  ];
  late Thomb theThomb = Thomb();
  List<Thomb> allthombs = [];
  List<LatLng> _route = [];
  List<Marker> RouteSigns = [];
  List<RouteSign> RouteData = [];

  //var interActiveFlags = InteractiveFlag.all;
  var infoWindowVisible = false;

  GlobalKey<ScaffoldState> _gkeyS = GlobalKey<ScaffoldState>();
  //GlobalKey<ScaffoldState> _gkey = new GlobalKey<ScaffoldState>();

  //final _gkey5 = new GlobalKey<ScaffoldState>();

  var freeMap = false;

  Marker tappedHeadstone = Marker(
    width: 0,
    height: 0,
    point: LatLng(0, 0),
    builder: (ctx) => GestureDetector(
      child: Image.asset(
        'assets/icons/Headstone.png',
        width: 0,
        height: 0,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      ),
      //       Icon(Icons.remove, color: Colors.white),
    ),
  );

  Future<void> searchVeteran(String searchString) async {
    List<String> splitted_string = searchString.split(" ");
    String search_name = '';
    String search_midname = '';
    String search_surname = '';

    theThomb
        .clear(); // Yeni bilgileri almadan önce eski mezar bilgilerini temizle.

    //Arama kutusuna yazılan kelimeleri ad / göbek ad / soyad olarak ayıkla
    if (splitted_string.length > 0) {
      if (splitted_string.length == 1) {
        search_name = splitted_string[0];
      } else if (splitted_string.length == 2) {
        search_name = splitted_string[0];
        search_surname = splitted_string[1];
      } else if (splitted_string.length == 3) {
        search_name = splitted_string[0];
        search_midname = splitted_string[1];
        search_surname = splitted_string[2];
      } else if (splitted_string.length == 4) {
        search_name = splitted_string[0] + " " + splitted_string[1];
        search_midname = splitted_string[2];
        search_surname = splitted_string[3];
      }
    } else {
      //empty string
      print("Empty String");
    }

    //Ayıklanan ad / göbek ad / soyad üzerinden veteran arama API'sini çağır.
    final response = await http.get(Uri.parse(
        'http://www.nevalan.site/demo/index.php?route=api/veteran/namesurnameFilter&name=' +
            search_name +
            '&surname=' +
            search_surname +
            '&midname=' +
            search_midname));

    if (response.statusCode == 200) {
      //API başarıyla döndüyse
      if (jsonDecode(response.body).length > 0) {
        //API sonucu dolu döndüyse
        if (jsonDecode(response.body)['veteran_namesurname_details'][0]
                    ['latitude'] !=
                "" &&
            jsonDecode(response.body)['veteran_namesurname_details'][0]
                    ['longitude'] !=
                "") {
          //Dönen ilk sonucun enlem boylam bilgisi boş değilse
          // Dönen ilk sonucu al
          theThomb.coordinates = LatLng(
              double.parse(
                  jsonDecode(response.body)['veteran_namesurname_details'][0]
                      ['latitude']),
              double.parse(
                  jsonDecode(response.body)['veteran_namesurname_details'][0]
                      ['longitude']));
          fetchRoute(searchedPoint: theThomb.coordinates);
          theThomb.name =
              jsonDecode(response.body)['veteran_namesurname_details'][0]
                  ['firstname'];
          theThomb.middlename =
              jsonDecode(response.body)['veteran_namesurname_details'][0]
                  ['middle_initial'];
          theThomb.surname =
              jsonDecode(response.body)['veteran_namesurname_details'][0]
                  ['surname'];
          theThomb.section =
              jsonDecode(response.body)['veteran_namesurname_details'][0]
                  ['section'];
          theThomb.images =
              jsonDecode(response.body)['veteran_namesurname_details'][0]
                  ['image'];
          theThomb.videos =
              jsonDecode(response.body)['veteran_namesurname_details'][0]
                  ['audio_video'];
          /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Veteran is located at the section: ' + theThomb.section),
          ));*/
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Location information for the searched veteran is not available.'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Searched veteran is not registered at this cemetery. Please contact Cemetery Management.'),
        ));
      }
    } else {
      throw Exception('Failed to load veteran information from the server.');
    }
  }

  Future<List<LatLng>> fetchRoute({LatLng? searchedPoint}) async {
    var route = <LatLng>[];
    RouteSigns.clear();

    if (searchedPoint != null) {
      if (targetPoint.isNotEmpty) {
        targetPoint.removeLast();
      }
      targetPoint.add(searchedPoint);
    }

    if (_currentPosition != null) {
      final response = await http.get(Uri.parse(
          'https://graphhopper.com/api/1/route?point=${_currentPosition?.latitude.toStringAsFixed(6)},${_currentPosition?.longitude.toStringAsFixed(6)}&point=${targetPoint.last.latitude.toStringAsFixed(6)},${targetPoint.last.longitude.toStringAsFixed(6)}&profile=foot&locale=en&calc_points=true&points_encoded=false&key=209eece1-0bc1-46b0-b2b3-d0b17d0d8570'));

      print(
          'https://graphhopper.com/api/1/route?point=${_currentPosition?.latitude?.toStringAsFixed(6)},${_currentPosition?.longitude?.toStringAsFixed(6)}&point=${targetPoint.last.latitude.toStringAsFixed(6)},${targetPoint.last.longitude.toStringAsFixed(6)}&profile=foot&locale=en&calc_points=true&points_encoded=false&key=209eece1-0bc1-46b0-b2b3-d0b17d0d8570');
      // If the server did return a 200 OK response then parse the JSON.
      if (response.statusCode == 200) {
        List coordinates =
            jsonDecode(response.body)['paths'][0]['points']['coordinates'];
        List instructions =
            jsonDecode(response.body)['paths'][0]['instructions'];

        for (var element in instructions) {
          RouteData.add(RouteSign(element['distance'], element['text']));

          var signWidth = MediaQuery.of(context).size.width * 0.15;
          var signHeight = MediaQuery.of(context).size.height * 0.07;

          if (element['text'] == 'Continue') {
            RouteSigns.add(
              Marker(
                width: signWidth,
                height: signHeight,
                point: LatLng(_currentPosition!.latitude + 0.00007,
                    _currentPosition!.longitude),
                builder: (ctx) => routeSign(
                  element['text'],
                  Icon(Icons.forward),
                ),
              ),
            );
          } else if (element['text'] == 'Turn left') {
            RouteSigns.add(
              Marker(
                width: signWidth,
                height: signHeight,
                point: LatLng(coordinates[element['interval'][0]][1],
                    coordinates[element['interval'][0]][0]),
                builder: (ctx) => routeSign(
                  element['text'],
                  Icon(Icons.subdirectory_arrow_right),
                ),
              ),
            );
          } else if (element['text'] == 'Turn slight left') {
            RouteSigns.add(
              Marker(
                width: signWidth,
                height: signHeight,
                point: LatLng(coordinates[element['interval'][0]][1],
                    coordinates[element['interval'][0]][0]),
                builder: (ctx) => routeSign(
                  element['text'],
                  Icon(Icons.subdirectory_arrow_right),
                ),
              ),
            );
          } else if (element['text'] == 'Turn right') {
            RouteSigns.add(
              Marker(
                width: signWidth,
                height: signHeight,
                point: LatLng(coordinates[element['interval'][0]][1],
                    coordinates[element['interval'][0]][0]),
                builder: (context) => Container(
                  width: 80, //MediaQuery.of(context).size.width * 0.4,
                  height: 40, //MediaQuery.of(context).size.height * 0.2,
                  child: routeSign(
                    element['text'],
                    Icon(Icons.subdirectory_arrow_left),
                  ),
                ),
              ),
            );
          } else if (element['text'] == 'Turn slight right') {
            RouteSigns.add(
              Marker(
                width: signWidth,
                height: signHeight,
                point: LatLng(coordinates[element['interval'][0]][1],
                    coordinates[element['interval'][0]][0]),
                builder: (ctx) => routeSign(
                  element['text'],
                  Icon(Icons.subdirectory_arrow_left),
                ),
              ),
            );
          } else if (element['text'] == 'Arrive at destination') {
            late Icon lastTurn;
            late String lastTurnType;
            if (searchedPoint!.latitude <
                    coordinates[element['interval'][0]][1] &&
                searchedPoint.longitude <
                    coordinates[element['interval'][0]][0]) {
              lastTurn = Icon(Icons.subdirectory_arrow_left);
              lastTurnType = 'Turn right';
            } else if (searchedPoint.latitude <
                    coordinates[element['interval'][0]][1] &&
                searchedPoint.longitude >
                    coordinates[element['interval'][0]][0]) {
              lastTurn = Icon(Icons.subdirectory_arrow_right);
              lastTurnType = 'Turn right';
            } else if (searchedPoint.latitude >
                    coordinates[element['interval'][0]][1] &&
                searchedPoint.longitude <
                    coordinates[element['interval'][0]][0]) {
              lastTurn = Icon(Icons.subdirectory_arrow_left);
              lastTurnType = 'Turn left';
            } else {
              lastTurn = Icon(Icons.subdirectory_arrow_right);
              lastTurnType = 'Turn left';
            }
            RouteSigns.add(
              Marker(
                width: signWidth,
                height: signHeight,
                point: LatLng(coordinates[element['interval'][0]][1],
                    coordinates[element['interval'][0]][0]),
                builder: (ctx) => routeSign(
                  'Last turn',
                  lastTurn,
                ),
              ),
            );
          } /*else {
            signType = Icons.abc_sharp;
            print(i);
          }*/

          /*RouteSigns.add(
            Marker(
              width: signWidth,
              height: signHeight,
              point: searchedPoint!,
              /*LatLng(searchedPoint!.latitude - 0.0001,
                  searchedPoint.longitude - 0.0001),*/
              builder: (ctx) => Text('Destination', textScaleFactor: 0.7),
            ),
          );*/
        }

        for (var element in coordinates) {
          route.add(LatLng(element[1], element[0]));
        }
        if (searchedPoint != null) {
          route.add(targetPoint.last);
          showTappedMarker = true;
        }
        routeDrawn = true;
        setState(() {
          _route = route;
        });
        return route;
      } else {
        // If the server did not return a 200 OK response then throw an exception.
        throw Exception('Failed to get route.');
      }
    } else {
      //throw Exception(
      print(
          "We couldn't get your current location information. Please share your cuurent location information and try again.");
      return route;
    }
  }

  @override
  void initState() {
    /*_controller.onDone(() {
      setState(() {
        done = true;
      });
    });*/
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);

    super.initState();

    _mapController = MapController();
    searchTextField = TextField(
      controller: _searchTextFieldController,
      decoration: InputDecoration(
        //hintText: 'type in veteran name...',
        hintStyle: TextStyle(
          color: Colors.yellow.shade800,
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.white,
      ),
    );
    initLocationService(); //Başlangıç konumunu getir.
    //_getLocation();
    onZoomChanged.listen((event) {
      setState(() {
        newZoomLevel = event;
      });
    });

    _getCurrentPosition();

    initThombs(); //Tüm mezar taşı konumlarını al.

    /*WidgetsBinding.instance?.addPostFrameCallback((_) {
      //Sayfa yüklendikten sonra kılavuzu başlat.
      Future.delayed(Duration.zero, () async {
        if (await IsFirstRun.isFirstCall()) {
          isFirstRun = true;
        } else {
          isFirstRun = false;
        }
      });
    });*/
  }

  /*_getLocation() async {
    LocationData? location;
    location = await _locationService.getLocation();
    _currentLocation = location;
    _locationService.onLocationChanged.listen((LocationData result) async {
      if (mounted) {
        setState(() {
          _currentLocation = result;
          // If Live Update is enabled, move map center
          if (_liveUpdate) {
            _mapController.move(
                LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                _mapController.zoom);
          }
        });
      }
    });
  }*/

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == geo.LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await geo.Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.high)
        .then((geo.Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });

    //Eğer harita sayfasına başka bir sayfadan güzergah çizdirmek için geldiyse (routeDrawn değişkeni false ise durumun bu olduğu var sayılmakta) diğer sayfadan gelen widget bilgisi üzerinden (aranan mezarlık konumu) güzergah çizdir.
    if (routeDrawn == false) {
      if (widget.searchedThomb != null) {
        if (widget.searchedThomb!.coordinates != LatLng(0.0, 0.0)) {
          if (widget.searchedThomb!.coordinates.latitude != '' &&
              widget.searchedThomb!.coordinates.latitude != 0.0 &&
              widget.searchedThomb!.coordinates.longitude != '' &&
              widget.searchedThomb!.coordinates.longitude != 0.0) {
            targetPoint = [widget.searchedThomb!.coordinates];
            _route = await fetchRoute(
                searchedPoint: widget.searchedThomb!.coordinates);
            displayBottomSheet();
          } else if (routeDrawn == true) {
            print('Coordinate information of the veteran does not exist.');
          }
        } else if (routeDrawn == true) {
          print('Coordinate information of the veteran does not exist.');
        }
      } else if (routeDrawn == true) {
        print('Coordinate information of the veteran does not exist.');
      }
    }
  }

  Future<void> initThombs() async {
    var data = await rootBundle.load('assets/files/VetCemLocationData.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var i = 0;

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        //print('${row.map((e) => e?.value)}');
        if (row[0] == null || row[1] == null) {
          continue;
        }
        if (i > 0) {
          late Thomb temp = Thomb();
          //temp.coordinates = LatLng(row[1]!.value, row[0]!.value);
          Data? lat = row[1];
          Data? long = row[0];
          Data? section = row[3];
          // E ve F adalarındaki enlem-boylam verisi taştığı için haritada düzgün görünecek kadar kaydırılır.
          if (section!.value.toString() == 'E') {
            lat!.value = lat.value + 0.000005;
            long!.value = long.value - 0.00002;
          } else if (section.value.toString() == 'F') {
            lat!.value = lat.value + 0.00002;
            long!.value = long.value - 0.00002;
          }

          try {
            temp.coordinates = LatLng(double.parse(lat!.value.toString()),
                double.parse(long!.value.toString()));
            temp.section = section.value.toString();
            temp.row = row[2]!.value.toString();
          } catch (FormatException) {
            continue;
          }
          allthombs.add(temp);
        }
        i++;
      }
    }
  }

  Future<void> initLocationService() async {
    //await _locationService.changeSettings(
    //  accuracy: LocationAccuracy.high,
    //  interval: 1000,
    //);

    //LocationData? location;
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    //bool serviceRequestResult;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      /*serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                }
              });
            }
          });
        } else {

        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }*/
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
      } else if (e.code == 'SERVICE_STATUS_ERROR') {}
      return; //location = null;
    }
  }

  void _handleLongPress(
      flutter_map_tap.TapPosition tapPosition, LatLng latlng) async {
    showTappedMarker = true;

    Uri uri = Uri.parse(
        'http://www.nevalan.site/demo/index.php?route=api/veteran/latlongfilter&lat=' +
            latlng.latitude.toString() +
            '&long=' +
            latlng.longitude.toString());

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body).length > 0) {
        if (jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['latitude'] !=
                "" &&
            jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['longitude'] !=
                "") {
          // Enlem-boylam doluysa
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['firstname'] !=
              null) {
            theThomb.name = jsonDecode(response.body)['veteran_latlong_details']
                [0]['firstname'];
          } else {
            theThomb.name = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['middle_initial'] !=
              null) {
            theThomb.middlename =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['middle_initial'];
          } else {
            theThomb.middlename = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['surname'] !=
              null) {
            theThomb.surname =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['surname'];
          } else {
            theThomb.surname = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['military_rank'] !=
              null) {
            theThomb.rank = jsonDecode(response.body)['veteran_latlong_details']
                [0]['military_rank'];
          } else {
            theThomb.rank = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['military_branch'] !=
              null) {
            theThomb.branch =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['military_branch'];
          } else {
            theThomb.branch = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['tours_of_duty'] !=
              null) {
            theThomb.duty = jsonDecode(response.body)['veteran_latlong_details']
                [0]['tours_of_duty'];
          } else {
            theThomb.duty = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['medal_of_honor'] !=
              null) {
            theThomb.medals =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['medal_of_honor'];
          } else {
            theThomb.medals = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['section'] !=
              null) {
            theThomb.section =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['section'];
          } else {
            theThomb.section = '';
          }
          theThomb.coordinates = LatLng(
              double.parse(jsonDecode(response.body)['veteran_latlong_details']
                  [0]['latitude']),
              double.parse(jsonDecode(response.body)['veteran_latlong_details']
                  [0]['longitude']));
          if (theThomb.section[0] == 'E' || theThomb.section[0] == 'F') {
            // LongPress sonrası güzergah çizilirken E ve F adalarında oluşan kaymaları gidermek için eklendi.
            theThomb.coordinates = LatLng(
                theThomb.coordinates.latitude + 0.000005,
                theThomb.coordinates.longitude - 0.00002);
          }

          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['description'] !=
              null) {
            theThomb.description =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['description'];
          } else {
            theThomb.description = '';
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['image'] !=
              null) {
            theThomb.images =
                jsonDecode(response.body)['veteran_latlong_details'][0]['image']
                    .cast<String>();
          } else {
            theThomb.images = <String>[];
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['audio_video'] !=
              null) {
            theThomb.videos =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                        ['audio_video']
                    .cast<String>();
          } else {
            theThomb.videos = <String>[];
          }

          //setState(() {
          if (targetPoint.isNotEmpty) {
            targetPoint.removeLast();
          }
          //});

          bool tempRouteSolutionSectionV = [
            'V1',
            'V2',
            'V3',
            'V4',
            'V68',
            'V69',
            'V135',
          ].contains(theThomb.section)
              ? true
              : false;

          bool tempRouteSolutionSectionN = (theThomb.section[0] == 'N' &&
                  int.parse(theThomb.section.substring(1)) > 275)
              ? true
              : false;

          bool tempRouteSolutionSectionP = (theThomb.section[0] == 'P' &&
                  int.parse(theThomb.section.substring(1)) > 307)
              ? true
              : false;

          bool tempRouteSolutionSectionQ = (theThomb.section[0] == 'Q' &&
                  int.parse(theThomb.section.substring(1)) > 332)
              ? true
              : false;

          bool tempRouteSolutionSectionR = (theThomb.section[0] == 'R' &&
                  int.parse(theThomb.section.substring(1)) > 311)
              ? true
              : false;

          if (tempRouteSolutionSectionV) {
            for (Thomb thomb in allthombs) {
              if (thomb.section[0] == 'V') {
                if (thomb.row ==
                    'V' +
                        (int.parse(theThomb.section.substring(1)) + 136)
                            .toString()) {
                  targetPoint.add(thomb.coordinates);
                }
              }
            }
          } else if (tempRouteSolutionSectionN) {
            for (Thomb thomb in allthombs) {
              if (thomb.section[0] == 'N') {
                if (thomb.row ==
                    'N' +
                        (int.parse(theThomb.section.substring(1)) -
                                (49 *
                                    ((int.parse(theThomb.section.substring(1)) -
                                                276) /
                                            49)
                                        .ceil()))
                            .toString()) {
                  targetPoint.add(thomb.coordinates);
                }
              }
            }
          } else if (tempRouteSolutionSectionP) {
            for (Thomb thomb in allthombs) {
              if (thomb.section[0] == 'P') {
                if (thomb.row ==
                    'P' +
                        (int.parse(theThomb.section.substring(1)) -
                                (56 *
                                    ((int.parse(theThomb.section.substring(1)) -
                                                307) /
                                            56)
                                        .ceil()))
                            .toString()) {
                  targetPoint.add(thomb.coordinates);
                }
              }
            }
          } else if (tempRouteSolutionSectionQ) {
            int sectionNo = int.parse(theThomb.section.substring(1));
            int routeCoeff = ((sectionNo - 332) / 36).ceil();
            targetPoint.add(LatLng(theThomb.coordinates.latitude,
                theThomb.coordinates.longitude - routeCoeff * 0.00004));
            /*for (Thomb thomb in allthombs) {
              if (thomb.section[0] == 'Q') {
                if (thomb.row ==
                    'Q' +
                        (int.parse(theThomb.section.substring(1)) -
                                (36 *
                                    ((int.parse(theThomb.section.substring(1)) -
                                                332) /
                                            36)
                                        .ceil()))
                            .toString()) {
                  targetPoint.add(thomb.coordinates);
                }
              }
            }*/
          } else if (tempRouteSolutionSectionR) {
            int sectionNo = int.parse(theThomb.section.substring(1));
            int routeCoeff = ((sectionNo - 311) / 43).ceil();
            targetPoint.add(LatLng(theThomb.coordinates.latitude,
                theThomb.coordinates.longitude - routeCoeff * 0.000035));
            /*for (Thomb thomb in allthombs) {
              if (thomb.section[0] == 'R') {
                if (thomb.row ==
                  'R' + (sectionNo - (43 * routeCoeff)).toString()) {
                
                }
              }
            }*/
          } else {
            targetPoint.add(theThomb.coordinates);
          }

          _route = await fetchRoute(
            searchedPoint: targetPoint[targetPoint.length - 1],
          );
          if (tempRouteSolutionSectionV ||
              tempRouteSolutionSectionN ||
              tempRouteSolutionSectionP ||
              tempRouteSolutionSectionQ ||
              tempRouteSolutionSectionR) {
            _route.add(theThomb.coordinates);
            targetPoint.removeLast();
            targetPoint.add(theThomb.coordinates);
          }
          setState(() {
            _route.add(targetPoint[0]);
            tappedHeadstone = Marker(
              width: 20,
              height: 20,
              point: theThomb.coordinates,
              builder: (ctx) => GestureDetector(
                child: Image.asset(
                  'assets/icons/Headstone.png',
                  width: 10,
                  height: 50,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.none,
                  color: Colors.red,
                ),
                //       Icon(Icons.remove, color: Colors.white),
              ),
            );
          });

          routeDrawn = true;
          displayBottomSheet();
        }
        // Enlem-boyla boşsa ne yapılmalı?
      }
    }
  }

  void _handleMarkerTap(LatLng latlng) async {
    showTappedMarker = true;

    Uri uri = Uri.parse(
        'http://www.nevalan.site/demo/index.php?route=api/veteran/latlongfilter&lat=' +
            latlng.latitude.toString() +
            '&long=' +
            latlng.longitude.toString());

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body).length > 0) {
        if (jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['latitude'] !=
                "" &&
            jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['longitude'] !=
                "") {
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['firstname'] !=
              null) {
            theThomb.name = jsonDecode(response.body)['veteran_latlong_details']
                [0]['firstname'];
          } else {
            theThomb.name = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['middle_initial'] !=
              null) {
            theThomb.middlename =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['middle_initial'];
          } else {
            theThomb.middlename = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['surname'] !=
              null) {
            theThomb.surname =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['surname'];
          } else {
            theThomb.surname = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['military_rank'] !=
              null) {
            theThomb.rank = jsonDecode(response.body)['veteran_latlong_details']
                [0]['military_rank'];
          } else {
            theThomb.rank = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['military_branch'] !=
              null) {
            theThomb.branch =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['military_branch'];
          } else {
            theThomb.branch = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['tours_of_duty'] !=
              null) {
            theThomb.duty = jsonDecode(response.body)['veteran_latlong_details']
                [0]['tours_of_duty'];
          } else {
            theThomb.duty = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['medal_of_honor'] !=
              null) {
            theThomb.medals =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['medal_of_honor'];
          } else {
            theThomb.medals = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['section'] !=
              null) {
            theThomb.section =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['section'];
          } else {
            theThomb.section = "";
          }
          theThomb.coordinates = LatLng(
              double.parse(jsonDecode(response.body)['veteran_latlong_details']
                  [0]['latitude']),
              double.parse(jsonDecode(response.body)['veteran_latlong_details']
                  [0]['longitude']));
          if (theThomb.section[0] == 'E' || theThomb.section[0] == 'F') {
            // MarkerTap sonrası güzergah çizilirken E ve F adalarında oluşan kaymaları gidermek için eklendi.
            theThomb.coordinates = LatLng(
                theThomb.coordinates.latitude + 0.000005,
                theThomb.coordinates.longitude - 0.00002);
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['description'] !=
              null) {
            theThomb.description =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                    ['description'];
          } else {
            theThomb.description = "";
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['image'] !=
              null) {
            theThomb.images =
                jsonDecode(response.body)['veteran_latlong_details'][0]['image']
                    .cast<String>();
          } else {
            theThomb.images = <String>[];
          }
          if (jsonDecode(response.body)['veteran_latlong_details'][0]
                  ['audio_video'] !=
              null) {
            theThomb.videos =
                jsonDecode(response.body)['veteran_latlong_details'][0]
                        ['audio_video']
                    .cast<String>();
          } else {
            theThomb.videos = <String>[];
          }

          setState(() {
            tappedHeadstone = Marker(
              width: 20,
              height: 20,
              point: theThomb.coordinates,
              builder: (ctx) => GestureDetector(
                child: Image.asset(
                  'assets/icons/Headstone.png',
                  width: 10,
                  height: 50,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.none,
                  color: Colors.blue,
                ),
                //       Icon(Icons.remove, color: Colors.white),
              ),
            );
          });

          routeDrawn = false;
          displayBottomSheetOnTap();
        }
      }
    }
  }

  TextField searchTextField = TextField(
    decoration: InputDecoration(
      //hintText: 'type in veteran name...',
      hintStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      border: InputBorder.none,
    ),
    style: TextStyle(
      color: Colors.white,
    ),
  );
  final _searchTextFieldController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _streamController.close();
    _searchTextFieldController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /*Stack _buildCustomMarker(showTappedMarker) {
    if (showTappedMarker) {
      return Stack(
        children: <Widget>[popup(theThomb), marker()],
      );
    } else {
      return Stack(
        children: <Widget>[marker()],
      );
    }
  }*/

  /*Stack buildRouteSign(showRouteSigns, LatLng point) {
    if (showRouteSigns) {
      return Stack(
        children: <Widget>[
          //Marker(point: point, builder: (ctx) {Icon(Icons.remove, color: Colors.red)}),
          /*for (var element in RouteSigns)
            element.description == 'Continue'
                ? routeSign(element.description, element.coordinate)
                : Text(element.coordinate.toString()),*/
        ],
      );
    } else {
      return Stack();
    }
  }*/

  /*Container popup(Thomb searched_thomb) {
    bool hasLocationInfo;
    return Container(
      //opacity: 1.0, //infoWindowVisible ? 1.0 : 0.0,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: AbsorbPointer(
          child: Container(
            alignment: Alignment.bottomCenter,
            width: 120.0,
            height: 194.16,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30.0),
              color: Color.fromARGB(255, 0, 19, 61).withOpacity(1.0),
              image: DecorationImage(
                image: AssetImage("assets/images/ic_info_window_2x.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: CustomPopup(
                key: OZKeys.ozKey1, thomb: theThomb), //_gkey yerine key vardı
          ),
        ),
        onTap: () {
          //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
          if (theThomb.coordinates.latitude != null &&
              theThomb.coordinates.longitude != null &&
              theThomb.coordinates.latitude != "" &&
              theThomb.coordinates.longitude != "" &&
              theThomb.coordinates.latitude != 0 &&
              theThomb.coordinates.longitude != 0) {
            hasLocationInfo = true;
          } else {
            hasLocationInfo = false;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      theThomb: theThomb,
                      hasLocationInfo: hasLocationInfo,
                      routeNotDrawn: false,
                    )),
          );
        },
      ),
    );
  }*/

  Container routeSign(String text, Icon turnType) {
    return Container(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              RotationTransition(
                turns: AlwaysStoppedAnimation(0 / 360),
                child: turnType,
              ),
            ],
          ),
          Text(
              //widget.distance.toString() +
              text,
              style: TextStyle(
                  //color: Color.fromARGB(255, 194, 149, 36),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ],
      ),
      //alignment: Alignment.bottomCenter,
      //width: MediaQuery.of(context).size.width * 0.4,
      //height: MediaQuery.of(context).size.height * 0.2,
      /*decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(),
        borderRadius: BorderRadius.circular(5.0),
        color: Color.fromARGB(255, 208, 211, 216).withOpacity(0.0),
        //image: DecorationImage(
        //  image: AssetImage("assets/icons/dialogbox.png"),
        //  fit: BoxFit.cover,
        //)
      ),*/
    );
  }

  Container marker() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        //alignment: Alignment.bottomCenter,
        //splashColor: Colors.grey,
        /*onTap: () {
          showTappedMarker = true;
          displayBottomSheet();
        },*/
        child: Image.asset(
          'assets/icons/markerusflag.jpg',
          width: 35,
          height: 35,
        ),
      ),
      //opacity: infoWindowVisible ? 0.0 : 1.0,
    );
  }

  var showTappedMarker = false;
  Widget customIcon = OverlayTooltipItem(
    displayIndex: 0,
    tooltip: (controller) => Padding(
      padding: const EdgeInsets.only(right: 15),
      child: MTooltip(
        title: 'Quick Search',
        controller: controller,
        description: 'Search Veteran with Name and Surname.',
      ),
    ),
    child: Icon(
      Icons.home,
      color: Colors.yellow.shade800,
    ),
  );
  //);
  Widget customSearchBar = FittedBox(
    fit: BoxFit.fitWidth,
    child: Text(
      'Mandan, ND - Veterans Cemetery',
      style: TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 194, 149, 36),
      ),
    ),
  );

  void displayBottomSheet() {
    bool hasLocationInfo;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (theThomb.section == '') {
          if (widget.searchedThomb != null) {
            theThomb.name = widget.searchedThomb?.name;
            theThomb.middlename = widget.searchedThomb?.middlename;
            theThomb.surname = widget.searchedThomb?.surname;
            theThomb.rank = widget.searchedThomb?.rank;
            theThomb.branch = widget.searchedThomb?.branch;
            theThomb.duty = widget.searchedThomb?.duty;
            theThomb.medals = widget.searchedThomb?.medals;
            theThomb.section = widget.searchedThomb?.section;
            theThomb.coordinates = widget.searchedThomb?.coordinates;
            theThomb.description = widget.searchedThomb?.description;
            theThomb.images = widget.searchedThomb?.images;
            theThomb.videos = widget.searchedThomb?.videos;
          } /*else {
          theThomb.name = '';
          theThomb.middlename = '';
          theThomb.surname = '';
          theThomb.rank = '';
          theThomb.branch = '';
          theThomb.duty = '';
          theThomb.medals = '';
          //theThomb.section = '';
          //theThomb.coordinates = LatLng(0, 0);
          theThomb.description = '';
          theThomb.images = <String>[];
          theThomb.videos = <String>[];
        }*/
        }
        //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
        if ( //theThomb.coordinates.latitude != null &&
            //theThomb.coordinates.longitude != null &&
            theThomb.coordinates.latitude != "" &&
                theThomb.coordinates.longitude != "" &&
                theThomb.coordinates.latitude != 0 &&
                theThomb.coordinates.longitude != 0) {
          hasLocationInfo = true;
        } else {
          hasLocationInfo = false;
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
                    //key: OZKeys.ozKey2,//_gkey yerine key vardı
                    searchedThomb: theThomb,
                    hasLocationInfo: hasLocationInfo,
                    routeNotDrawn: false,
                    distance: RouteData.isNotEmpty
                        ? RouteData[0].distance
                        : 0.0, // Use a default value like 0.0 if RouteData is empty
                    turnType: RouteData.isNotEmpty
                        ? RouteData[0].description
                        : 'No description', // Provide a fallback for turnType
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //PersistentBottomSheetController? bottomSheetController;
  /*void displayBottomSheet() {
    bool hasLocationInfo;
    bottomSheetController = _gkeyS.currentState?.showBottomSheet((context) {
      if (theThomb.section == '') {
        if (widget.searchedThomb != null) {
          theThomb.name = widget.searchedThomb?.name;
          theThomb.middlename = widget.searchedThomb?.middlename;
          theThomb.surname = widget.searchedThomb?.surname;
          theThomb.rank = widget.searchedThomb?.rank;
          theThomb.branch = widget.searchedThomb?.branch;
          theThomb.duty = widget.searchedThomb?.duty;
          theThomb.medals = widget.searchedThomb?.medals;
          theThomb.section = widget.searchedThomb?.section;
          theThomb.coordinates = widget.searchedThomb?.coordinates;
          theThomb.description = widget.searchedThomb?.description;
          theThomb.images = widget.searchedThomb?.images;
          theThomb.videos = widget.searchedThomb?.videos;
        } /*else {
          theThomb.name = '';
          theThomb.middlename = '';
          theThomb.surname = '';
          theThomb.rank = '';
          theThomb.branch = '';
          theThomb.duty = '';
          theThomb.medals = '';
          //theThomb.section = '';
          //theThomb.coordinates = LatLng(0, 0);
          theThomb.description = '';
          theThomb.images = <String>[];
          theThomb.videos = <String>[];
        }*/
      }
      //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
      if ( //theThomb.coordinates.latitude != null &&
          //theThomb.coordinates.longitude != null &&
          theThomb.coordinates.latitude != "" &&
              theThomb.coordinates.longitude != "" &&
              theThomb.coordinates.latitude != 0 &&
              theThomb.coordinates.longitude != 0) {
        hasLocationInfo = true;
      } else {
        hasLocationInfo = false;
      }
      return Container(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.95),
              BlendMode
                  .dstIn, // Bu dstIn olmazsa arka planda bir önceki renk girdisinde belirtilen renk çıkoyor.
            ),
            image: AssetImage("assets/icons/notch.png"),
            fit: BoxFit.none,
          ),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              icon: Icon(Icons.close),
              tooltip: 'Close',
              color: Colors.yellow.shade800,
              onPressed: () {
                setState(() {
                  _route.clear();
                  RouteSigns.clear();
                  targetPoint.clear();
                });
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
                  //key: OZKeys.ozKey2,//_gkey yerine key vardı
                  searchedThomb: theThomb,
                  hasLocationInfo: hasLocationInfo,
                  routeNotDrawn: false,
                  distance: RouteData.isNotEmpty
                      ? RouteData[0].distance
                      : 0.0, // Use a default value like 0.0 if RouteData is empty
                  turnType: RouteData.isNotEmpty
                      ? RouteData[0].description
                      : 'No description', // Provide a fallback for turnType
                ),
              ],
            ),
          ],
        ),
      );
    });
  }*/

  void displayBottomSheetOnTap() {
    bool hasLocationInfo;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (theThomb.section == '') {
          if (widget.searchedThomb != null) {
            theThomb.name = widget.searchedThomb?.name;
            theThomb.middlename = widget.searchedThomb?.middlename;
            theThomb.surname = widget.searchedThomb?.surname;
            theThomb.rank = widget.searchedThomb?.rank;
            theThomb.branch = widget.searchedThomb?.branch;
            theThomb.duty = widget.searchedThomb?.duty;
            theThomb.medals = widget.searchedThomb?.medals;
            theThomb.section = widget.searchedThomb?.section;
            theThomb.coordinates = widget.searchedThomb?.coordinates;
            theThomb.description = widget.searchedThomb?.description;
            theThomb.images = widget.searchedThomb?.images;
            theThomb.videos = widget.searchedThomb?.videos;
          } /*else {
          theThomb.section = widget.searchedThomb?.section;
          theThomb.coordinates = widget.searchedThomb?.coordinates;
        }*/
        }
        //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
        if ( //theThomb.coordinates.latitude != null &&
            //theThomb.coordinates.longitude != null &&
            theThomb.coordinates.latitude != "" &&
                theThomb.coordinates.longitude != "" &&
                theThomb.coordinates.latitude != 0 &&
                theThomb.coordinates.longitude != 0) {
          hasLocationInfo = true;
        } else {
          hasLocationInfo = false;
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
                    //key: OZKeys.ozKey2,
                    searchedThomb: theThomb,
                    hasLocationInfo: true,
                    routeNotDrawn: !routeDrawn,
                    distance: 0.0,
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

  /*void displayBottomSheetOnTap() {
    bool hasLocationInfo;

    bottomSheetController = _gkeyS.currentState?.showBottomSheet((context) {
      if (theThomb.section == '') {
        if (widget.searchedThomb != null) {
          theThomb.name = widget.searchedThomb?.name;
          theThomb.middlename = widget.searchedThomb?.middlename;
          theThomb.surname = widget.searchedThomb?.surname;
          theThomb.rank = widget.searchedThomb?.rank;
          theThomb.branch = widget.searchedThomb?.branch;
          theThomb.duty = widget.searchedThomb?.duty;
          theThomb.medals = widget.searchedThomb?.medals;
          theThomb.section = widget.searchedThomb?.section;
          theThomb.coordinates = widget.searchedThomb?.coordinates;
          theThomb.description = widget.searchedThomb?.description;
          theThomb.images = widget.searchedThomb?.images;
          theThomb.videos = widget.searchedThomb?.videos;
        } /*else {
          theThomb.section = widget.searchedThomb?.section;
          theThomb.coordinates = widget.searchedThomb?.coordinates;
        }*/
      }
      //Konum bilgisi yoksa güzergah çizme tuşunu gösterme
      if ( //theThomb.coordinates.latitude != null &&
          //theThomb.coordinates.longitude != null &&
          theThomb.coordinates.latitude != "" &&
              theThomb.coordinates.longitude != "" &&
              theThomb.coordinates.latitude != 0 &&
              theThomb.coordinates.longitude != 0) {
        hasLocationInfo = true;
      } else {
        hasLocationInfo = false;
      }
      return Container(
        height: MediaQuery.of(context).size.height * 0.23,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/notch.png"),
            fit: BoxFit.none,
          ),
        ),
        alignment: Alignment.center,
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
            MyBottomSheet(
              //key: OZKeys.ozKey2,
              searchedThomb: theThomb,
              hasLocationInfo: true,
              routeNotDrawn: !routeDrawn,
              distance: 0.0,
              turnType: '',
            ),
          ],
        ), //_gkey yerine key vardı
        /*child: ElevatedButton(
          child: Text("Close Bottom Sheet"),
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.yellow.shade800,
            primary: Colors.green,
          ),
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),*/
      );
    });
  }*/

  int distanceBetweenTwoPoints(LatLng A, LatLng B) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((B.latitude - A.latitude) * p) / 2 +
        c(A.latitude * p) *
            c(B.latitude * p) *
            (1 - c((B.longitude - A.longitude) * p)) /
            2;
    return (1000 * 12742 * asin(sqrt(a))).round();
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    LatLng centerPoint = LatLng(46.7505, -100.8501);
    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentPosition != null) {
      currentLatLng =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    } else {
      currentLatLng = LatLng(46.75215, -100.85175);
    }

    List<OverlayImage> overlayImages = <OverlayImage>[
      OverlayImage(
        bounds: LatLngBounds(
            LatLng(46.752445, -100.85303), LatLng(46.74931, -100.84780)),
        //LatLng(46.752455, -100.85251), LatLng(46.74931, -100.84780)),
        //LatLng(46.75282, -100.85306), LatLng(46.74893, -100.84698)),
        opacity: 1.0,
        imageProvider: AssetImage('assets/images/VetCemOutline.png'),
      ),
    ];

    /*Marker introMarker = Marker(
      point: LatLng(46.7497937, -100.8512642),
      builder: (ctx) {
        return OverlayTooltipItem(
          displayIndex: 3,
          tooltip: (controller) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: MTooltip(
              title: 'Grave Stone',
              controller: controller,
              description: 'Grave stone of the Veteran.',
            ),
          ),
          tooltipVerticalPosition: TooltipVerticalPosition.TOP,
          child: IconButton(
            icon: Image.asset('assets/icons/Headstone.png'),
            color: Colors.white,
            onPressed: () {},
          ),
        );
      },
    );*/

    List<Marker> tappedPointMarker = targetPoint.map((latlng) {
      return Marker(
        width: 120.0,
        height: 194.16,
        point: latlng,
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (ctx) => GestureDetector(
          //Yer işaretinin üzerine tıklandığında alt sayfayı göster.
          onTap: () {
            showTappedMarker = true;
            routeDrawn = true;
            displayBottomSheet();
          },
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/icons/markerusflag.jpg',
              width: 50,
              height: 50,
            ),
            //opacity: infoWindowVisible ? 0.0 : 1.0,
          ),
          //child: _buildCustomMarker(showTappedMarker),
        ) /*GestureDetector(
          onTap: () {
            setState(() {
              if (key.currentState != null &&
                  (key.currentState as CustomPopupState)
                      .controller
                      .value
                      .isPlaying) {
                (key.currentState as CustomPopupState).controller.pause();
                (key.currentState as CustomPopupState).playerIcon =
                    Icons.play_arrow;
              }
              //infoWindowVisible = !infoWindowVisible;
            });
          },
          child: _buildCustomMarker(showTappedMarker),
        )*/
        ,
      );
    }).toList();

    //Eğer yeni bir odak seviyesinin (ZoomLevel) üstünde var mezar taşı simgelerinin boyutlarını yeni seviyeye göre ayarla.
    if (newZoomLevel?.isNaN == false) {
      if (newZoomLevel! > 18.5) {
        List<Marker> thombMarkers = allthombs.map((thomb) {
          double mysize = 0.0;

          if (newZoomLevel!.isNaN) {
            mysize = 1.0;
          } else {
            mysize = (newZoomLevel! - 16) * (newZoomLevel! - 16.5);
            //print(mysize.toString());
          } /*else if (newZoomLevel! <= 16.88) {
            mysize = 1.5;
          } else if (newZoomLevel! <= 17.88) {
            mysize = 2.5;
          } else if (newZoomLevel! <= 18.88) {
            mysize = 5.0;
          } else if (newZoomLevel! <= 19.88) {
            mysize = 10.0;
          } else if (newZoomLevel! <= 20.88) {
            mysize = 18.0;
          } else {
            mysize = 24.0;
          }*/
          //double x = 0.0;
          /*if(distanceBetweenTwoPoints(thomb._coordinates, targetPoint.lastWhere((element) => true)) < 100) {
            
          }*/
          /*if (thomb._coordinates.latitude <
                  _mapController.bounds!.northEast!.latitude - x &&
              thomb._coordinates.longitude <
                  _mapController.bounds!.northEast!.longitude - x &&
              thomb._coordinates.latitude >
                  _mapController.bounds!.southWest!.latitude + x &&
              thomb._coordinates.longitude >
                  _mapController.bounds!.southWest!.longitude + x) {*/
          return Marker(
            width: mysize,
            height: mysize,
            point: thomb._coordinates,
            builder: (ctx) => GestureDetector(
              //Yer işaretinin üzerine tıklandığında alt sayfayı göster.
              onTap: () {
                _handleMarkerTap(thomb.coordinates);
                /*setState(() {
                  tappedHeadstone = Marker(
                    width: mysize,
                    height: mysize,
                    point: thomb._coordinates,
                    builder: (ctx) => GestureDetector(
                      //Yer işaretinin üzerine tıklandığında alt sayfayı göster.
                      onTap: () {
                        _handleMarkerTap(thomb.coordinates);
                      },
                      child: Image.asset(
                        'assets/icons/Headstone.png',
                        width: 10,
                        height: 50,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.none,
                        color: Colors.blue,
                      ),
                      //       Icon(Icons.remove, color: Colors.white),
                    ),
                  );
                  _route.clear();
                  RouteSigns.clear();
                  targetPoint.clear();
                });*/
              },
              child: Image.asset(
                'assets/icons/Headstone.png',
                width: 10,
                height: 50,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.none,
                color: Colors.white,
              ),
              //       Icon(Icons.remove, color: Colors.white),
            ),
          );
          /*} else {
            return Marker(
              width: mysize,
              height: mysize,
              point: thomb._coordinates,
              builder: (ctx) => GestureDetector(
                //Yer işaretinin üzerine tıklandığında alt sayfayı göster.
                onTap: () {
                  _handleMarkerTap(thomb.coordinates);
                  setState(() {
                    tappedHeadstone = Marker(
                      width: 0,
                      height: 0,
                      point: thomb._coordinates,
                      builder: (ctx) => GestureDetector(
                        //Yer işaretinin üzerine tıklandığında alt sayfayı göster.
                        onTap: () {
                          _handleMarkerTap(thomb.coordinates);
                        },
                        child: Image.asset(
                          'assets/icons/Headstone.png',
                          width: 10,
                          height: 50,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.none,
                          color: Colors.blue,
                        ),
                        //       Icon(Icons.remove, color: Colors.white),
                      ),
                    );
                    _route.clear();
                    RouteSigns.clear();
                    targetPoint.clear();
                  });
                },
                child: Image.asset(
                  'assets/icons/Headstone.png',
                  width: 10,
                  height: 50,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.none,
                ),
                //       Icon(Icons.remove, color: Colors.white),
              ),
            );
          }*/
        }).toList();

        //if (newZoomLevel.isNaN == false) {
        tappedPointMarker =
            tappedPointMarker + thombMarkers + [tappedHeadstone];
      } else {
        List<Marker> sectionMarkers = sectionPoints.map((list) {
          return Marker(
            width: MediaQuery.of(context).size.width * 0.06,
            height: MediaQuery.of(context).size.height * 0.03,
            point: list[0],
            builder: (ctx) => GestureDetector(
              child: Image.asset(
                'assets/icons/' + list[1] + '.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.none,
              ),
              //       Icon(Icons.remove, color: Colors.white),
            ),
          );
        }).toList();
        tappedPointMarker = tappedPointMarker + sectionMarkers;
      }
    }

    // Eğer seçilen nokta işareti gösterilecek, seçilen noktaya ait enlem boylam verisi dolu ve harita serbest durumda değilse haritayı kaynak ve hedef noktaların ortasına odakla.
    if (showTappedMarker && targetPoint.isNotEmpty && freeMap == true) {
      _route.length > 1
          ? _route.removeAt(0)
          : null; //İlk konumu güzergahtan çıkar.
      _route.insert(0, currentLatLng); //Yeni konumu güzergahın başına ekle.

      var distance = distanceBetweenTwoPoints(currentLatLng, targetPoint[0]);
      var focusTo = LatLng(
          (currentLatLng.latitude + targetPoint[0].latitude) / 2,
          (currentLatLng.longitude + targetPoint[0].longitude) / 2);

      var addZoom = -0.25;
      if (200 < distance) {
        _mapController.move(centerPoint, 17 + addZoom);
      } else if (190 < distance && distance <= 200) {
        _mapController.move(focusTo, 17 + addZoom);
      } else if (180 < distance && distance <= 190) {
        _mapController.move(focusTo, 17.15 + addZoom);
      } else if (170 < distance && distance <= 180) {
        _mapController.move(focusTo, 17.30 + addZoom);
      } else if (160 < distance && distance <= 170) {
        _mapController.move(focusTo, 17.45 + addZoom);
      } else if (150 < distance && distance <= 160) {
        _mapController.move(focusTo, 17.60 + addZoom);
      } else if (140 < distance && distance <= 150) {
        _mapController.move(focusTo, 17.75 + addZoom);
      } else if (130 < distance && distance <= 140) {
        _mapController.move(focusTo, 17.90 + addZoom);
      } else if (120 < distance && distance <= 130) {
        _mapController.move(focusTo, 18.05 + addZoom);
      } else if (110 < distance && distance <= 120) {
        _mapController.move(focusTo, 18.20 + addZoom);
      } else if (100 < distance && distance <= 110) {
        _mapController.move(focusTo, 18.35 + addZoom);
      } else if (90 < distance && distance <= 100) {
        _mapController.move(focusTo, 18.50 + addZoom);
      } else if (80 < distance && distance <= 90) {
        _mapController.move(focusTo, 18.65 + addZoom);
      } else if (70 < distance && distance <= 80) {
        _mapController.move(focusTo, 18.80 + addZoom);
      } else if (60 < distance && distance <= 70) {
        _mapController.move(focusTo, 18.95 + addZoom);
      } else if (50 < distance && distance <= 60) {
        _mapController.move(focusTo, 19.10 + addZoom);
      } else if (40 < distance && distance <= 50) {
        _mapController.move(focusTo, 19.25 + addZoom);
      } else if (30 < distance && distance <= 40) {
        _mapController.move(focusTo, 19.40 + addZoom);
      } else if (20 < distance && distance <= 30) {
        _mapController.move(focusTo, 19.55 + addZoom);
      } else if (10 < distance && distance <= 20) {
        _mapController.move(focusTo, 19.70 + addZoom);
      } else if (distance < 10) {
        _mapController.move(focusTo, 19.85 + addZoom);
      }
    }

    //Eğer harita sayfasına başka bir sayfadan güzergah çizdirmek için geldiyse (routeDrawn değişkeni false ise durumun bu olduğu var sayılmakta) diğer sayfadan gelen widget bilgisi üzerinden (aranan mezarlık konumu) güzergah çizdir.
    /*if (routeDrawn == false) {
      if (widget.searchedThomb != null) {
        if (widget.searchedThomb!.coordinates != LatLng(0.0, 0.0)) {
          if (widget.searchedThomb!.coordinates.latitude != '' &&
              widget.searchedThomb!.coordinates.latitude != 0.0 &&
              widget.searchedThomb!.coordinates.longitude != '' &&
              widget.searchedThomb!.coordinates.longitude != 0.0) {
            targetPoint = [widget.searchedThomb!.coordinates];
            print("BUILD İÇİNDEN");
            fetchRoute(searchedPoint: widget.searchedThomb?.coordinates);
          } else if (routeDrawn == true) {
            print('Coordinate information of the veteran does not exist.');
          }
        } else if (routeDrawn == true) {
          print('Coordinate information of the veteran does not exist.');
        }
      } else if (routeDrawn == true) {
        print('Coordinate information of the veteran does not exist.');
      }
    }*/

    return /*WillPopScope(
      onWillPop: () async {
        Intro intro = Intro.of(context);

        if (intro.status.isOpen == true) {
          intro.dispose();
          return false;
        }
        return true;
      },
      child: */
        OverlayTooltipScaffold(
      // overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: _controller,
      startWhen: (initializedWidgetLength) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return await IsFirstRun
            .isFirstCall(); //initializedWidgetLength == 3 && !done;*/
      },
      builder: (context) => Scaffold(
        key: _gkeyS,
        appBar: AppBar(
          leading: /*IntroStepBuilder(
            order: 3,
            overlayBuilder: (params) {
              return Column(
                children: [
                  Text(
                    'As you can see, you can move on to the next step',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      children: [
                        IntroButton(
                          text: 'Prev',
                          onPressed: params.onPrev,
                        ),
                        IntroButton(
                          text: 'Next',
                          onPressed: params.onNext,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            onHighlightWidgetTap: () {
              setState(() {
                rendered = true;
              });
            },
            builder: (context, _gkey3) => */
              OverlayTooltipItem(
            displayIndex: 1,
            tooltip: (controller) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: MTooltip(
                title: 'Menu',
                controller: controller,
                description: 'List of available functions',
              ),
            ),
            tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
            child: IconButton(
              onPressed: () => _gkeyS.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: Colors.yellow.shade800,
                //key: _gkey3,
              ),
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255, 0, 19, 61),
          title: customSearchBar,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchVeteranForm(
                              title: 'ND Veterans Cemetery',
                            )),
                  );
                  /*if (customIcon.icon == Icons.search) {
                  customIcon =
                      Icon(Icons.cancel, color: Colors.yellow.shade800);
                  customSearchBar = ListTile(
                    leading: IconButton(
                      onPressed: () async {
                        await searchVeteran(_searchTextFieldController.text);
                        print(theThomb.surname);
                        displayBottomSheet();
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.yellow.shade800,
                        size: 28,
                      ),
                    ),
                    title: searchTextField,
                  );
                } else {
                  customIcon =
                      Icon(Icons.search, color: Colors.yellow.shade800);
                  customSearchBar = Text(
                    'Mandan, ND - Veterans Cemetery',
                    style:
                        TextStyle(fontSize: 18, color: Colors.yellow.shade800),
                  );
                }*/
                });
              },
              icon: customIcon,
            )
          ],
          centerTitle: true,
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.values[0],
          children: [
            /*Container(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: FloatingActionButton(
                heroTag: 'Reset',
                onPressed: () async => await IsFirstRun.reset(),
                child: Icon(Icons.reset_tv),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: FloatingActionButton(
                heroTag: 'Zoom In',
                onPressed: () => _mapController.move(
                    _mapController.center, _mapController.zoom + 0.5),
                child: Icon(Icons.zoom_in),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: FloatingActionButton(
                heroTag: 'Zoom Out',
                onPressed: () => _mapController.move(
                    _mapController.center, _mapController.zoom - 0.5),
                child: Icon(Icons.zoom_out),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: FloatingActionButton(
                heroTag: 'Free Map',
                onPressed: () => setState(() {
                  freeMap ? freeMap = false : freeMap = true;
                  /*_mapController.fitBounds(LatLngBounds(
                      LatLng(46.752438, -100.852893),
                      LatLng(46.748916, -100.847626)));*/
                }),
                child: Icon(Icons.location_disabled),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: FloatingActionButton(
                heroTag: 'Live Location',
                onPressed: () {
                  setState(() {
                    _liveUpdate = !_liveUpdate;
                    //Canlı konum takibinde etkileşimli haritayı kısıtla.
                    /*if (_liveUpdate) {
                      interActiveFlags = InteractiveFlag.pinchZoom |
                          InteractiveFlag.doubleTapZoom;

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'In live update mode only zoom and rotation are enable'),
                      ));
                    } else {
                      interActiveFlags = InteractiveFlag.all;
                    }*/
                  });
                },
                child: _liveUpdate
                    ? Icon(Icons.location_on)
                    : Icon(Icons.location_off),
              ),
            ),*/
          ],
        ),
        drawer: Container(
          //padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width * 0.70,
          child: buildDrawer(context, LiveLocationPage.route),
        ),
        body: Stack(
          children: [
            //Column(
            //children: [
            /*Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: _serviceError!.isEmpty
                  ? Text('This is a map that is showing '
                      '(${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                  : Text(
                      'Error occured while acquiring location. Error Message : '
                      '$_serviceError'),
            ),*/
            //Flexible(
            //children: [
            FlutterMap(
              nonRotatedChildren: [
                /*AttributionWidget.defaultWidget(
                  source: '© OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),*/
              ],
              mapController: _mapController,
              options: MapOptions(
                center: centerPoint,
                zoom: 16.95,
                minZoom: 16.50,
                maxZoom: 23.0,
                slideOnBoundaries: true,
                /*maxBounds: LatLngBounds(LatLng(46.752438, -100.852893),
                    LatLng(46.748916, -100.847626)),*/
                interactiveFlags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom |
                    InteractiveFlag.drag,
                onTap: (tapPosition, point) {
                  tappedHeadstone = Marker(
                    width: 0,
                    height: 0,
                    point: LatLng(0, 0),
                    builder: (ctx) => GestureDetector(
                      child: Image.asset(
                        'assets/icons/Headstone.png',
                        width: 0,
                        height: 0,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.none,
                      ),
                      //       Icon(Icons.remove, color: Colors.white),
                    ),
                  );
                  //showTappedMarker = showTappedMarker ? false : true;
                },
                onLongPress: _handleLongPress,
                onPositionChanged: (position, hasGesture) {
                  // Fill your stream when your position changes
                  final zoom = position.zoom;
                  if (zoom != null) {
                    _streamController.sink.add(zoom);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  //Google Maps
                  /*'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],*/
                  // For example purposes. It is recommended to use
                  // TileProvider with a caching and retry strategy, like
                  // NetworkTileProvider or CachedNetworkTileProvider
                  //tileProvider: NonCachingNetworkTileProvider(),
                ),
                OverlayImageLayer(overlayImages: overlayImages),
                PolylineLayer(
                  polylines: [
                    Polyline(
                        points: _route,
                        strokeWidth: 4.0,
                        color: Colors.blueAccent),
                  ],
                ),
                MarkerLayer(
                  markers: [
                        Marker(
                          point: currentLatLng,
                          //rotateAlignment: Alignment.bottomCenter,
                          builder: (ctx) =>
                              _MyLocationMarker(_animationController),
                        ),
                      ] +
                      tappedPointMarker +
                      //[introMarker] +
                      (displayRouteSigns ? RouteSigns : []),
                ),
              ],
            ),
          ],
        ),
        //],
        //),
        //],
        //),
        //bottomSheet: BottomSheet(),
        /*floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              _liveUpdate = !_liveUpdate;

              if (_liveUpdate) {
                interActiveFlags = InteractiveFlag.rotate |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'In live update mode only zoom and rotation are enable'),
                ));
              } else {
                interActiveFlags = InteractiveFlag.all;
              }
            });
          },
          child:
              _liveUpdate ? Icon(Icons.location_on) : Icon(Icons.location_off),
        );
      }),*/
      ),
    );
  }
}

class Thomb {
  late String _name = "";
  late String _middlename = "";
  late String _surname = "";
  late String _rank = "";
  late String _branch = "";
  late String _duty = "";
  late String _medals = "";
  late String _section = "";
  late LatLng _coordinates = LatLng(0, 0);
  late String _description = "";
  late List<String> _images = [];
  late List<String> _videos = [];
  late Marker marker;
  late String _row;

  Thomb() {
    _name = "";
    _middlename = "";
    _surname = "";
    _rank = "";
    _branch = "";
    _duty = "";
    _medals = "";
    _section = "";
    _coordinates = LatLng(0.0, 0.0);
    _description = "";
    _images = <String>[];
    _videos = <String>[];
    //marker = Marker(point: _coordinates, builder: ()=>print();));
    _row = "";
  }

  /*marker = Marker(
              width: 30,
              height: 30,
              point: this._coordinates,
              builder: (ctx) => GestureDetector(
                //Yer işaretinin üzerine tıklandığında alt sayfayı göster.
                onTap: () {
                  _handleMarkerTap(thomb._coordinates);
                },
                child: Image.asset(
                  'assets/icons/Headstone.png',
                  width: 10,
                  height: 50,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.none,
                ),
                //       Icon(Icons.remove, color: Colors.white),
              ),
            );*/

  String get name => _name;
  String get middlename => _middlename;
  String get surname => _surname;
  String get rank => _rank;
  String get branch => _branch;
  String get duty => _duty;
  String get medals => _medals;
  String get section => _section;
  LatLng get coordinates => _coordinates;
  String get description => _description;
  List<String> get images => _images;
  List<String> get videos => _videos;
  String get row => _row;

  void set name(name) {
    _name = name;
  }

  void set middlename(middlename) {
    _middlename = middlename;
  }

  void set surname(surname) {
    _surname = surname;
  }

  void set rank(rank) {
    _rank = rank;
  }

  void set branch(branch) {
    _branch = branch;
  }

  void set duty(duty) {
    _duty = duty;
  }

  void set medals(medals) {
    _medals = medals;
  }

  void set section(section) {
    _section = section;
  }

  void set coordinates(point) {
    _coordinates = point;
  }

  void set description(description) {
    if (description is String) {
      _description = description;
    } else {
      _description = description[0];
    }
    //if (description.length > 0) {
    //  _description = description[0];
    //} else {
    //_description = description;
    //}
  }

  void set images(images) {
    _images = images;
  }

  void set videos(videos) {
    _videos = videos;
  }

  void set row(row) {
    _row = row;
  }

  void clear() {
    _name = "";
    _middlename = "";
    _surname = "";
    _rank = "";
    _branch = "";
    _duty = "";
    _medals = "";
    _section = "";
    _coordinates = LatLng(0, 0);
    _description = "";
    _images = [];
    _videos = [];
    _row = "";
  }
}

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    //final newValue = lerpDouble(0.5, 1.0, value);
    final size = 20.0;
    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.6),
                /*border: Border.all(
                  color: Colors.white,
                ),*/
              ),
            ),
          ),
          OverlayTooltipItem(
            displayIndex: 2,
            tooltip: (controller) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: MTooltip(
                title: 'Your Location',
                controller: controller,
                description: 'Displays your current location.',
              ),
            ),
            tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
            child: Center(
              child: Container(
                height: size / 1.63 + value * 4.9, // value değişken, size sabit
                width: size / 1.63 + value * 4.9, // value değişken, size sabit
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RouteSign {
  late final distance;
  late final description;
  RouteSign(dist, desc) {
    this.distance = dist;
    this.description = desc;
  }
}
