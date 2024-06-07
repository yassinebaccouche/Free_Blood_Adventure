import 'package:enoxamed_game/map_page.dart';
import 'package:enoxamed_game/principe_page.dart';
import 'package:enoxamed_game/widgets/custom_text_container.dart';
import 'package:enoxamed_game/widgets/custom_transparent_container.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'audio_player_service.dart';
import 'home_page.dart';
import 'leaderboard_page.dart';

class RecapPage extends StatefulWidget {
  final int generatedNumber;
  final int? userId;

  const RecapPage(
      {super.key, required this.generatedNumber, required this.userId});

  @override
  _RecapPageState createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
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
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapPage(
                  userId: widget.userId,
                  repetitionCount: widget.generatedNumber,
                )),
      );
    });
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
      child: Scaffold(
        body: Stack(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customTransparentContainer(
                        screenWidth / 2.5,
                        Column(
                          children: [
                            const Text(
                              "RÉCAPITULATIF",
                              style: TextStyle(
                                  color: Color(0xffE2037A),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            customTextContainer(
                                screenWidth / 2,
                                "Nombre de challenge :",
                                "${widget.generatedNumber}",
                                null),
                            const SizedBox(
                              height: 10,
                            ),
                            customTextContainer(
                                screenWidth / 2,
                                "Temps de jeu estimé :",
                                "${widget.generatedNumber * 20}s",
                                null),
                          ],
                        ),
                        70),
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
