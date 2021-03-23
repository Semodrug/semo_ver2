import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/image.dart';

import 'package:semo_ver2/theme/colors.dart';
import 'package:semo_ver2/camera/no_result.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/dialog.dart';
import 'package:tflite/tflite.dart';

int _selectedIndex;

class CameraPage extends StatefulWidget {
  final int initial;
  final CameraDescription camera;

  const CameraPage({Key key, this.initial, this.camera}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // CameraController와 Future를 저장하기 위 두 개의 변수를 state 클래스에 정의합니다.
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initial;

    _cameraController = CameraController(
        // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
        widget.camera,
        // 적용할 해상도를 지정합니다.
        ResolutionPreset.veryHigh);

    // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // 위젯의 생명주기 종료시 컨트롤러 역시 해제시켜줍니다.
    _cameraController.dispose();
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
            return CameraPreviewScreen(_cameraController);
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
        heroTag: null,
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
            final image = await _cameraController.takePicture();

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
class CameraPreviewScreen extends StatefulWidget {
  /// Creates a preview widget for the given camera controller.
  const CameraPreviewScreen(this.controller, {this.child});

  /// The controller for the camera that the preview is shown for.
  final CameraController controller;

  /// A widget to overlay on top of the camera preview
  final Widget child;

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  // swipe에 따라 page를 보여주기 위한 두 개의 변수를 state 클래스에 정의합니다.
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget barcodeArea() {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
              //top: 160,
              top: MediaQuery.of(context).size.height * 0.15,
              // width: MediaQuery.of(context).size.height * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset('assets/camera/barcode_area.png')),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              child: Text(
                '바코드를\n인식해주세요',
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
                height: 140,
                color: gray750_activated,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 55),
                        Text('바코드',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: primary200)),
                        SizedBox(width: 24),
                        Text('케이스',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: gray200)),
                      ],
                    ),
                  ],
                ),
              ))
        ],
      );
    }

    Widget caseArea() {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
              //top: 160,
              top: MediaQuery.of(context).size.height * 0.15,
              // width: MediaQuery.of(context).size.height * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
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
                height: 140,
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
      );
    }

    return widget.controller.value.isInitialized
        ? Center(
            child: AspectRatio(
              aspectRatio: _isLandscape()
                  ? widget.controller.value.aspectRatio
                  : (1 / widget.controller.value.aspectRatio),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  RotatedBox(
                    quarterTurns: _getQuarterTurns(),
                    child: CameraPlatform.instance
                        .buildPreview(widget.controller.cameraId),
                  ),
                  // child ?? Container(),
                  PageView(
                    // physics: new NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: [
                      barcodeArea(),
                      caseArea(),
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  DeviceOrientation _getApplicableOrientation() {
    return widget.controller.value.isRecordingVideo
        ? widget.controller.value.recordingOrientation
        : (widget.controller.value.lockedCaptureOrientation ??
            widget.controller.value.deviceOrientation);
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
    String barcodeNum;

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
      body: Stack(children: [
        Center(child: Image.file(File(widget.imagePath))),
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
                          if (_selectedIndex == 0) {
                            FirebaseVisionImage visionImage =
                                FirebaseVisionImage.fromFile(
                                    File(widget.imagePath));
                            VisionText readedText;
                            print('$barcodeNum');

                            final BarcodeDetector barcodeDetector =
                                FirebaseVision.instance.barcodeDetector();

                            final List<Barcode> barcodes = await barcodeDetector
                                .detectInImage(visionImage);

                            for (Barcode barcode in barcodes) {
                              final String rawValue = barcode.rawValue;
                              final BarcodeValueType valueType =
                                  barcode.valueType;

                              setState(() {
                                barcodeNum = "$rawValue";
                              });
                            }

                            barcodeDetector.close();

                            if (barcodeNum == null) {
                              IYMYDialog(
                                  context: context,
                                  bodyString: '바코드 인식이 어렵습니다\n다시 촬영해주세요',
                                  leftButtonName: '취소',
                                  leftOnPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/bottom_bar',
                                            (Route<dynamic> route) => false);
                                  },
                                  rightButtonName: '확인',
                                  rightOnPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }).showWarning();
                            } else {
                              var data = await DatabaseService()
                                  .itemSeqFromBarcode(barcodeNum);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              if (data != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReviewPage(data)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoResult()));
                              }
                            }
                          } else {
                            List _outputs;
                            File _image;
                            bool _loading = false;

                            _loading = true;

                            // 1. Load a Model
                            String res = await Tflite.loadModel(
                              model: "assets/case_model/model_unquant.tflite",
                              labels: "assets/case_model/labels.txt",
                            );

                            _loading = false;

                            // 2. get Image
                            var image = File(widget.imagePath);
                            if (image == null) return null;
                            _loading = true;
                            _image = image;

                            // 3. Classify Image
                            var output = await Tflite.runModelOnImage(
                              path: image.path,
                              numResults: 2,
                              threshold: 0.5,
                              imageMean: 127.5,
                              imageStd: 127.5,
                            );
                            //print(image.path);
                            _loading = false;
                            _outputs = output;

                            // 4. TF close
                            Tflite.close();

                            if (_outputs.isEmpty) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoResult()));
                              return Container();
                            } else {
                              String resultSequence =
                                  onlySeq(_outputs[0]["label"]);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CaseResult(
                                            itemSeq: resultSequence,
                                          )));
                            }
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

  String onlySeq(String label) {
    String seq = label;
    List res = [];

    if (seq.contains('[')) {
      res = seq.split('[');
      seq = res[1];
      res = seq.split(']');
      seq = res[0];
    }
    return seq;
  }
}

class CaseResult extends StatefulWidget {
  final String itemSeq;

  const CaseResult({Key key, this.itemSeq}) : super(key: key);

  @override
  _CaseResultState createState() => _CaseResultState();
}

class _CaseResultState extends State<CaseResult> {
  Widget _getRateStar(RatingResult) {
    return RatingBarIndicator(
      rating: RatingResult * 1.0,
      //ignoreGestures: true,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 14,
      itemPadding: EdgeInsets.symmetric(horizontal: 0),
      unratedColor: gray75,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResultAppBarBarcode(type: 2),
      backgroundColor: gray0_white,
      body: StreamBuilder<Drug>(
          stream: DatabaseService(itemSeq: widget.itemSeq).drugData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Drug drugStreamData = snapshot.data;
              String drugRating = drugStreamData.totalRating.toStringAsFixed(2);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      width: MediaQuery.of(context).size.width,
                      color: gray50,
                      child: OutlinedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 88,
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Container(
                                          padding: EdgeInsets
                                              .zero, //fromLTRB(5, 0, 5, 5),
                                          child: SizedBox(
                                              child: DrugImage(
                                                  drugItemSeq:
                                                      drugStreamData.itemSeq))),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 8, 10, 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
                                              child: Text(
                                                  drugStreamData.entpName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .overline
                                                      .copyWith(
                                                          fontSize: 10,
                                                          color:
                                                              gray300_inactivated)),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  210,
                                              child: Text(
                                                  //_checkLongName(drugStreamData.itemName),
                                                  drugStreamData.itemName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          color: gray900)),
                                            ),
                                            Row(
                                              children: [
                                                _getRateStar(
                                                    drugStreamData.totalRating),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(drugRating,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                            color: gray900)),
                                                Text(
                                                    ' (${drugStreamData.numOfReviews}개)',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .overline
                                                        .copyWith(
                                                            fontSize: 10,
                                                            color:
                                                                gray300_inactivated)),
                                              ],
                                            ),
                                            Expanded(
                                                child: Row(
                                              children: [
                                                CategoryButton(
                                                    str:
                                                        drugStreamData.category,
                                                    forRanking: 'ranking')
                                              ],
                                            )),
                                          ],
                                        )),
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 40,
                                    color: primary300_main,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReviewPage(widget.itemSeq)));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: gray0_white,
                            // minimumSize: Size(12, 23),
                            padding: EdgeInsets.zero,
                            // elevation: 0,
                            // primary: gray0_white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(color: primary400_line)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewPage(widget.itemSeq)));
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '내가 찾는 약이 아니라면?',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          child: Text(
                            '다시 촬영하기',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    color: gray500),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else
              return LinearProgressIndicator();
          }),
    );
  }
}
