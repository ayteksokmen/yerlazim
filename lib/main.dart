import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:yerlazim/i_need_place.view.dart';
import 'package:yerlazim/model/match.dart';
import 'package:yerlazim/notification.dart';
import 'db.dart';
import 'firebase_options.dart';

import 'i_have_place_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text("something wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return YerLazimApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}

class YerLazimApp extends StatelessWidget {
  YerLazimApp({Key? key}) : super(key: key);
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
      title: 'Yer Lazım',
      locale: const Locale('tr'),
      supportedLocales: const [
        Locale('tr')
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Yer Lazım'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    signInAnonymously();
    Db.instance.readData();
    NotificationManager.instance.requestPermission(context);

    NotificationManager.instance.displayNotification(const MatchModel(
      id: "",
      demandId: "",
      sourceId: ""
    ), NotificationType.forDemand);
  }

  Future<UserCredential?> signInAnonymously() async {
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }

    if (userCredential == null) {
      throw Exception('Failed to sign in anonymously!');
    }
    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return const IHavePlaceForm();
              }));
            }, child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Konaklamaya Uygun Yerim Var", style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            ),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent))),

            SizedBox(height: 20,),

            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return const INeedPlaceForm();
              }));
            }, child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: const Text("Konaklama İhtiyacım Var", style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),)
          ],
        ),
      ),
    );
  }
}
