import 'package:enoxamed_game/leaderboard_page.dart';
import 'package:enoxamed_game/model/user.dart';
import 'package:enoxamed_game/principe_page.dart';
import 'package:enoxamed_game/services/users_service.dart';
import 'package:enoxamed_game/widgets/custom_dialog_info.dart';
import 'package:enoxamed_game/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'audio_player_service.dart';
import 'home_page.dart';

class InscriPage extends StatefulWidget {
  const InscriPage({
    super.key,
  });

  @override
  _InscriPageState createState() => _InscriPageState();
}

class _InscriPageState extends State<InscriPage> {
  late final AudioPlayerService _audioPlayerService;
  late StreamSubscription<bool> _audioStateSubscription;

  final TextEditingController _fullnameCntrl = TextEditingController();
  final TextEditingController _phoneCntrl = TextEditingController();
  final TextEditingController _emailCntrl = TextEditingController();
  bool _isLoading = false;
  late int userId;

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerWidth = screenWidth / 2.7;
    double imageWidth = screenWidth / 4;
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
                  image: AssetImage("assets/inscri_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: 60,
              child: SizedBox(
                height: screenHeight,
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                child: IntrinsicHeight(
                                  child: Material(
                                    elevation: 20,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: containerWidth,
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 20, 30, 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "INSCRIPTION",
                                            style: TextStyle(
                                                color: Color(0xffE2037A),
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          customTextFormField(
                                              _fullnameCntrl,
                                              'Nom et Prénom',
                                              'assets/person_icon.png',
                                              TextInputType.text,
                                              TextInputAction.next),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          customTextFormField(
                                              _phoneCntrl,
                                              'Tél.',
                                              'assets/phone_icon.png',
                                              TextInputType.phone,
                                              TextInputAction.next),
                                          const SizedBox(height: 5.0),
                                          customTextFormField(
                                              _emailCntrl,
                                              'E-mail',
                                              'assets/email_icon.png',
                                              TextInputType.emailAddress,
                                              TextInputAction.done),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              onTap: () async {

                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  RegExp regex =
                                                  RegExp(r"^[25349]\d{7}$");
                                                  RegExp regexEmail = RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                                if (_fullnameCntrl.text.length < 3) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                      CustomDialog(
                                                          body: "Votre nom doit contenir au moins 3 caractères",
                                                          title: "Oops! 🙈",
                                                          height:
                                                          screenHeight,
                                                          width:
                                                          screenWidth,
                                                          context: context)
                                                          .showCustomDialog();
                                                    }
                                                 else if (!regex.hasMatch(_phoneCntrl.text)) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                    CustomDialog(
                                                        body: "Le numéro de téléphone doit comporter 8 chiffres et commencer par 2, 5, 3, 4 ou 9",
                                                        title: "Oops! 🙈",
                                                        height:
                                                        screenHeight,
                                                        width:
                                                        screenWidth,
                                                        context: context)
                                                        .showCustomDialog();
                                                  }
                                                else if (!regexEmail.hasMatch(_emailCntrl.text)) {

                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                    CustomDialog(
                                                        body: "L'adresse mail doit être une adresse valide",
                                                        title: "Oops! 🙈",
                                                        height:
                                                        screenHeight,
                                                        width:
                                                        screenWidth,
                                                        context: context)
                                                        .showCustomDialog();
                                                  }
                                                  else if (_emailCntrl.text.isEmpty ||
                                                      _phoneCntrl
                                                          .text.isEmpty ||
                                                      _fullnameCntrl
                                                          .text.isEmpty) {
                                                    CustomDialog(
                                                            width: screenHeight,
                                                            body:
                                                                "Merci de remplir tous les champs du formulaire",
                                                            title: "Oops! 🙈",
                                                            height:
                                                                screenHeight,
                                                            context: context)
                                                        .showCustomDialog();
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  } else {
                                                    int result =
                                                        await UsersService()
                                                            .addUser(User(
                                                      fullName:
                                                          _fullnameCntrl.text,
                                                      email: _emailCntrl.text,
                                                      phoneNumber:
                                                          _phoneCntrl.text,
                                                    ));
                                                    if (result > 0) {
                                                      userId = result;
                                                      print(userId);
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PrincipePage(
                                                            showBtn: true,
                                                            userId: userId,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      CustomDialog(
                                                              body: result == -1
                                                                  ? "Le numéro ou l'e-mail est déjà utilisé. Veuillez en choisir un autre !"
                                                                  : "Impossible d'effectuer l'opération !",
                                                              title: "Oops! 🙈",
                                                              height:
                                                                  screenHeight,
                                                              width:
                                                                  screenWidth,
                                                              context: context)
                                                          .showCustomDialog();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }

                                              },
                                              child: Image.asset(
                                                'assets/valider_btn.png',
                                                width: 200,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -120,
                                left: (containerWidth - imageWidth) / 2,
                                child: Image.asset(
                                  'assets/logoform.png',
                                  width: imageWidth,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
            /*Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/your_image.png',
                            color: Colors.white,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff0068B3),
                          ),
                          child: const Icon(Icons.home, color: Colors.white),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff0068B3),
                          ),
                          child:
                              const Icon(Icons.list_alt, color: Colors.white),
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
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff0068B3),
                          ),
                          child:
                              const Icon(Icons.settings, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrincipePage(
                                      showBtn: false,
                                    )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
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
      ),
    );
  }
}
