import 'dart:async';
import 'dart:math';
import 'package:enoxamed_game/services/database_helper.dart';
import 'package:enoxamed_game/services/users_service.dart';
import 'package:enoxamed_game/widgets/custom_dialog_info.dart';
import 'package:flutter/material.dart';
import 'audio_player_service.dart';
import 'home_page.dart';
import 'leaderboard_page.dart';
import 'recap_page.dart';
import 'principe_page.dart';

class DesPage extends StatefulWidget {
  final int? userId;

  const DesPage({super.key, required this.userId});

  @override
  _DesPageState createState() => _DesPageState();
}

class _DesPageState extends State<DesPage> {
  int _generatedNumber=0;
  String _currentImage = "assets/des.png";
  late final AudioPlayerService _audioPlayerService;
  late StreamSubscription<bool> _audioStateSubscription;
  bool _numberGenerated = false;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerService();
    _audioStateSubscription =
        _audioPlayerService.isPlayingStream.listen((isPlaying) {
      setState(() {});
    });
    if (_audioPlayerService.isPlaying) {
      _audioPlayerService.play();
    }
  }

  @override
  void dispose() {
    _audioStateSubscription.cancel();
    super.dispose();
  }

  void _generateRandomNumber() {
    List<int> numbers = [4, 6, 8, 10];
    _generatedNumber = numbers[Random().nextInt(numbers.length)];
    _updateImage();
    setState(() {
      _numberGenerated = true;
    });

    _updateUserData(context, _generatedNumber!, (_generatedNumber! * 20));
  }

  Future<void> _updateUserData(
      BuildContext context, int nbChallenge, int estimatedTime) async {
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, dynamic> userData = {
      'nbChallenge': nbChallenge,
      'estimatedTime': estimatedTime,
    };
    print(userData);
    try {
      await UsersService().updateUserData(widget.userId!, userData);
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RecapPage(
            generatedNumber: _generatedNumber!,
            userId: widget.userId,
          ),
        ));
      });
    } catch (error) {
      CustomDialog(
              width: screenHeight,
              body: "Une erreur s'est produite",
              title: "Oops! 🙈",
              height: screenHeight,
              context: context)
          .showCustomDialog();
    }
  }

  void _updateImage() {
    switch (_generatedNumber) {
      case 4:
        _currentImage = "assets/cube_4.png";
        break;
      case 6:
        _currentImage = "assets/cube_6.png";
        break;
      case 8:
        _currentImage = "assets/cube_8.png";
        break;
      case 10:
        _currentImage = "assets/cube_10.png";
        break;
      default:
        _currentImage = "assets/des.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
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
                  image: AssetImage("assets/des_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Image.asset(
              'assets/shab.gif',
              width: double.infinity,
            ),
            Positioned(
              bottom: 105,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  'assets/moto-3.gif',
                  width: 320,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE2037A),
                  ),
                  child: Icon(
                    _audioPlayerService.isPlaying
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_audioPlayerService.isPlaying) {
                    _audioPlayerService.pause();
                  } else {
                    _audioPlayerService.play();
                  }
                },
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double imageSize = constraints.maxHeight / 2;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   /* Center(
                      child: Image.asset(
                        _currentImage,
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),*/
                    Center(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Image.asset(
                          _currentImage, // Change this to match your dice images
                          key: ValueKey<int>(_generatedNumber),
                          width: imageSize,
                          height: imageSize,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          if (!_numberGenerated) {
                            _generateRandomNumber();
                          }
                          /*if (_numberGenerated) {
                            await _updateUserData(context, _generatedNumber!,
                                (_generatedNumber! * 6));
                          } else {
                            _generateRandomNumber();
                          }*/
                        },
                        child: Image.asset(
                          'assets/jeter_btn.png',
                          width: 200,
                        ),
                      ),
                    ),
                    /*customButton(
                          _numberGenerated ? "LANCER LE JEU" : "JETER LES DÉS",
                              () async {
                            if (_numberGenerated) {
                              await _updateUserData(context, _generatedNumber!, (_generatedNumber! * 6));
                            } else {
                              _generateRandomNumber();
                            }
                          },
                        ),*/
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          const HomePage()), (Route<dynamic> route) => false);
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
                                builder: (context) => const LeaderBoardPage()),
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
          ],
        ),
      ),
    );
  }
}
