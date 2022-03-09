import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:poc/models/user_location.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:poc/controller/coordinates_accuracy_controller.dart';
import '../models/user_location.dart';
import 'package:provider/provider.dart';

class ARSceneView extends StatefulWidget {
  const ARSceneView({Key? key}) : super(key: key);

  @override
  _ARSceneViewState createState() => _ARSceneViewState();
}

class _ARSceneViewState extends State<ARSceneView> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARNode localObjectNode;
  late ARNode fileSystemNode;
  late ARNode newNode;
  late UserLocation userLocation;
  var objectLatitude = 28.617869;
  var objectLongitude = 77.389296;
  var coordinatesController = CoordinatesController();

  Future<void> onObjTapped(List<String> nodes) async {
    arObjectManager.removeNode(localObjectNode);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARScene'),
      ),
      body: Stack(children: [
        ARView(
          onARViewCreated: onARViewCreated,
          planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        ),
        ///Test Coordinates in Screen
        // Column(
        //   children: [
        //     Text(
        //       'the current latitude&longitude is ${userLocation.latitude}  &  ${userLocation.longitude}',
        //       style: const TextStyle(
        //           fontSize: 15, color: Color.fromRGBO(255, 255, 255, 1)),
        //     ),
        //     const SizedBox(
        //       height: 30,
        //     ),
        //     Text(
        //       'The object coordinates is ${coordinatesController.longLatFirstThreeDigitsAfterDecimal(objectLatitude)}& ${coordinatesController.longLatFirstThreeDigitsAfterDecimal(objectLongitude)}',
        //       style: const TextStyle(
        //           fontSize: 15, color: Color.fromRGBO(255, 255, 255, 1)),
        //     ),
        //   ],
        // )
      ]),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) async {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    /// minimizing longitude and latitude double to 3 digits after the decimal point without rounding it to save the
    ///                             original value of it, that controlling the accuracy of location
    double fixedUserLatitude = coordinatesController
        .longLatFirstThreeDigitsAfterDecimal(userLocation.latitude);
    double fixedUserLongitude =
        coordinatesController.longLatFirstThreeDigitsAfterDecimal(
            userLocation.longitude);
    double fixedObjectLatitude = coordinatesController
        .longLatFirstThreeDigitsAfterDecimal(objectLatitude);
    double fixedObjectLongitude = coordinatesController
        .longLatFirstThreeDigitsAfterDecimal(objectLongitude);

    this.arSessionManager.onInitialize(
          showFeaturePoints: false,
          showPlanes: false,
          showWorldOrigin: false,
          handleTaps: false,
        );

    if (fixedObjectLatitude == fixedUserLatitude &&
        fixedObjectLongitude == fixedUserLongitude) {
      newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "3DModel/scene.gltf",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(0.0, 0.0, -3),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      this.arObjectManager.onInitialize();
      await this.arObjectManager.addNode(newNode);
      localObjectNode = newNode;
      this.arObjectManager.onNodeTap = onObjTapped;
    }


  }
}
