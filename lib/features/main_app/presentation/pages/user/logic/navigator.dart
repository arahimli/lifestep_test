
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/login/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/login/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/registration/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/registration/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';

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
          child: const RegistrationView(),
        ) : state == AuthState.login ? BlocProvider(
          create: (context) => LoginBloc(
            authRepo: context.read<UserRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const AuthView(),
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
          child: const OtpView(),
        ),
      );
    });
  }
}