import 'package:flutter/material.dart';

class CustomYesNoDialog extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function()? onYesPressed;
  final Color primaryColor;

  CustomYesNoDialog({
    required this.title,
    required this.content,
    required this.onYesPressed,
    required this.primaryColor,
  });


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: FractionallySizedBox(
        widthFactor: 0.45,
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 16)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(content, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12)),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: ()=>Navigator.of(context).pop(),
                        style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20)))),
                        child: Text('Non', style: TextStyle(color: primaryColor, fontSize: 10)),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: TextButton(
                        onPressed: (){
                          if (onYesPressed != null) {
                            onYesPressed!();
                          }
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryColor)),
                        child: const Text('Oui', style: TextStyle(color: Colors.white, fontSize: 10)),
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
  }
}