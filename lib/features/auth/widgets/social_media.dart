import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaWidget extends StatelessWidget {
  final VoidCallback? signInWithFacebook;
  final VoidCallback? signInWithGoogle;
  final VoidCallback? signInAnonymously;
  final VoidCallback? signInWithApple;

  const SocialMediaWidget({
    Key? key,
    this.signInWithFacebook,
    this.signInWithGoogle,
    this.signInWithApple,
    this.signInAnonymously,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        /*SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: signInWithFacebook,
            child: const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
          ),
        ),
        */
        SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: signInWithGoogle,
            child: const Icon(FontAwesomeIcons.google, color: Colors.blue),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: signInWithApple,
            child: const Icon(FontAwesomeIcons.apple, color: Colors.blue),
          ),
        ),
        SizedBox(width: 10),
        /*SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: signInAnonymously,
            child: const Icon(FontAwesomeIcons.mask, color: Colors.blue),
          ),
        ),
        */
      ],
    );
  }
}
