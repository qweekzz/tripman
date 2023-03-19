import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripman/authentication/authentication_repository.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/counter/bloc/counter_bloc.dart';
import 'package:tripman/date/bloc/date_bloc.dart';
import 'package:tripman/dateBase/DataBase_repository.dart';
import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';
import 'package:tripman/pages/BlocNavigate.dart';
import 'package:tripman/pages/homePage.dart';
import 'package:tripman/pages/loginPage.dart';
import 'package:tripman/routers/router.gr.dart';
import 'package:tripman/test/bloc/test_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(AuthenticationRepository())
            ..add(AuthenticationStarted()),
        ),
        BlocProvider<FormsBloc>(
          create: (context) => FormsBloc(AuthenticationRepository()),
        ),
        BlocProvider<DateBloc>(
          create: (context) => DateBloc(),
        ),
        BlocProvider<DateBaseBloc>(
          create: (context) => DateBaseBloc(DatabaseRepositoryImpl()),
        ),
        BlocProvider<TestBloc>(
          create: (context) => TestBloc(),
        ),
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
    // MultiBlocProvider(
    //   providers: [
    //     BlocProvider<AuthenticationBloc>(
    //       create: (context) => AuthenticationBloc(AuthenticationRepository())
    //         ..add(AuthenticationStarted()),
    //     ),
    //     BlocProvider<FormsBloc>(
    //       create: (context) => FormsBloc(AuthenticationRepository()),
    //     ),
    //   ],
    //   child: const MyApp(),
    // ),