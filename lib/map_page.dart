import 'dart:async';
import 'dart:io';
import 'package:enoxamed_game/made_it_page.dart';
import 'package:enoxamed_game/principe_page.dart';
import 'package:enoxamed_game/result_page.dart';
import 'package:enoxamed_game/services/users_service.dart';
import 'package:enoxamed_game/utils/image_capture.dart';
import 'package:enoxamed_game/widgets/custom_dialog_info.dart';
import 'package:enoxamed_game/widgets/drawing_painter.dart';
import 'package:enoxamed_game/widgets/firenze_container.dart';
import 'package:enoxamed_game/widgets/manouba_container.dart';
import 'package:enoxamed_game/widgets/napoli_container.dart';
import 'package:enoxamed_game/widgets/pisa_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'home_page.dart';
import 'leaderboard_page.dart';
import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  final int? userId;
  final int repetitionCount;

  const MapPage(
      {super.key, required this.userId, required this.repetitionCount});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Timer _timer;
  bool _isLoading = false;
  int failedRepetitionCount=0;
  double _leftPosition = 180.0;
  double _topPosition = 0.0;
  final double _step = 50.0;
  bool _movingRight = true;
  bool _isPaused = false;
  int _stepCount = 0;
  final List<int> _pauseSteps = [6, 10, 14, 18];
  late final Map<int, int> _repetitions;
  int _currentRepetition = 0;
  final GlobalKey _drawingKey = GlobalKey();
  List<Offset?> _points = [];
  Image? _resultIcon;
  bool _countdownStarted = false;
  late List<String> _gifPaths;
  int _currentGifIndex = 0;
  int _elapsedTime = 0;
  bool _isButtonEnabled = true; // Added flag for button state
  int _clickCount = 0;
  int _speed = 500;
  Timer? _countdownTimer;
  int _drawingTimeLeft = 20;

  //bool displayStops = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _topPosition = MediaQuery.of(context).size.height - 240;
      setState(() {});
    });
    _initializeRepetitions();
    _initializeGifPaths(); // Initialize GIF paths based on repetitionCount
    _startTimer();

    /*Future.delayed(Duration(seconds: 2)).then((value) {
     setState(() {
       displayStops = true;
     });
     Future.delayed(Duration(seconds: 4)).then((value) {
       setState(() {
         displayStops = false;
       });
   });});*/
  }
  void _initializeGifPaths() {
    if (widget.repetitionCount == 4) {
      _gifPaths = [
        'assets/Group4.png',
        'assets/Group4-1.png',
        'assets/Group4-2.png',
        'assets/Group4-3.png',
        'assets/perso.gif'
      ];
    } else if (widget.repetitionCount == 6) {
      _gifPaths = [
        'assets/Group6.png',
        'assets/Group6-1.png',
        'assets/Group6-2.png',
        'assets/Group6-3.png',
        'assets/perso.gif'
      ];
    } else if (widget.repetitionCount == 8) {
      _gifPaths = [
        'assets/Group8.png',
        'assets/Group8-1.png',
        'assets/Group8-2.png',
        'assets/Group8-3.png',
        'assets/perso.gif'


      ];
    } else if (widget.repetitionCount == 10) {
      _gifPaths = [
        'assets/Group10.png',
        'assets/Group10-1.png',
        'assets/Group10-2.png',
        'assets/Group10-3.png',
        'assets/perso.gif'

      ];
    }
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 0)).then((value) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime++;
        });
      });
    });
  }

  void _initializeRepetitions() {
    if (widget.repetitionCount == 4) {
      _repetitions = {6: 1, 10: 1, 14: 1, 18: 1};
    } else if (widget.repetitionCount == 6) {
      _repetitions = {6: 1, 10: 2, 14: 1, 18: 2};
    } else if (widget.repetitionCount == 8) {
      _repetitions = {6: 2, 10: 2, 14: 2, 18: 2};
    } else if (widget.repetitionCount == 10) {
      _repetitions = {6: 2, 10: 3, 14: 2, 18: 3};
    }
  }

  void _startDrawingCountdown() {
    _countdownStarted = true;
    _drawingTimeLeft = 20;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _drawingTimeLeft--;
        if (_drawingTimeLeft == 0) {
          _countdownTimer?.cancel();
          _recognizeDrawing();
        }
      });
    });
  }

  Future<void> _recognizeDrawing() async {
    _isLoading = true;
    final capturedImage = await captureImage(_drawingKey);
    if (capturedImage != null) {
      try {
        final byteData =
        await capturedImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final imageFile = File('${tempDir.path}/drawing.png');
          await imageFile.writeAsBytes(pngBytes);

          final inputImage = InputImage.fromFilePath(imageFile.path);
          final textRecognizer = GoogleMlKit.vision.textRecognizer();
          final recognisedText = await textRecognizer.processImage(inputImage);
          await textRecognizer.close();

          final recognizedWord =
          recognisedText.text.trim().toUpperCase().replaceAll(' ', '');
          final expectedWord = "ENOXAMED".toUpperCase().replaceAll(' ', '');

          if (_matchLetters(recognizedWord, expectedWord)) {
            setState(() {
              _resultIcon = Image.asset("assets/OK.png", width: 35);

              _currentRepetition++;
              if (_currentRepetition >= _repetitions[_stepCount]!) {
                _isPaused = false;
                _currentRepetition = 0;
                _moveImage();
              }
            });
            // Instead of showing a dialog, update UI or show a SnackBar
            _isLoading = false;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Bravo !👏"),
                  content: Text("Bravo🎉🎊! vous avez libéré une hématie."),

                );
              },
            );

          } else {
            _isLoading = false;


            _handleFailedDrawingAttempt();
          }
          _isLoading = false;
// Clear the drawing area after recognition
          _clearDrawing();

          // Hide the result icon after a short delay
          _hideResultIconAfterDelay();
          _startDrawingCountdown(); // Restart the countdown
        }
      } catch (e) {
        _isLoading = false;

        print('Error recognizing text: $e');
      }
    } else {
      _isLoading = false;

      print('Error: Captured image is null.');
    }
  }
  // Method to clear the drawing area
  void _clearDrawing() {
    setState(() {
      _points = [];
    });
  }
  void _handleFailedDrawingAttempt() {
    setState(() {
      _resultIcon = Image.asset("assets/Faux.png", width: 35);
      _elapsedTime += 25; // Add 20 seconds to the elapsed time
      _currentRepetition++;
      failedRepetitionCount++;
      if (_currentRepetition >= _repetitions[_stepCount]!) {
        _isPaused = false;
        _currentRepetition = 0;
        _moveImage();
      }
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Oops! 🙈"),
          content: Text("Oops !Vous n’avez pas réussi à libérer une hématie. 20 secondes ajoutées au chronomètre."),
        );
      },
    );



    _hideResultIconAfterDelay();

  }

  bool _matchLetters(String recognizedWord, String expectedWord) {
    int matchCount = 0;
    for (var char in recognizedWord.split('')) {
      if (expectedWord.contains(char)) {
        matchCount++;
        if (matchCount >= 5) return true;
      }
    }
    return false;
  }

  void _moveImage() {
    if (_isPaused) {
      if (_pauseSteps.contains(_stepCount)) {
        setState(() {
          _isPaused = true;
          _points = [];
          _currentGifIndex = (_currentGifIndex + 1) % _gifPaths.length;
          _startDrawingCountdown(); // Start the countdown timer
        });
      } else {
        _completeMovement();
      }
      return;
    }

    setState(() {
      _stepCount++;
      _clickCount++;
      _speed = 500 - (_clickCount * 30);
      if (_speed < 50) _speed = 50;

      if (_movingRight) {
        _leftPosition += _step+10;
        if (_leftPosition > MediaQuery.of(context).size.width - 480) {
          _leftPosition = MediaQuery.of(context).size.width - 480;
          _movingRight = false;
          _topPosition -= _step + 24;
        }
      } else {
        _leftPosition -= _step+10;
        if (_leftPosition <= 260.0) {
          _leftPosition = 260.0;
          _movingRight = true;
          _topPosition -= _step + 24;
        }
        if (_leftPosition < 0) {
          _leftPosition = 0;
          _movingRight = true;
          if (_topPosition > 0) {
            _topPosition -= _step;
          }
        }
      }

      if (_pauseSteps.contains(_stepCount)) {
        _isPaused = true;
        _points = [];
        _currentGifIndex = (_currentGifIndex + 1) % _gifPaths.length;
        _startDrawingCountdown(); // Start the countdown timer
      }
      if (_topPosition < -50) {
        _timer.cancel();
        final score = _elapsedTime / widget.repetitionCount;
        _updateUserData(
          context,
          score,
          _elapsedTime,
          widget.repetitionCount,
          widget.repetitionCount-failedRepetitionCount,
        );
      }
    });

    // Disable the button for 500 milliseconds
    _disableButtonTemporarily();
  }

  Future<void> _updateUserData(BuildContext context, double score,
      int elapsedTime, int nbChallenge, int nbChallengeDone) async {
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, dynamic> userData = {
      'nbChallengeDone': nbChallengeDone,
      'actualTime': elapsedTime,
      'score': score,
    };
    print(userData);
    try {
      await UsersService().updateUserData(widget.userId!, userData);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MadeItPage(
              userId: widget.userId,
              score: score,
              elapsedTime: _elapsedTime,
              nbFailues:failedRepetitionCount,
              nbChallenge: nbChallenge,
              nbChallengeDone: nbChallenge-failedRepetitionCount,
            )),
      );
    } catch (error) {
      print(error);
      CustomDialog(
          width: screenHeight,
          body: "Une erreur s'est produite",
          title: "Oops! 🙈",
          height: screenHeight,
          context: context)
          .showCustomDialog();
    }
  }

  void _disableButtonTemporarily() {
    setState(() {
      _isButtonEnabled = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
  }

  double _calculateRotationAngle() {
    if (_movingRight) {
      if (_topPosition < MediaQuery.of(context).size.height / 2) {
        return -0.05;
      } else {
        return -0.1;
      }
    } else {
      if (_topPosition < MediaQuery.of(context).size.height / 2) {
        return -0.05;
      } else {
        return 0.1;
      }
    }
  }

  void _completeMovement() {
    setState(() {
      _stepCount++;
      _isPaused = false;
      _points = [];
      _currentGifIndex = (_currentGifIndex + 1) % _gifPaths.length;
    });
  }


  String _formatElapsedTime(int elapsedTime) {
    int minutes = elapsedTime ~/ 60;
    int seconds = elapsedTime % 60;
    int remainingSeconds = _drawingTimeLeft;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  void _hideResultIconAfterDelay() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _resultIcon = null;
      });
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (_topPosition == 0.0) {
      _topPosition = MediaQuery.of(context).size.height - 210;
    }

    return Container(
      color: const Color(0xffe3d9ba),
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: true,
        child: Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/map_bg.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                if (_stepCount >= 7 && widget.repetitionCount == 4)
                  Positioned(
                    left: 470,
                    top: 310,
                    child: Image.asset(
                      'assets/Glob4.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 11 && widget.repetitionCount == 4)
                  Positioned(
                    left: 330,
                    top: 230,
                    child: Image.asset(
                      'assets/Glob4-1.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 15 && widget.repetitionCount == 4)
                  Positioned(
                    left: 600,
                    top: 180,
                    child: Image.asset(
                      'assets/Glob4-2.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 19 && widget.repetitionCount == 4)
                  Positioned(
                    left: 320,
                    top: 140,
                    child: Image.asset(
                      'assets/Glob4-3.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ///Rep8
                if (_stepCount >= 7 && widget.repetitionCount == 6)
                  Positioned(
                    left: 470,
                    top: 300,
                    child: Image.asset(
                      'assets/Glob6.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 11 && widget.repetitionCount == 6)
                  Positioned(
                    left: 330,
                    top: 240,
                    child: Image.asset(
                      'assets/Glob6-1.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 15 && widget.repetitionCount == 6)
                  Positioned(
                    left: 600,
                    top: 170,
                    child: Image.asset(
                      'assets/Glob6-2.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 19 && widget.repetitionCount == 6)
                  Positioned(
                    left: 330,
                    top: 140,
                    child: Image.asset(
                      'assets/Glob6-3.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                //rep14
                if (_stepCount >= 7 && widget.repetitionCount == 8)
                  Positioned(
                    left: 450,
                    top: 300,
                    child: Image.asset(
                      'assets/Glob8.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 11 && widget.repetitionCount == 8)
                  Positioned(
                    left: 330,
                    top: 240,
                    child: Image.asset(
                      'assets/Glob8-1.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 15 && widget.repetitionCount == 8)
                  Positioned(
                    left: 600,
                    top: 180,
                    child: Image.asset(
                      'assets/Glob8-2.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 19 && widget.repetitionCount == 8)
                  Positioned(
                    left: 310,
                    top: 150,
                    child: Image.asset(
                      'assets/Glob8-3.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                //rep18
                if (_stepCount >= 7 && widget.repetitionCount == 10)
                  Positioned(
                    left: 460,
                    top: 300,
                    child: Image.asset(
                      'assets/Glob10.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 11 && widget.repetitionCount == 10)
                  Positioned(
                    left: 330,
                    top: 240,
                    child: Image.asset(
                      'assets/Glob10-1.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 15 && widget.repetitionCount == 10)
                  Positioned(
                    left: 600,
                    top: 180,
                    child: Image.asset(
                      'assets/Glob10-2.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                if (_stepCount >= 19 && widget.repetitionCount == 10)
                  Positioned(
                    left: 320,
                    top: 140,
                    child: Image.asset(
                      'assets/Glob10-3.png',
                      width: 80,
                      height: 80,
                    ),
                  ),

                AnimatedPositioned(
                  duration: Duration(milliseconds: _speed),
                  left: _leftPosition,
                  top: _topPosition,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(_movingRight ? 0 : 3.14)
                      ..rotateZ(_calculateRotationAngle()),
                    child: Image.asset(_gifPaths[_currentGifIndex],
                        width: 250, height: 150),
                  ),
                ),
                /*Visibility(
                  visible: displayStops,
                  child: Positioned(
                    bottom: 110,
                    left: 20,
                    child: ContainerPisa(
                      width: screenWidth / 2.8,
                      height: screenHeight / 4,
                    ),
                  ),
                ),
                Visibility(
                  visible: displayStops,
                  child: Positioned(
                    top: 20,
                    left: 20,
                    child: ContainerNapoli(
                      width: screenWidth / 2.8,
                      height: screenHeight / 4,
                    ),
                  ),
                ),
                Visibility(
                  visible: displayStops,
                  child: Positioned(
                    top: 130,
                    right: 20,
                    child: ContainerMannouba(
                      width: screenWidth / 2.8,
                      height: screenHeight / 4,
                    ),
                  ),
                ),
                Visibility(
                  visible: displayStops,
                  child: Positioned(
                    bottom: 70,
                    right: 20,
                    child: ContainerFirenze(
                      width: screenWidth / 2.8,
                      height: screenHeight / 4,
                    ),
                  ),
                ),*/
                Positioned(
                  top: 30,
                  right: 30,
                  child: Container(
                    width: screenWidth / 15,
                    height: screenHeight / 8,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/clock_white.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _formatElapsedTime(_elapsedTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isPaused)
                  Center(
                    child: Stack(
                      children: [


                        _stepCount == 6
                            ? ContainerFirenze(
                            height: screenHeight / 2.1,
                            width: screenWidth / 1.5)
                            : _stepCount == 10
                            ? ContainerPisa(
                            height: screenHeight / 2.1,
                            width: screenWidth / 1.5)
                            : _stepCount == 14
                            ? ContainerMannouba(
                            height: screenHeight / 2.1,
                            width: screenWidth / 1.5)
                            : _stepCount == 18
                            ? ContainerNapoli(
                            height: screenHeight / 2.1,
                            width: screenWidth / 1.5)
                            : const SizedBox(),
                        RepaintBoundary(
                          key: _drawingKey,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(80, 60, 40, 0),
                            width: screenWidth / 2.05,
                            height: screenHeight / 3.0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                if (_isPaused) {
                                  if (!_countdownStarted) {
                                    _startDrawingCountdown();
                                  }
                                  setState(() {
                                    _points.add(details.localPosition);
                                  });
                                }
                              },
                              onPanEnd: (details) {
                                if (_isPaused) {
                                  _points.add(null);
                                }
                              },
                              child: CustomPaint(
                                painter: DrawingPainter(pointsList: _points),
                              ),
                            ),
                          ),
                        ),
                        Positioned(bottom: 20,
                          right: 20,
                          child: ElevatedButton(
                            onPressed: _recognizeDrawing,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffE2037A),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Vérifier',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 10,
                          child: SizedBox(
                            height: screenHeight / 2.0,
                            width: screenWidth / 10,
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth / 18,
                                  height: screenHeight / 9,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/pinktimer.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        _formatElapsedTime(_drawingTimeLeft),
                                        style: const TextStyle(
                                          color: const Color(0xffE2037A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text("x${_repetitions[_stepCount]! - _currentRepetition}",
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      color: Color(0xffE2037A),
                                    )
                                ),
                                SizedBox(height: 20,),
                                if (_resultIcon != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _resultIcon,
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/back_icon.png',
                              width: 35,
                              height: 35,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                      (Route<dynamic> route) => false);
                            },
                            child: Image.asset(
                              'assets/home_icon.png',
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/list_icon.png',
                              width: 35,
                              height: 35,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const LeaderBoardPage()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/settings_icon.png',
                              width: 35,
                              height: 35,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PrincipePage(
                                      showBtn: false,
                                      userId: null,
                                    )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.fromLTRB(0,0,200,30),
              child: FloatingActionButton(

                backgroundColor: const Color(0xffE2037A),
                shape: const CircleBorder(),
                onPressed: _isButtonEnabled ? _moveImage : null,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
