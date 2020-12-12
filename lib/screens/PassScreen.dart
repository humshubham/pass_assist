import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'Password.dart';
import 'database_helper.dart';
import 'PassDetail.dart';

class PassScreen extends StatefulWidget {
  @override
  _PassScreenState createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  @override
  void initState() {
    super.initState();
    updateListView();
  }

  static Color mainUiColor = Color(0xFFb92b27);
  List<Password> passList;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Manager"),
        backgroundColor: mainUiColor,
        centerTitle: true,
      ),
      body: getPassListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainUiColor,
        child: Icon(Icons.add),
        onPressed: () {
          navigateToDetail(Password('', '', ''), 'Add Password');
        },
      ),
    );
  }

  void navigateToDetail(Password pass, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PassDetail(pass, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Password>> passListFuture = databaseHelper.getPassList();
      passListFuture.then((passList) {
        setState(() {
          this.passList = passList;
          this.count = passList.length;
        });
      });
    });
  }

  ListView getPassListView() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, position) {
        return Dismissible(
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40.0,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40.0,
              ),
            ),
            key: Key(this.passList[position].toString()),
            onDismissed: (endToStart) {
              databaseHelper.deletePass(this.passList[position].id);
              updateListView();
              final snackBar = SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Password Deleted!!!'),
                duration: Duration(seconds: 2),
              );

              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10.0,
              child: ListTile(
                title: Text(
                  this.passList[position].title,
                  style: textStyle,
                ),
                trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      navigateToDetail(
                          this.passList[position], 'Edit Password');
                    }),
              ),
            ));
      },
    );
  }
}
