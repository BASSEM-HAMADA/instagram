import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled6/Logic_sign_up/state.dart';

class SignUpCubit extends Cubit<SignupStates> {
  final SupabaseClient supabase;

  SignUpCubit(this.supabase) : super(SignupInitialState());

  // 📝 Sign Up function
  Future<void> signup(String email, String password) async {
    emit(SignupLoadingState());

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(SignupSuccessState());
      } else {
        emit(SignupErrorState("Signup failed, please try again."));
      }
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }

  // 📝 Sign In function
  Future<void> signin(String email, String password) async {
    emit(SignupLoadingState());

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(SignupSuccessState());
      } else {
        emit(SignupErrorState("Login failed, please try again."));
      }
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }
}
