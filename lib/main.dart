import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blocs/blocs.dart';
import 'firebase_options.dart';

//SETTINGS AND UTILITIES
import 'config/routes.dart';
import 'repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//LIST SCREEN/PAGE/WIDGETS
import 'screens/login/views/login_page.dart';
import 'screens/add_employee/add_employee.dart';
import 'screens/home/home_page.dart';

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AddEmployeRepository(
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
          )
        ],
        child: MaterialApp(
          title: 'Presence App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: Routes.login,
          routes: {
            Routes.home: (context) => const HomePage(),
            Routes.login: (context) => const LoginPage(),
            Routes.addEmployee: (context) => const AddEmployeePage(),
          },
        ),
      ),
    );
  }
}
