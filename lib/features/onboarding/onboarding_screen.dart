import 'package:auth_app/features/onboarding/blocs/cubit/onboard_cubit.dart';
import 'package:auth_app/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  static const String routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'OnBoarding Screen',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
              onPressed: () {
                BlocProvider.of<OnboardCubit>(context).seenNews();
                Navigator.of(context).pushNamedAndRemoveUntil(ProfileScreen.routeName, (route) => false);
              },
              icon: Icon(Icons.skip_next_rounded, size: 24),
              label: Text(
                "Next Screen",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
