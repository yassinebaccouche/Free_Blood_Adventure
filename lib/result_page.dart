import 'package:enoxamed_game/principe_page.dart';
import 'package:enoxamed_game/services/users_service.dart';
import 'package:enoxamed_game/widgets/custom_text_container.dart';
import 'package:enoxamed_game/widgets/custom_transparent_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'audio_player_service.dart';
import 'home_page.dart';
import 'leaderboard_page.dart';

class ResultPage extends StatefulWidget {
  final int? userId;
  final double score;
  final int nbChallenge;
  final int nbChallengeDone;
  final int elapsedTime;
  final int fails;

  const ResultPage(
      {super.key,
      required this.userId,
      required this.score,
      required this.fails,
      required this.nbChallenge,
      required this.nbChallengeDone,
      required this.elapsedTime});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final AudioPlayerService _audioPlayerService;
  late StreamSubscription<bool> _audioStateSubscription;

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LeaderBoardPage()),
          );
        },
        child: Scaffold(
          body: FutureBuilder<String?>(
              future: UsersService().getUserNameById(widget.userId.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/italy_blue_bg.png"),
                            fit: BoxFit.fill,
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
                      Positioned(
                        top: 70,
                        child: SizedBox(
                          width: screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTransparentContainer(
                                  screenWidth / 2.5,
                                  Column(
                                    children: [
                                      const Text(
                                        "RÉSULTAT",
                                        style: TextStyle(
                                            color: Color(0xffE2037A),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      customTextContainer(
                                          screenWidth / 2,
                                          "Nom et Prénom :",
                                          snapshot.data!,
                                          null),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      customTextContainer(
                                          screenWidth / 2,
                                          "Nombre de challenge :",
                                          widget.nbChallenge.toString(),
                                          null),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      customTextContainer(
                                          screenWidth / 2,
                                          "Temps estimé :",
                                          (widget.nbChallenge * 20).toString(),
                                          null),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customTextContainer(
                                          screenWidth / 2,
                                          "Nombre de challenge réalisé :",
                                          widget.nbChallengeDone.toString(),
                                          const Color(0xffE2037A)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      customTextContainer(
                                          screenWidth / 2,
                                          "Temps réalisé :",
                                          (formatTime(widget.elapsedTime)).toString(),
                                          const Color(0xffE2037A)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      customTextContainer(
                                          screenWidth / 2,
                                          "Score :",
                                          (widget.score).toStringAsFixed(3),
                                          const Color(0xffE2037A)),
                                    ],
                                  ),
                                  30),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
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
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
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
                                          builder: (context) =>
                                              const PrincipePage(
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
                  );
                }
              }),
        ),
      ),
    );
  }
  String formatTime(int seconds) {
    if (seconds < 0) {
      return "Invalid input";
    }

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    if (seconds < 60) {
      return "$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    } else if (seconds < 3600) {
      return "$minutes:${secs.toString().padLeft(2, '0')}";
    } else {
      return "$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    }
  }

}
