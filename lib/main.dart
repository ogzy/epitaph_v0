import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';
import 'list_veterans.dart';
import 'history.dart';
import 'map.dart';
import 'welcome.dart';
//import 'donate.dart';
import 'aboutus.dart';
import 'detail_search.dart';

void main() => runApp(
      /*Intro(
      openToModification: false,

      padding: const EdgeInsets.all(8),

      /// Border radius of the highlighted area
      borderRadius: BorderRadius.all(Radius.circular(4)),

      /// The mask color of step page
      maskColor: const Color.fromRGBO(0, 0, 0, .6),

      /// No animation
      noAnimation: false,

      /// Click on whether the mask is allowed to be closed.
      maskClosable: false,

      /// Custom button text
      //buttonTextBuilder: (order) => order == 6 ? 'Custom Button Text' : 'Next',
      child: */
      MyApp(), /*)*/
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ND Veterans Cemetery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
      ),
      home: SearchVeteranForm(title: 'ND Veterans Cemetery Home Page'),
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

// Define a custom Form widget.
class SearchVeteranForm extends StatefulWidget {
  const SearchVeteranForm({Key? key, required String title}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<SearchVeteranForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
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
            fontSize: MediaQuery.of(context).size.height * 0.0188,
          ),
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.yellow.shade800,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Container(
        //padding: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width * 0.70,
        child: buildDrawer(context, LiveLocationPage.route),
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/images/MainBackground.jpg",
              height: MediaQuery.of(context).size.height * 0.42,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            /*Align(
              //heightFactor: 1.0,
              alignment: Alignment.topCenter,
              child: */
            Container(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,
                0,
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.width * 0.1,
              ),
              height: MediaQuery.of(context).size.height * 0.458,
              width: double.infinity,
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.red),
                image: DecorationImage(
                  scale: 1,
                  alignment: Alignment.center,
                  colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.95),
                    BlendMode
                        .dstIn, // Bu dstIn olmazsa arka planda bir önceki renk girdisinde belirtilen renk çıkoyor.
                  ),
                  image: AssetImage('assets/icons/logoOverlay20x.png'),
                  fit: BoxFit.contain,
                  //centerSlice: Rect.fromLTRB(0.0, 0.0, 10.0, 10.0),
                ),
                color: Color.fromARGB(255, 0, 19, 61).withOpacity(0.8),
              ),
              child: Stack(
                alignment: Alignment.center,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Image(
                    //width: MediaQuery.of(context).size.width * 19,
                    image: AssetImage('assets/icons/notch.png'),
                  ),*/
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'QUICK SEARCH',
                          style: TextStyle(
                            color: Color.fromARGB(255, 194, 149, 36),
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.032,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        // Add TextFormFields and ElevatedButton here.
                        Wrap(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.4),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 194, 149, 36),
                                  ),
                                ),
                                /*enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 194, 149, 36),
                                    ),
                                  ),*/
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                                hintText: 'FIRST NAME',
                                //suffixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(18),
                              ),
                              // The validator receives the text that the user has entered.
                              /*validator: (name) {
                                if (name == null || name.isEmpty) {
                                  return 'Name';
                                }
                                return null;
                              },*/
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.09),
                            Theme(
                              data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent,
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: _surnameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.4),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 194, 149, 36),
                                    ),
                                  ),
                                  /*enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 194, 149, 36),
                                      ),
                                    ),*/
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                  ),
                                  hintText: 'LAST NAME',
                                  //suffixIcon: Icon(Icons.search),
                                  //border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(18),
                                ),
                                // The validator receives the text that the user has entered.
                                /*validator: (surname) {
                          if (surname == null || surname.isEmpty) {
                            return 'Surname';
                          }
                          return null;
                        },*/
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Color.fromARGB(255, 194, 149, 36),
                              ),
                            ),
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Searching the Veteran...')),
                                );
                                var asd = Uri.parse(
                                    'http://www.nevalan.site/demo/index.php?route=api/veteran/namesurnameFilter&name=' +
                                        _nameController.text.trim() +
                                        '&surname=' +
                                        _surnameController.text.trim() +
                                        '&midname=');
                                final response = await http.get(asd);

                                if (response.statusCode == 200) {
                                  //API başarıyla döndüyse
                                  if (jsonDecode(response.body).isNotEmpty) {
                                    Map<String, dynamic> map =
                                        jsonDecode(response.body);
                                    var user_list = [];
                                    map.forEach(
                                        (key, value) => user_list.add(value));

                                    if (map.length > 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ListVeterans(
                                              veteranlist: user_list),
                                        ),
                                      );
                                    } else {
                                      print('Empty Map');
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'No match found. Please try anaother name.'),
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Connection problem. Please check your internet connection.'),
                                  ));
                                }
                              }
                            },
                            child: Text(
                              'SEARCH',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 19, 61),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //),
          ],
        ),
      ),
    );
  }

  /*Future<List> _searchVeteranName(name, surname) async {
    final response = await http.get(Uri.parse(
        'http://www.nevalan.xyz/demo/index.php?route=api/veteran/namesurnameFilter&name=' +
            name +
            '&surname=' +
            surname +
            '&midname='));

    if (response.statusCode == 200) {
      //API başarıyla döndüyse
      if (jsonDecode(response.body).length > 0) {
        return jsonDecode(response.body)['veteran_namesurname_details'];
      } else {
        throw NullThrownError();
      }
    } else {
      throw NullThrownError();
    }
  }*/
}
