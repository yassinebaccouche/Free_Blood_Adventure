import 'dart:async';
import 'dart:ui';
import 'package:enoxamed_game/home_page.dart';
import 'package:enoxamed_game/model/user.dart';
import 'package:enoxamed_game/principe_page.dart';
import 'package:enoxamed_game/services/users_service.dart';
import 'package:enoxamed_game/widgets/custom_dialog_info.dart';
import 'package:enoxamed_game/widgets/custom_text_form_field.dart';
import 'package:enoxamed_game/widgets/custom_yes_no_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'audio_player_service.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
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

  List<User> users = [];
  bool _isLoading = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    final double? columnSpacing;


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
              future: UsersService().getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Color(0xffE2037A),
                      size: 50.0,
                    ),
                  );
                } else {
                  users = snapshot.data!;
                  return Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/leaderboard_bg.png"),
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
                        top: 18,
                        left: 20,
                        child: SizedBox(
                          width: screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth / 1.3,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "LISTE DES PARTICIPANTS",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xffE2037A),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      'assets/monument.png',
                                      width: screenWidth / 4,
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: screenHeight / 2,
                                  width: screenWidth / 1.3,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage("assets/bg.png"),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: users.isEmpty
                                      ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                                      child: Text(
                                        "Pas de participants !",
                                        style: TextStyle(color: Colors.grey, fontSize: 18),
                                      ),
                                    ),
                                  )
                                      : Column(
                                    children: [
                                      // Fixed header row
                                      Container(


                                        child: Row(
                                          children: const [

                                            Expanded(child: Text('Nom & prénom', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                            SizedBox(width: 50),
                                            Expanded(child: Text('Numéro de Tél', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                            Expanded(child: Text('Nb de challenge', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                            Expanded(child: Text('Temps estimé', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                            Expanded(child: Text('Nb de challenge réalisé', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold))),
                                            Expanded(child: Text('Temps réalisé', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                            Expanded(child: Text('Score', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                            // Adjust the width as needed
                                            SizedBox(width: 50),
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,

                                            child: DataTable(
                                              columnSpacing: 60.0,
                                              headingRowHeight: 0, // Remove the default heading row height
                                              dataRowHeight: 32,

                                              columns: [
                                                DataColumn(label: Container()), // Empty column for spacing
                                                DataColumn(label: Container()),
                                                DataColumn(label: Container()),
                                                DataColumn(label: Container()),
                                                DataColumn(label: Container()),
                                                DataColumn(label: Container()),
                                                DataColumn(label: Container()),
                                                DataColumn(label: Container()),

                                              ],
                                              rows: users.map((user) {
                                                return DataRow(cells: [
                                                  DataCell(Text(user.fullName!, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Text(user.phoneNumber!, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Text(user.nbChallenge!.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Text(user.estimatedTime!.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Text(user.nbChallengeDone!.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Text(user.actualTime!.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Text((user.score!).toStringAsFixed(3), style: const TextStyle(fontSize: 10, color: Colors.grey))),
                                                  DataCell(Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () => _showUpdateDialog(context, user, screenHeight, screenWidth),
                                                        child: const Icon(Icons.edit_rounded, color: Color(0xff0068B3), size: 18),
                                                      ),
                                                      InkWell(
                                                        onTap: () => _showDeleteDialog(context, user.id!),
                                                        child: const Icon(Icons.delete_forever_rounded, color: Color(0xffE2037A), size: 18),
                                                      ),
                                                    ],
                                                  )),
                                                ]);
                                              }).toList(),
                                              headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              dataRowColor: MaterialStateProperty.all(Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )

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
                                    'assets/selected_list_icon.png',
                                    width: 35,
                                    height: 35,
                                  ),
                                  onTap: () {

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
                  );
                }
              },
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

  void _showDeleteDialog(BuildContext context, int userId) {
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomYesNoDialog(
          title: 'Supprimer le participant',
          content: 'Êtes-vous sûr de vouloir supprimer ce participant?',
          onYesPressed: () async {
            setState(() {
              _isLoading = true;
            });
            try {
              await UsersService().deleteUser(userId);
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            } catch (error) {
              setState(() {
                _isLoading = false;
              });
              CustomDialog(
                  width: screenHeight,
                  body:
                  "Impossible de supprimer le participant!",
                  title: "Oops! 🙈",
                  height: screenHeight,
                  context: context)
                  .showCustomDialog();
            }
          },
          primaryColor: const Color(0xffE2037A),
        );
      },
    );
  }

  Future<void> _showUpdateDialog(BuildContext context, User user,double screenHeight,double screenWidth) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    nameController.text = user.fullName!;
    emailController.text = user.email!;
    phoneController.text = user.phoneNumber!;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mise à jour',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16)),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  customTextFormField( nameController, 'Nom et Prénom', 'assets/person_icon.png', TextInputType.text, TextInputAction.next),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  customTextFormField( phoneController, 'Tél.', 'assets/phone_icon.png', TextInputType.phone, TextInputAction.next),
                                  const SizedBox(height: 10),
                                  customTextFormField( emailController, 'E-mail', 'assets/email_icon.png', TextInputType.emailAddress, TextInputAction.done),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xffE2037A),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Annuler',
                            style: TextStyle(color: Color(0xffE2037A), fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () async {
                            RegExp regex =
                            RegExp(r"^[25349]\d{7}$");
                            RegExp regexEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                            if (nameController.text.length < 3) {
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
                            else if (!regex.hasMatch(phoneController.text)) {
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
                            else if (!regexEmail.hasMatch(emailController.text)) {
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
                            else if (emailController.text.isEmpty ||
                                phoneController
                                    .text.isEmpty ||
                                nameController
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
                              await _updateUserData(
                                  context,
                                  user.id!,
                                  nameController.text,
                                  emailController.text,
                                  phoneController.text);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffE2037A)),
                          ),
                          child: const Text(
                            'Appliquer',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateUserData(BuildContext context, int userId, String name,
      String email, String phone) async {
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, dynamic> userData = {
      'fullName': name,
      'email': email,
      'phoneNumber': phone,
    };
    try {
      await UsersService().updateUserData(userId, userData);
      int index = users.indexWhere((user) => user.id == userId);
      setState(() {
        users[index].fullName = name;
        users[index].email = email;
        users[index].phoneNumber = phone;
      });
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      CustomDialog(
        width: screenHeight,
        body:
        "Impossible de modifier le participant!",
        title: "Oops! 🙈",
        height: screenHeight,
        context: context,
      ).showCustomDialog();
    }
  }
}
