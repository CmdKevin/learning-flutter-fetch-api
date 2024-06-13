import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_user_list_cubit/user_list/cubit/user_list_state.dart';
import 'package:flutter_user_list_cubit/user_list/model/user.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListState.initial());

  void fetchUser() async {
    try {
      emit(const UserListState.loading());

      Dio dio = Dio();
      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {      
        final List<User> users = res.data.map<User>((d) {
          return User.fromJson(d);
        }).toList();

        emit(UserListState.success(users));
      } else {
        print('res.statusCode= ${res.statusCode}');
        emit(UserListState.error("Error status code ${res.statusCode}"));
      }
    } catch (e) {
      emit(UserListState.error("error loading data: ${e.toString()}"));
    }
  }

  void deleteUser(int index) {
    try {
      final currentState = state;
      if (currentState is UserListSuccess) {
        final updatedUsers = List<User>.from(currentState.users);
        updatedUsers.removeAt(index);
        emit(UserListState.success(updatedUsers));
      }
    } catch (e) {
      emit(UserListState.error("error deleting user: ${e.toString()}"));
    }
  }
}
