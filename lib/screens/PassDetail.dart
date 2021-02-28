import 'package:flutter/material.dart';
import 'Password.dart';
import 'database_helper.dart';
import 'dart:math';
import 'package:clipboard/clipboard.dart';

class PassDetail extends StatefulWidget {
  final String appBarTitle;
  final Password pass;
  PassDetail(this.pass, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return PassDetailState(this.pass, this.appBarTitle);
  }
}

class PassDetailState extends State<PassDetail> {
  DatabaseHelper helper = DatabaseHelper();
  Password pass;
  String appBarTitle;
  PassDetailState(this.pass, this.appBarTitle);
  TextEditingController titleController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static final String ALPHA_CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static final String ALPHA = "abcdefghijklmnopqrstuvwxyz";
  static final String NUMERIC = "0123456789";
  static final String SPECIAL_CHARS = "!@#%^&*_=+-/";

  var random = new Random();

  void updateTitle() {
    pass.title = titleController.text;
  }

  void updateUsername() {
    pass.username = usernameController.text;
  }

  void updatePassword() {
    pass.password = passwordController.text;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _save() async {
    moveToLastScreen();

    int result;
    if (pass.id != null) {
      result = await helper.updatePass(pass);
    } else {
      result = await helper.insertPass(pass);
    }

    if (result != 0) {
      _showAlertDialog("Status", "Password Saved Successfully");
    } else {
      _showAlertDialog("Status", "Problem Saving Password");
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _delete() async {
    moveToLastScreen();
    if (pass.id == null) {
      _showAlertDialog("status", "First Add A Password");
      return;
    }

    int result = await helper.deletePass(pass.id);
    if (result != 0) {
      _showAlertDialog("Status", "Password Deleted Successfully");
    } else {
      _showAlertDialog("Status", "Problem Deleting Password");
    }
  }

  String generatePassword(int len, String dic) {
    String result = "";
    for (int i = 0; i < len; i++) {
      int index = random.nextInt(dic.length);
      result += dic[index];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = pass.title;
    usernameController.text = pass.username;
    passwordController.text = pass.password;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.cyanAccent,
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: moveToLastScreen,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      icon: Icon(Icons.title),
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: TextField(
                    controller: usernameController,
                    style: textStyle,
                    onChanged: (value) {
                      updateUsername();
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      icon: Icon(Icons.details),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          style: textStyle,
                          onChanged: (value) {
                            updatePassword();
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.details),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () async {
                          await FlutterClipboard.copy(passwordController.text);

                          Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('✓   Copied to Clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.green,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Generate',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      String genPass = generatePassword(
                          13, ALPHA_CAPS + ALPHA + NUMERIC + SPECIAL_CHARS);
                      passwordController.value = TextEditingValue(
                          text: genPass,
                          selection: TextSelection.fromPosition(
                              TextPosition(offset: genPass.length)));
                      updatePassword();
                      debugPrint(genPass);
                    },
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Save',
                            textScaleFactor: 2.0,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Delete',
                            textScaleFactor: 2.0,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
