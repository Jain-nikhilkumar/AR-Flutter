import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARLocationManager? arLocationManager;

  // List of available models
  final List<String> modelUris = [
    "assets/bioswale_photosphere.glb",
    "assets/future_car.glb",
    "assets/pyramid,glb",
  ];

  // Selected model
  String selectedModelUri = "assets/models/model1.glb";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: // Generated code for this AppBar Widget...
      AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'AR FLUTTER',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'Outfit',
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 22,
            letterSpacing: 0,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      )
      ,
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
          ),
        ],
      ),
    );
  }

  Future<void> onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) async {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arLocationManager = arLocationManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
      handleTaps: true,
    );

    this.arObjectManager?.onInitialize();

    // Set the tap handler
    arSessionManager.onPlaneOrPointTap = onPlaneTap;
  }

  void onPlaneTap(List<ARHitTestResult> hits) {
    if (hits.isNotEmpty) {
      var hit = hits.firstWhere((hit) => hit.type == ARHitTestResultType.plane);
      if (hit != null) {
        // Add the selected model at the tapped location
        addObject(hit.worldTransform);
      }
    }
  }

  void addObject(vector_math.Matrix4 transform) {
    var newNode = ARNode(
      type: NodeType.webGLB,
      uri: selectedModelUri,
      scale: vector_math.Vector3(0.1, 0.1, 0.1),
      transformation: transform,
    );
    arObjectManager?.addNode(newNode);
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
}
