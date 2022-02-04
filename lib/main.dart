import 'package:auth_app/data/user_repository/firebase_user_repository.dart';
import 'package:auth_app/data/user_repository/user_repository.dart';
import 'package:auth_app/features/auth/blocs/bloc_auth/auth_bloc.dart';
import 'package:auth_app/features/auth/blocs/cubit_login/login_cubit.dart';
import 'package:auth_app/features/auth/login_screen.dart';
import 'package:auth_app/features/onboarding/blocs/cubit/onboard_cubit.dart';
import 'package:auth_app/features/onboarding/onboarding_screen.dart';
import 'package:auth_app/features/profile/blocs/bloc_account/account_bloc.dart';
import 'package:auth_app/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'data/auth_repository/auth_repository.dart';
import 'data/auth_repository/firebase_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AuthApp());
}

class AuthApp extends StatefulWidget {
  @override
  _AuthAppState createState() => _AuthAppState();
}

class _AuthAppState extends State<AuthApp> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => FirebaseUserRepository(),
        ),
        RepositoryProvider<AuthenticationRepository>(
          //lazy: false,
          create: (context) => FirebaseAuthenticationRepository(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigator,
        builder: (context, child) {
          return BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(
              authenticationRepository: context.read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
            child: authWidget(context, child),
          );
        },
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => BlocProvider(
              create: (context) => LoginCubit(
                    authenticationRepository: context.read<AuthenticationRepository>(),
                  ),
              child: LoginScreen()),
          ProfileScreen.routeName: (context) => MultiBlocProvider(providers: [
                BlocProvider(
                  create: (context) => AccountBloc(
                    userRepository: context.read<UserRepository>(),
                  ),
                ),
              ], child: ProfileScreen()),
          OnBoardingScreen.routeName: (context) => BlocProvider(
              create: (context) => OnboardCubit(
                    userRepository: context.read<UserRepository>(),
                  ),
              child: OnBoardingScreen()),
        },
        //onGenerateRoute: (RouteSettings settings) {},
      ),
    );
  }

  Widget authWidget(BuildContext context, Widget? child) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationBlocStatus.authenticated:
            state.user.introSeen ?? false ? _profileLead() : _onboardingLead();
            break;
          case AuthenticationBlocStatus.unauthenticated:
            _navigator.currentState!.pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
            break;
          default:
            break;
        }
      },
      child: child,
    );
  }

  void _profileLead() {
    _navigator.currentState!.pushNamedAndRemoveUntil(ProfileScreen.routeName, (route) => false);
  }

  void _onboardingLead() {
    _navigator.currentState!.pushNamedAndRemoveUntil(OnBoardingScreen.routeName, (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
