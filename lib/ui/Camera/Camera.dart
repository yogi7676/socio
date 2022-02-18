/*
class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}*/
/*
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:my_project/widgets/PreviewScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() {
    return _CameraState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return CupertinoIcons.switch_camera;
    case CameraLensDirection.front:
      return CupertinoIcons.switch_camera_solid;
    case CameraLensDirection.external:
      return CupertinoIcons.photo_camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraState extends State<Camera> with SingleTickerProviderStateMixin {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  AnimationController _controller;
  double _scale;
  bool showPreview = false;
  bool isImage=false;
  bool isVideo=false;

  List cameras;
  int selectedCameraIndex;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.15,
    )..addListener(() {
        setState(() {});
      });

    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        onNewCameraSelected(cameras[selectedCameraIndex]);
      } else {
        print('No Cameras available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return showPreview == false
        ? Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50.0,
                          ),
                          Expanded(child: _cameraPreviewWidget()),
                          SizedBox(
                            height: 100.0,
                          ),
                      ],
                    )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(
                                Icons.flash_on,
                                color: Colors.white,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                            GestureDetector(
                              onTap: () {
                                onTakePictureButtonPressed();
                                setState(() {
                                  isImage=true;
                                  isVideo=false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2.0, color: Colors.white)),
                                width: 80.0,
                                height: 80.0,
                              ),
                            ),
                            _cameraToggleRowWidget()
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Stack(
               children: <Widget>[
                 Container(
                   color: Colors.black,
                   child: Column(
                     children: <Widget>[
                       SizedBox(height: 50.0,),
                       Expanded(child: Image.file(File(imagePath)),),
                       SizedBox(height: 50.0,),
                     ],
                   ),
                 ),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         IconButton(
                             icon: Icon(Icons.clear,color: Colors.white,),
                             onPressed: (){
                               setState(() {
                                 showPreview=false;
                                 imagePath='';
                               });
                             }
                         ),
                         IconButton(icon: Icon(Icons.insert_emoticon,color: Colors.white,), onPressed: (){}),
                         IconButton(icon: Icon(CupertinoIcons.tag_solid,color: Colors.white,), onPressed: (){}),
                         IconButton(icon: Icon(Icons.text_format,color: Colors.white,), onPressed: (){}),
                         IconButton(icon: Icon(Icons.location_on,color: Colors.white,), onPressed: (){}),
                         IconButton(icon: Icon(CupertinoIcons.pen,color: Colors.white,), onPressed: (){})
                       ],
                     )
                   ],
                 )
               ],
              ),
            ),
          );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        child: Text("No Camera"),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Widget to capture photo / video
  Widget animatedCaptureControlButton() {
    return Container(
      width: 90.0,
      height: 90.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 3.0, color: Colors.white)),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  /// widget to display icon to switch between front and rear
  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return IconButton(
      icon: Icon(
        getCameraLensIcon(lensDirection),
        color: Colors.white,
        size: 30,
      ),
      onPressed: _onSwitchCamera,
    );
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;

    CameraDescription selectedCamera = cameras[selectedCameraIndex];

    onNewCameraSelected(selectedCamera);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) {
          //showInSnackBar('Picture saved to $filePath');
          setState(() {
            showPreview = true;
          });
          print('$filePath');
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviewScreen(imgPath: filePath,)));
        }
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving Video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Video recorded to: $videoPath');
      showInSnackBar('VideoRecorder to : $imagePath');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error : select a camera first');
    }

    final Directory extdir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extdir.path} /Movies';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    print(videoPath);
    //
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviewScreen(videoPath: videoPath,)));
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();

    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}*/

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socio/Widgets/Emojis.dart';
import 'package:video_player/video_player.dart';

class Camera extends StatefulWidget {
  final bool isLive;

  const Camera({Key key, @required this.isLive}) : super(key: key);

  @override
  _CameraState createState() {
    return _CameraState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return CupertinoIcons.switch_camera;
    case CameraLensDirection.front:
      return CupertinoIcons.switch_camera_solid;
    case CameraLensDirection.external:
      return Icons.photo_camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  imageLib.Image _image;
  Filter _filter;
  List<Filter> filters=presetFiltersList;

  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  int selectedCameraIndex;
  bool showPreview = false;

  @override
  void initState() {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        onNewCameraSelected(cameras[selectedCameraIndex]);
      } else {
        print('No Cameras available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });

    print(filters.toList());
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                /*border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),*/
              ),
            ),
          ),
          _captureControlRowWidget(),
          _toggleAudioWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _thumbnailWidget(),
              ],
            ),
          ),
        ],
      ),
    );*/
    return widget.isLive
        ? Scaffold()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            body: SafeArea(
                child: showPreview == false
                    ? Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              onTakePictureButtonPressed();
                              setState(() {
                                showPreview=true;
                              });
                            },
                            onLongPressStart: (LongPressStartDetails details){
                              onVideoRecordButtonPressed();
                            },
                            onLongPressEnd: (LongPressEndDetails details){
                              onStopButtonPressed();
                              setState(() {
                                imagePath='';
                                showPreview=true;
                              });
                            },
                            child: Container(
                                child: Column(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 50.0),
                                  color: Colors.black,
                                  child: _cameraPreviewWidget(),
                                )),
                              ],
                            )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {}),
                                  IconButton(
                                      icon: Icon(
                                        Icons.flash_on,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {}),
                                  _cameraTogglesRowWidget()
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        "Tap to capture Image/ LongPress to capture video.",
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : videoController == null && imagePath == null
                        ? Container(
                            color: Colors.black,
                          )
                        : videoController == null
                            ? showImagePreview()
                            //? showImagePreview()
                            : showVideoPreview()
            ),
          );
  }


  showImagePreview() {
    return WillPopScope(
      onWillPop: ()=> alertDialog(),
      child: Stack(
        children: <Widget>[
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.amber.withOpacity(0.5), BlendMode.softLight),
            child: Container(
                alignment: Alignment.center,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: ()=>alertDialog()),
                  IconButton(
                      icon: Icon(
                        Icons.palette,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: (){}
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: (){}
                  ),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.tag_solid,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: (){}
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.face,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (context)
                            =>Container(
                              height:MediaQuery.of(context).size.height * 0.3,
                              child: EmojiClass(),
                            )
                        );
                      }
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.text_format,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: (){}
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    /*Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(icon: Icon(Icons.send), onPressed: (){}),
                )*/
                    IconButton(icon: Icon(Icons.send,size: 30.0,color: Colors.white,), onPressed: (){})
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  alertDialog(){
    return showDialog(
      context: context,
      builder: (context)
        =>AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 200.0,
            width: 200.0,
            padding: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0)
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Discard Photo ?',
                  style: TextStyle(fontSize: 16.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'You will loose this image if you go back',
                    style: TextStyle(fontSize: 13.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                buttonForAlertDialog(
                    200.0,
                    FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                        setState(() {
                          showPreview=false;
                        });
                      },
                      child: Text("Discard",style: TextStyle(color: Colors.red),),)
                ),
                buttonForAlertDialog(
                    200.0,
                    FlatButton(onPressed: ()=>Navigator.pop(context), child: Text("Keep"))
                ),
              ],
            ),
          ),
        )
    );
  }

  buttonForAlertDialog(double width,FlatButton button){
    return SizedBox(
      width: width,
      child: button,
    );
  }

  showVideoPreview() {
    return WillPopScope(
      onWillPop: ()=>alertDialog(),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: AspectRatio(
                aspectRatio: videoController.value.size != null
                    ? videoController.value.aspectRatio
                    : 1.0,
                child: VideoPlayer(videoController)),
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      /*return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );*/
      return Container();
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              enableAudio = value;
              if (controller != null) {
                onNewCameraSelected(controller.description);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imagePath == null
                ? Container()
                : SizedBox(
                    child: (videoController == null)
                        ? Image.file(File(imagePath))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      videoController.value.size != null
                                          ? videoController.value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(videoController)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? (controller != null && controller.value.isRecordingPaused
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return IconButton(
      icon: Icon(
        getCameraLensIcon(lensDirection),
        color: Colors.white,
        size: 30,
      ),
      onPressed: _onSwitchCamera,
    );
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;

    CameraDescription selectedCamera = cameras[selectedCameraIndex];

    onNewCameraSelected(selectedCamera);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        //if (filePath != null) showInSnackBar('Picture saved to $filePath');
        if(filePath!=null) return;
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      //if (filePath != null) showInSnackBar('Saving video to $filePath');
      if (filePath != null) return;
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Video recorded to: $videoPath');
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Video recording resumed');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

List<CameraDescription> cameras = [];
