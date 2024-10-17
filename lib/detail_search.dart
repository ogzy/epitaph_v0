import 'dart:convert';
import 'package:epitaph_v0/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'list_veterans.dart';

// Define a custom Form widget.
class DetSearchVeteranPage extends StatefulWidget {
  const DetSearchVeteranPage({Key? key}) : super(key: key);

  @override
  DetFormState createState() {
    return DetFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class DetFormState extends State<DetSearchVeteranPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _midnameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _dobmonthController = TextEditingController();
  TextEditingController _dobdayController = TextEditingController();
  TextEditingController _dobyearController = TextEditingController();
  TextEditingController _dodmonthController = TextEditingController();
  TextEditingController _doddayController = TextEditingController();
  TextEditingController _dodyearController = TextEditingController();
  TextEditingController _sectionController = TextEditingController();
  TextEditingController _numController = TextEditingController();
  TextEditingController _toursController = TextEditingController();
  TextEditingController _medalsController = TextEditingController();

  String selectedBranch = 'Select an option';
  var branches = [
    'Select an option',
    'US Army',
    'US Navy',
    'US Air Force',
    'US Marine Corps',
    'Army Air Corps',
    'ARNG',
    'NDANG'
  ];

  String selectedRank = 'Rank';
  var ranks = ['Rank', 'Cpl', 'SSG', 'PFC', 'A1C', 'ET-1', 'PV2'];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 0, 19, 61),
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
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchVeteranForm(
                            title: 'ND Veterans Cemetery',
                          )),
                );
              });
            },
            icon: Icon(
              Icons.home,
              color: Colors.yellow.shade800,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.08,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.08,
              MediaQuery.of(context).size.height * 0.056),
          //height: MediaQuery.of(context).size.height * 0.678,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 19, 61),
            image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage('assets/icons/logoOverlay20x.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  child: Text(
                    'LOCATE HEADSTONE',
                    style: TextStyle(
                      color: Color.fromARGB(255, 194, 149, 36),
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.013,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Text(
                  'For best results search using first and last name.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.012,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                // Add TextFormFields and ElevatedButton here.
                Container(
                  height: MediaQuery.of(context).size.height * 0.056,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the First Name or Date of Death.';
                      }
                      return null;
                    },
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.4),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                      ),
                      hintText: 'First Name*',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    // The validator receives the text that the user has entered.
                    /*validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'FirstName';
                      }
                      return null;
                    },*/
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  height: MediaQuery.of(context).size.height * 0.056,
                  child: TextFormField(
                    controller: _midnameController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.4),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                      ),
                      hintText: 'Middle Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  height: MediaQuery.of(context).size.height * 0.056,
                  child: TextFormField(
                    controller: _surnameController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.4),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                      ),
                      hintText: 'Last Name*',
                      border: InputBorder.none,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'DATE OF BIRTH',
                  style: TextStyle(
                    color: Color.fromARGB(255, 194, 149, 36),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.013,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.16,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _dobmonthController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'MM',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.16,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _dobdayController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'DD',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _dobyearController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'YYYY',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'DATE OF DEATH',
                  style: TextStyle(
                    color: Color.fromARGB(255, 194, 149, 36),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.013,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.16,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _dodmonthController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'MM',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.16,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _doddayController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'DD',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _dodyearController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'YYYY',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'BRANCH OF SERVICE',
                  style: TextStyle(
                    color: Color.fromARGB(255, 194, 149, 36),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.013,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey
                        .withOpacity(0.4), //background color of dropdown button
                    /*border: Border.all(
                        color: Colors.black38,
                        width: 3), //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        0), //border raiuds of dropdown button
                    boxShadow: <BoxShadow>[
                        //apply shadow on Dropdown button
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.57), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ],*/
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton(
                      isExpanded: true,
                      //iconEnabledColor: Colors.white,
                      dropdownColor: Colors.blueGrey.withOpacity(0.9),
                      value: selectedBranch,
                      hint: Text(
                        'Select an option',
                        //selectionColor: Colors.red,
                        //style: TextStyle(
                        //  color: Colors.red.withOpacity(0.9),
                        //),
                      ),
                      icon: Icon(Icons.keyboard_arrow_down),
                      style: TextStyle(color: Colors.grey),
                      underline: Container(
                        height: 0,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBranch = newValue!;
                        });
                      },
                      items: branches.map((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'LOCATION',
                  style: TextStyle(
                    color: Color.fromARGB(255, 194, 149, 36),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.013,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _sectionController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'Section',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _numController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'Number',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'HONORS',
                  style: TextStyle(
                    color: Color.fromARGB(255, 194, 149, 36),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.013,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(
                              0.4), //background color of dropdown button
                          /*border: Border.all(
                        color: Colors.black38,
                        width: 3), //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        0), //border raiuds of dropdown button
                    boxShadow: <BoxShadow>[
                        //apply shadow on Dropdown button
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.57), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ],*/
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.01,
                              right: MediaQuery.of(context).size.width * 0.01),
                          child: DropdownButton(
                            isExpanded: true,
                            //iconEnabledColor: Colors.white,
                            dropdownColor: Colors.blueGrey.withOpacity(0.9),
                            value: selectedRank,
                            hint: Text(
                              'Rank',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            icon: Icon(Icons.keyboard_arrow_down),
                            style: TextStyle(color: Colors.grey),
                            underline: Container(
                              height: 0,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            onChanged: (String? newRank) {
                              setState(() {
                                selectedRank = newRank!;
                              });
                            },
                            items: ranks.map((String value) {
                              return DropdownMenuItem(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.27,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _toursController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'Tours',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.height * 0.056,
                      child: TextFormField(
                        controller: _medalsController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey,
                          ),
                          hintText: 'Medals',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Searching the Veteran...')),
                      );
                      String dobDelimeter;
                      String dodDelimeter;

                      // Tarihler boşsa aradaki - işaretini API'ye gönderme
                      (_dobyearController.text +
                                      _dobmonthController.text +
                                      _dobdayController.text)
                                  .toString()
                                  .length >
                              0
                          ? dobDelimeter = '-'
                          : dobDelimeter = '';

                      (_dodyearController.text +
                                      _dodmonthController.text +
                                      _doddayController.text)
                                  .toString()
                                  .length >
                              0
                          ? dodDelimeter = ''
                          : dodDelimeter = '';

                      final response = await http.get(Uri.parse(
                          'http://www.nevalan.site/demo/index.php?route=api/veteran/namedeathFilter&name=' +
                              _nameController.text.trim() +
                              '&section=' +
                              _sectionController.text.trim() +
                              '&number=' +
                              _numController.text.trim() +
                              '&branch=' +
                              (selectedBranch == //Branch seçilmediyse boş gönder.
                                      'Select an option'
                                  ? ''
                                  : selectedBranch) +
                              '&rank=' +
                              (selectedRank == //Rank seçilmediyse boş gönder.
                                      'Rank'
                                  ? ''
                                  : selectedRank) +
                              '&tour=' +
                              _toursController.text.trim() +
                              '&medals=' +
                              _medalsController.text.trim() +
                              '&birth=' +
                              _dobyearController.text.trim() +
                              dobDelimeter +
                              _dobmonthController.text.trim() +
                              dobDelimeter +
                              _dobdayController.text.trim() +
                              dobDelimeter +
                              _dodyearController.text.trim() +
                              dodDelimeter +
                              _dodmonthController.text.trim() +
                              dodDelimeter +
                              _doddayController.text.trim()));

                      if (response.statusCode == 200) {
                        //API başarıyla döndüyse
                        if (jsonDecode(response.body).isNotEmpty) {
                          Map<String, dynamic> map = jsonDecode(response.body);
                          var user_list = [];
                          map.forEach((key, value) => user_list.add(value));

                          if (map.length > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ListVeterans(veteranlist: user_list),
                              ),
                            );
                          } else {
                            print('Empty Map');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'No match found. Please try anaother name.'),
                          ));
                        }
                      } else {
                        print("object");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Connection problem. Please check your internet connection.'),
                        ));
                      }
                    }
                  },
                  child: Text(
                    'SEARCH',
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 0, 19, 61), // Set text color to grey
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 194, 149, 36),
                    minimumSize: Size(
                      double.infinity,
                      MediaQuery.of(context).size.height * 0.056,
                    ), // <--- this line helped me
                  ),
                ),
              ],
            ),
          ),
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
