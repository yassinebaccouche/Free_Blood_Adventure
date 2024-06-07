import 'dart:async';
import 'package:enoxamed_game/des_page.dart';
import 'package:enoxamed_game/home_page.dart';
import 'package:flutter/material.dart';
import 'audio_player_service.dart';
import 'leaderboard_page.dart';

class PrincipePage extends StatefulWidget {
  final bool showBtn;
  final int? userId;

  const PrincipePage({super.key, required this.showBtn, required this.userId});

  @override
  PrincipePageState createState() => PrincipePageState();
}

class PrincipePageState extends State<PrincipePage> {
  late final AudioPlayerService _audioPlayerService;
  late StreamSubscription<bool> _audioStateSubscription;

  @override
  void initState() {
    super.initState();
    print("PrincipePage");
    print(widget.userId);
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
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/principe_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Image.asset(
              'assets/shab.gif',
              width: screenWidth,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showBtn)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DesPage(userId: widget.userId,),
                            ));
                          },
                          child: Image.asset(
                            'assets/commencer_btn.png',
                            width: 200,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
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
                        const SizedBox(width: 5,),
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
                        const SizedBox(width: 5,),
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
                        const SizedBox(width: 5,),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/selected_settings_icon.png',
                              width: 35,
                              height: 35,
                            ),
                            onTap: () {
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
