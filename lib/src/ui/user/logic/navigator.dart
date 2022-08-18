
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/ui/user/logic/cubit.dart';
import 'package:lifestep/src/ui/user/login/cubit.dart';
import 'package:lifestep/src/ui/user/login/view.dart';
import 'package:lifestep/src/ui/user/otp/cubit.dart';
import 'package:lifestep/src/ui/user/otp/logic/cubit.dart';
import 'package:lifestep/src/ui/user/otp/view.dart';
import 'package:lifestep/src/ui/user/registration/cubit.dart';
import 'package:lifestep/src/ui/user/registration/view.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';

class AuthNavigator extends StatefulWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  _AuthNavigatorState createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      //////// print("------ ${state}");
      return WillPopScope(
        onWillPop: ()async{

          //////// print("otp WillPopScope 2");
          BlocProvider.of<AuthCubit>(context).showLogin();
          return false;
        },
        child: state == AuthState.signUp ? BlocProvider(
          create: (context) => RegistrationBloc(
            authRepo: context.read<UserRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: RegistrationView(),
        ) : state == AuthState.login ? BlocProvider(
          create: (context) => LoginBloc(
            authRepo: context.read<UserRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: AuthView(),
        ) : MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => OtpBloc(
                authRepo: context.read<UserRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => OtpNumpadCubit(
              ),
            ),
          ],
          child: OtpView(),
        ),
      );
    });
  }
}