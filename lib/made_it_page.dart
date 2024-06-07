import 'dart:async';
import 'package:enoxamed_game/principe_page.dart';
import 'package:enoxamed_game/result_page.dart';
import 'package:flutter/material.dart';
import 'audio_player_service.dart';
import 'home_page.dart';
import 'leaderboard_page.dart';

class MadeItPage extends StatefulWidget {
  final int? userId;
  final double score;
  final int nbChallenge;
  final int nbChallengeDone;
  final int elapsedTime;
  final int nbFailues;

  const MadeItPage({super.key, required this.userId, required this.score, required this.nbChallenge, required this.nbChallengeDone, required this.elapsedTime,required this.nbFailues});

  @override
  _MadeItPageState createState() => _MadeItPageState();
}

class _MadeItPageState extends State<MadeItPage>
    with SingleTickerProviderStateMixin {
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
    Timer(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(fails:widget.nbFailues,userId: widget.userId, score: widget.score,elapsedTime: widget.elapsedTime,nbChallenge: widget.nbChallenge,nbChallengeDone: widget.nbChallengeDone,)),
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
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/made_it.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
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
