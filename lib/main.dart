import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Jarvis.dart';
import 'database_helper_sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Jarvis Techolab'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter = "Please Wait";

  List<Datum> data = [];
  @override
  void initState() {
    super.initState();
    readData();
  }

  readData() async {
    data = [];
    Database_helper a = Database_helper.instance;

    var myUser = await a.read();

    print(myUser);
    setState(() {
      data = myUser.map((f) => Datum.fromJson(f)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton.icon(
                    icon: Icon(Icons.show_chart),
                    onPressed: () async {
                      data = [];
                      Database_helper a = Database_helper.instance;

                      var myUser = await a.read();

                      print(myUser);
                      setState(() {
                        data = [];
                        data = myUser.map((f) => Datum.fromJson(f)).toList();
                      });
                    },
                    label: Text("Show User"),
                  ),
                  OutlineButton.icon(
                    icon: Icon(Icons.person_add),
                    label: Text("New User"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserAdd(
                                  type: "new",
                                ),
                            fullscreenDialog: true)),
                  ),
                ],
              ),
            ),
            data.isEmpty
                ? Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Please Below button for load data")
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(UniqueKey().toString()),
                        onDismissed: (direction) {
                          if (direction.index == 2) {
                            Database_helper a = Database_helper.instance;
                            var temp = data[index];
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Your user has been deleted"),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  a.insert(temp.toJson());
                                  readData();
                                },
                              ),
                            ));
                            a
                                .delete(index + 1)
                                .then((onValue) => print(onValue));

                            print("hello you are right");
                            print(data.length);
                          } else {
                            print("hello you are wrong");
                            print(data.length);
                          }
                        },
                        direction: DismissDirection.endToStart,
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserAdd(
                                        type: "edit",
                                        temp: data[index],
                                      ),
                                  fullscreenDialog: true)),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data[index].avatar),
                          ),
                          title: Text(
                              data[index].firstName + data[index].lastName),
                          subtitle: Text(data[index].email),
                          trailing: CircleAvatar(
                            child: Text(data[index].id.toString()),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        label: Text("For load API Data"),
        onPressed: () async {
          Database_helper myData = Database_helper.instance;

          await http.get("https://reqres.in/api/users?page=1").then((onValue) {
            var a = jarvisFromJson(onValue.body);

            setState(() {
              for (var temp in a.data) {
                myData.read().then((onValue) {
                  if (onValue.isEmpty) {
                    myData.insert(temp.toJson()).then((onValue) {
                      readData();
                    });
                  }
                });
              }
            });
          });
        },
        tooltip: 'Increment',
      ),
    );
  }
}

class MyImage extends StatefulWidget {
  final String tag, imageUrl;
  final Datum temp;

  MyImage({this.temp, this.imageUrl, this.tag, Key key}) : super(key: key);

  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  @override
  Widget build(BuildContext context) {
    String a = widget.temp.toString();
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Image.network(widget.imageUrl), Text(a)],
        ),
      ),
    );
  }
}

class UserAdd extends StatefulWidget {
  final String type;
  final Datum temp;
  UserAdd({this.temp, this.type, Key key}) : super(key: key);

  _UserAddState createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController avatar = TextEditingController();
  String abc =
      "https://media.wired.com/photos/5b899992404e112d2df1e94e/master/pass/trash2-01.jpg";
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (widget.type == "edit") {
      email = TextEditingController(text: widget.temp.email);
      fname = TextEditingController(text: widget.temp.firstName);
      lname = TextEditingController(text: widget.temp.lastName);
      avatar = TextEditingController(text: widget.temp.avatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text(widget.type),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: fname,
                    decoration: InputDecoration(
                        labelText: "First Name",
                        hintText: "First name",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: lname,
                    decoration: InputDecoration(
                        labelText: "Last Name",
                        hintText: "Last name",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Email",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: avatar,
                    decoration: InputDecoration(
                        labelText: "Avatar",
                        hintText: "Avatar",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () async {
                        Database_helper a = Database_helper.instance;
                        if (widget.type == "new") {
                          if (fname.text.isEmpty ||
                              lname.text.isEmpty ||
                              email.text.isEmpty) {
                            _scaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text("Please fill all the feild"),
                            ));
                          } else {
                            Datum temp = Datum(
                                avatar: abc,
                                email: email.text,
                                firstName: fname.text,
                                lastName: lname.text);
                            var op = await a.insert(temp.toJson());
                            print(op);

                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(title: 'Jarvis Techolab')));
                          }
                        } else {
                          if (fname.text.isEmpty ||
                              lname.text.isEmpty ||
                              email.text.isEmpty) {
                            _scaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text("Please fill all the feild"),
                            ));
                          } else {
                            Datum temp = Datum(
                                id: widget.temp.id,
                                avatar: avatar.text,
                                email: email.text,
                                firstName: fname.text,
                                lastName: lname.text);
                            a.update(temp.toJson()).then((onValue) {
                              print("#########");
                              print(onValue);
                              print("#########");
                            });
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(title: 'Jarvis Techolab')));
                          }
                        }
                      },
                      child: Text(widget.type),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
