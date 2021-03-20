import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/camera/no_result.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/dialog.dart';
import 'package:semo_ver2/theme/colors.dart';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class CasePage extends StatefulWidget {
  final CameraDescription camera;

  const CasePage({Key key, @required this.camera}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CasePage> {
  // CameraController와 Future를 저장하기 위해 두 개의 변수를 state 클래스에 정의합니다.
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라의 현재 출력물을 보여주기 위해 CameraController를 생성합니다.
    _controller = CameraController(
      // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
      widget.camera,

      // 적용할 해상도를 지정합니다.
      ResolutionPreset.veryHigh,
    );

    // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 위젯의 생명주기 종료시 컨트롤러 역시 해제시켜줍니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: gray750_activated,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: gray0_white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          //for test home
        ],
      ),
      backgroundColor: gray750_activated,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future가 완료되면, 프리뷰를 보여줍니다.
            return CameraPreviewScreen(_controller);
          } else {
            // Otherwise, display a loading indicator.
            // 그렇지 않다면, 진행 표시기를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: gray750_activated,
        elevation: 0,
        child: Image.asset(
            'assets/camera/take_button.png'), // onPressed 콜백을 제공합니다.
        onPressed: () async {
          // try / catch 블럭에서 사진을 촬영합니다. 만약 뭔가 잘못된다면 에러에 대응할 수 있습니다.
          try {
            // 카메라 초기화가 완료됐는지 확인합니다.
            await _initializeControllerFuture;

            // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
            final image = await _controller.takePicture();

            // 사진을 촬영하면, 새로운 화면으로 넘어갑니다.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image?.path),
              ),
            );
          } catch (e) {
            // 만약 에러가 발생하면, 콘솔에 에러 로그를 남깁니다.
            print(e);
          }
        },
      ),
    );
  }
}

/// A widget showing a live camera preview.
class CameraPreviewScreen extends StatelessWidget {
  /// Creates a preview widget for the given camera controller.
  const CameraPreviewScreen(this.controller, {this.child});

  /// The controller for the camera that the preview is shown for.
  final CameraController controller;

  /// A widget to overlay on top of the camera preview
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _isLandscape()
                ? controller.value.aspectRatio
                : (1 / controller.value.aspectRatio),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                RotatedBox(
                  quarterTurns: _getQuarterTurns(),
                  child:
                      CameraPlatform.instance.buildPreview(controller.cameraId),
                ),
                child ?? Container(),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    width: 140,
                    height: 140,
                    child: Image.asset('assets/camera/case_area.png')),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.5,
                    child: Text(
                      '케이스를\n인식해주세요',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: gray0_white),
                    )),
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      color: gray750_activated,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('바코드',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: gray200)),
                              SizedBox(width: 24),
                              Text('케이스',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: primary200)),
                              SizedBox(width: 55),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          )
        : Container();
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation
        : (controller.value.lockedCaptureOrientation ??
            controller.value.deviceOrientation);
  }

  bool _isLandscape() {
    return [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        .contains(_getApplicableOrientation());
  }

  int _getQuarterTurns() {
    int platformOffset = defaultTargetPlatform == TargetPlatform.iOS ? 1 : 0;
    Map<DeviceOrientation, int> turns = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 1,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeRight: 3,
    };
    return turns[_getApplicableOrientation()] + platformOffset;
  }
}

// 사용자가 촬영한 사진을 보여주는 위젯
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  @override
  Widget build(BuildContext context) {
    //String barcodeNum;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: gray750_activated,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: gray0_white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          //for test home
        ],
      ),
      backgroundColor:
          gray750_activated, // 이미지는 디바이스에 파일로 저장됩니다. 이미지를 보여주기 위해 주어진
      // 경로로 `Image.file`을 생성하세요.
      body: Stack(alignment: AlignmentDirectional.center, children: [
        Image.file(File(widget.imagePath)),
        Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: gray750_activated,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('다시 찍기',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: gray0_white)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('사진 사용',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: gray0_white)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          if(File(widget.imagePath) != null){
                            print('사진 사용 한 후에 일어나는 일들 ');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseResult(image: File(widget.imagePath),)));
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}

class CaseResult extends StatefulWidget {
  final File image;

  const CaseResult({Key key, this.image}) : super(key: key);


  @override
  _CaseResultState createState() => _CaseResultState();
}

class _CaseResultState extends State<CaseResult> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });

    pickImage();
    // setState(() {
    //   _loading = true;
    //   _image = widget.image;
    // });
    //
    // classifyImage(_image);

  }

  pickImage() {
    var image = widget.image;
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Case 인식'),
      ),
      body:
      /*
      _loading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          :
          */
      Container(
        width: MediaQuery.of(context).size.width-200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Container() : Image.file(_image),
            SizedBox(
              height: 20,
            ),
            _outputs != null && _outputs.length != 0
                ? Column(
              children: [
                Text(
                  "${_outputs[0]["confidence"]}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    background: Paint()..color = Colors.white,
                  ),
                ),
                Text(
                  "${_outputs[0]["label"]}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    background: Paint()..color = Colors.white,
                  ),
                ),
              ],
            )
                : _image == null
                ? Container()
                :
            //검색 결과가 없는 페이지로 넘어가기!!
            Container(
              child: Text(
                "결과가 없습니다",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  background: Paint()..color = Colors.white,
                ),
              ),
            )
            //Container(),
          ],
        ),
      ),
    );
  }



  classifyImage(File image) async {
    print('  3104   ');
    print(image);
    print( '     ');

    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print('알고 싶다');
    print(image.path);
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    String res = await Tflite.loadModel(
       model: "assets/case_model/model_unquant.tflite",
       labels: "assets/case_model/labels.txt",
    );
    print('ohoh');
    print(res);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

}
