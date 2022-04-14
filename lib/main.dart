import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:presence_app/blocs/home/home_cubit.dart';
import 'package:presence_app/screens/new_password/new_password_page.dart';
import 'blocs/blocs.dart';
import 'firebase_options.dart';

//SETTINGS AND UTILITIES
import 'config/routes.dart';
import 'repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//LIST SCREEN/PAGE/WIDGETS
import 'screens/add_employee/add_employee.dart';
import 'screens/home/home.dart';
import 'screens/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        print(snapshot.data);
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => AddEmployeRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
            RepositoryProvider(
              create: (context) => LoginRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
            RepositoryProvider(
              create: (context) => NewPasswordRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
            RepositoryProvider(
              create: (context) => HomeRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AddEmployeeBloc>(
                create: (context) => AddEmployeeBloc(
                  addEmployeRepository: context.read<AddEmployeRepository>(),
                ),
              ),
              BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(
                  loginRepository: context.read<LoginRepository>(),
                ),
              ),
              BlocProvider<NewPasswordCubit>(
                create: (context) => NewPasswordCubit(
                  newPasswordRepository: context.read<NewPasswordRepository>(),
                ),
              ),
              BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(
                  homeRepository: context.read<HomeRepository>(),
                ),
              ),
            ],
            child: MaterialApp(
              title: 'Presence App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: snapshot.data != null ? Routes.home : Routes.login,
              routes: {
                Routes.home: (context) => const HomePage(),
                Routes.login: (context) => const LoginPage(),
                Routes.newPassword: (context) => const NewPasswordPage(),
                Routes.addEmployee: (context) => const AddEmployeePage(),
              },
            ),
          ),
        );
      },
    );
  }
}
