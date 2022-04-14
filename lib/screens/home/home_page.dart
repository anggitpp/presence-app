import 'package:flutter/material.dart';
import 'package:presence_app/blocs/home/home_cubit.dart';
import 'package:presence_app/config/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.signOutStatus == SignOutStatus.success) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      },
      builder: (context, state) {
        print(state.signOutStatus);
        return Scaffold(
          floatingActionButton: state.signOutStatus != SignOutStatus.submitting
              ? FloatingActionButton(
                  onPressed: () => context.read<HomeCubit>().signOut(),
                  child: const Icon(Icons.logout),
                )
              : const CircularProgressIndicator(),
          appBar: AppBar(
            title: const Text('Home View'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.addEmployee),
                icon: const Icon(Icons.person),
              )
            ],
          ),
          body: const Center(),
        );
      },
    );
  }
}
