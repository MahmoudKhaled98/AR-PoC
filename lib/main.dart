import 'package:flutter/material.dart';
import 'package:poc/models/user_location.dart';
import 'package:poc/services/location_service.dart';
import 'Screens/ARScene.dart';
import 'package:provider/provider.dart';

import 'controller/coordinates_accuracy_controller.dart';

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
            initialData:UserLocation(longitude: 0.0,latitude: 0.0)),
      ],
      child: MaterialApp(
        title: 'AR PoC',
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

  static CoordinatesController coordinatesController = CoordinatesController();
  static late UserLocation userLocation;
  String? enteredLatitude;
  String? enteredLongitude;

  bool isCoordinatesMatch(){
    if( coordinatesController
        .longLatFirstThreeDigitsAfterDecimal(enteredLatitude) == coordinatesController
        .longLatFirstThreeDigitsAfterDecimal(userLocation.latitude) &&
        coordinatesController
            .longLatFirstThreeDigitsAfterDecimal(enteredLongitude) == coordinatesController.longLatFirstThreeDigitsAfterDecimal(
            userLocation.longitude)){
      return true;
    }else
      {
        return false;
      }
  }
  @override
  Widget build(BuildContext context) {
    userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
       child: Column(
         children:[
           TextField(
            onChanged: (value){
              enteredLatitude=value;
            },
         keyboardType: TextInputType.number,
         decoration: const InputDecoration(
          prefixIcon: Icon(Icons.map_outlined),
          border: OutlineInputBorder(),
          hintText: "Latitude:00.0000000 7 digits after the decimal point",
           hintMaxLines: 3,
          ),
          ),
           const SizedBox(
             height: 10,
           ),
            TextField(
             onChanged: (value){
              enteredLongitude=value;
             },
             keyboardType: TextInputType.number,
             decoration: const InputDecoration(
               prefixIcon: Icon(Icons.map_outlined),
               border: OutlineInputBorder(),
               hintText: "Longitude:00.0000000 7 digits after the decimal point",
               hintMaxLines: 3,
             ),
           ),

           ElevatedButton(
            child: const Text('Navigate to AR scene'),
            onPressed: (){
              isCoordinatesMatch();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   ARSceneView(isMatch: isCoordinatesMatch(),)),
              );
            },
          ),
        ],
       )
      ),
    );
  }
}
