import 'package:auth_app/data/user_repository/model/user.dart';
import 'package:auth_app/features/auth/blocs/cubit_login/login_cubit.dart';
import 'package:auth_app/features/auth/login_screen.dart';
import 'package:auth_app/features/profile/blocs/bloc_account/account_bloc.dart';
import 'package:auth_app/features/profile/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AccountBloc, User>(builder: (context, user) {
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Avatar(photo: user.photo),
              const SizedBox(height: 4),
              Text(user.email ?? '', style: textTheme.headline6),
              const SizedBox(height: 4),
              Text(user.name ?? '', style: textTheme.headline5),
              OutlinedButton.icon(
                key: const Key('homePage_logout_iconButton'),
                onPressed: () {
                  if(user.isEmpty||user.isAnonymous!){
                     Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                  }else{
                     BlocProvider.of<LoginCubit>(context).logoutRequested();}
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                label: Text(
                  user.isAnonymous! ? "LogIn" : "LogOut",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
