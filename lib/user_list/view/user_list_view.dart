import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_list_cubit/user_list/cubit/user_list_cubit.dart';
import 'package:flutter_user_list_cubit/user_list/cubit/user_list_state.dart';
import 'package:flutter_user_list_cubit/user_list/view/user_detail_page.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListCubit(), // Provide your UserListCubit instance here
      child: Scaffold(
        body: BlocBuilder<UserListCubit, UserListState>(
          builder: (context, state) {
            if (state is UserListSuccess) {
              // Success
              return Scaffold(
                body: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(  
                        radius: 20,
                        child: Text(
                          state.users[index]
                            .title.substring(0, 1)
                            .toUpperCase(),
                        ),
                      ),
                      title: Text(state.users[index].title),
                      subtitle: Text(
                        state.users[index].body.length > 55 
                        ? '${state.users[index].body.substring(0, 55)}...'
                        : state.users[index].body,
                      ),
                      onTap: () {
                        print(state.users[index].title);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UserDetailPage(
                                  user: state.users[index]
                                ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Confirmation"),
                              content: Text("Are you sure you want to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("CANCEL"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Panggil fungsi untuk menghapus data di sini
                                    context.read<UserListCubit>().deleteUser(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("DELETE"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () => context.read<UserListCubit>().fetchUser(),
                ),
              );
            } else if (state is UserListError) {
              // Error
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    ElevatedButton(
                      child: const Text("Refresh"),
                      onPressed: () => context.read<UserListCubit>().fetchUser(),
                    ),
                  ],
                ),
              );
            } else if (state is UserListLoading) {
              // Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // Initial / First time
              return Center(
                child: ElevatedButton(
                  child: const Text("Refresh"),
                  onPressed: () => context.read<UserListCubit>().fetchUser(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
