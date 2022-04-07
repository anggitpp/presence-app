import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence_app/views/add_employee/repositories/repositories.dart';
import 'firebase_options.dart';

//SETTINGS AND UTILITIES
import '/config/routes.dart';

//LIST SCREEN/PAGE/WIDGETS
import '/views/add_employee/add_employee.dart';
import '/views/home/home_page.dart';

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
          routes: {
            Routes.home: (context) => const HomePage(),
            Routes.addEmployee: (context) => const AddEmployeePage(),
          },
        ),
      ),
    );
  }
}
