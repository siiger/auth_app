import 'package:auth_app/features/auth/widgets/social_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'blocs/cubit_login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, 1 / 2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*Image.asset(
                'assets/bloc_logo_small.png',
                height: 40,
              ),
              */
              Text(
                'Social media',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              SocialMediaWidget(
                signInWithFacebook: null,
                signInWithGoogle: () => BlocProvider.of<LoginCubit>(context).logInWithGoogle(),
                signInWithApple: null,
                signInAnonymously: () => BlocProvider.of<LoginCubit>(context).logInAnonymously(),
              ),
              /* SizedBox(width: 20),
              OutlinedButton.icon(
                key: const Key('homePage_logout_iconButton'),
                onPressed: () => BlocProvider.of<LoginCubit>(context).logoutRequested(),
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                label: Text(
                  "LogOut",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
