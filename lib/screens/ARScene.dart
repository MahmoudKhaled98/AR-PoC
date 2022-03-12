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

 final bool isMatch;
 const ARSceneView(  {Key? key,required this.isMatch}) : super(key: key);

  @override
  _ARSceneViewState createState() => _ARSceneViewState();
}

class _ARSceneViewState extends State<ARSceneView> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARNode localObjectNode;
  late ARNode fileSystemNode;
  late ARNode newNode;




  Future<void> onObjTapped(List<String> nodes) async {
    // arObjectManager.removeNode(localObjectNode);
    Navigator.pop(context);
  }
  @override


  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Text('ARScene'),
      ),
      body: Stack(children: [
        ARView(
          onARViewCreated: onARViewCreated,
          planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        ),
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

    this.arSessionManager.onInitialize(
          showFeaturePoints: false,
          showPlanes: false,
          showWorldOrigin: false,
          handleTaps: false,
      handlePans: false,
        );

    if (widget.isMatch) {
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
