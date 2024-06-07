import 'dart:async';
import 'package:enoxamed_game/inscri_page.dart';
import 'package:enoxamed_game/principe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_player_service.dart';
import 'leaderboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //late AnimationController _controller;
  //late Animation<double> _opacityAnimation;
  late final AudioPlayerService _audioPlayerService;
  late StreamSubscription<bool> _audioStateSubscription;

  @override
  void initState() {
    super.initState();
    /*_controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);*/
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
    //_controller.dispose();
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
        body: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InscriPage()),
            );
          },
          child: Stack(
            children: [
              Image.asset(
                'assets/home_bg.png',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
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
                            SystemNavigator.pop();
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
                          onTap: () {},
                          child: Image.asset(
                            'assets/selected_home_icon.png',
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
              /*Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _opacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: child,
                        );
                      },
                      child: const Text(
                        'PRESS ANYWHERE TO PLAY',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA70DD3),
                        ),
                      ),
                    ),
                  ),
                ),*/
            ],
          ),
        ),
        /*GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InscriPage()),
            );
          },
          child: ,
        ),*/
      ),
    );
  }
}
