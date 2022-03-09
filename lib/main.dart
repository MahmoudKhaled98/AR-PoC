import 'package:flutter/material.dart';
import 'package:poc/models/user_location.dart';
import 'package:poc/services/location_service.dart';
import 'Screens/ARScene.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        StreamProvider<UserLocation>(
            create: (_)=>LocationService().locationStream,
            initialData:UserLocation(longitude: 0.0,latitude: 0.0))
      ],
      child: MaterialApp(
        title: 'AR Poc',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'AR PoC'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
       child: ElevatedButton(
          child: const Text('Navigate to AR scene'),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ARSceneView()),
            );
          },
        )
      ),
    );
  }
}
