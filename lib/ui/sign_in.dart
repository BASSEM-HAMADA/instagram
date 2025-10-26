import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/Logic_sign_up/cubit.dart';
import 'package:untitled6/Logic_sign_up/state.dart';
import 'Instagram_Profile_Edit.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const SignInScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color hintColor = isDark ? Colors.white54 : Colors.black54;
    final Color fieldColor = isDark ? Colors.grey[900]! : Colors.grey[200]!;
    final Color footerTextColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: BlocConsumer<SignUpCubit, SignupStates>(
        listener: (context, state) {
          if (state is SignupSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InstagramProfileEdit(),
              ),
            );
          } else if (state is SignupErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 240),
                Text(
                  'Instagram',
                  style: GoogleFonts.pacifico(
                    textStyle: TextStyle(
                      color: textColor.withOpacity(0.9), // ← تخفيف اللون هنا
                      fontWeight: FontWeight.w200,
                      letterSpacing: -1.2,
                      fontSize: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ===== Email Field =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: hintColor),
                        filled: true,
                        fillColor: fieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ===== Password Field =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: hintColor),
                        filled: true,
                        fillColor: fieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),

                // ===== Sign Up Button =====
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context.read<SignUpCubit>().signup(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );
                  },
                  child: Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(0, 163, 255, 1),
                    ),
                    child: Center(
                      child: state is SignupLoadingState
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Already have an account? Login.',
                  style: TextStyle(color: footerTextColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
