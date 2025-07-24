import 'package:first_flutter_app/data/services/auth_api.dart';
import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/utils.dart';
import 'package:first_flutter_app/views/pages/register_page.dart';
import 'package:first_flutter_app/views/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController(text: 'test@example.com');
  final pwController = TextEditingController(text: 'password');
  bool isLoading = false;
  bool isPasswordVisible = true;

  void onLoginPressed() async {
    final email = emailController.text.trim();
    final password = pwController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Utils.showError('Please enter both email and password', context);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Utils.showError('Please enter a valid email address', context);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await AuthApi.login(email, password);
      final token = response.token;
      if (token.isEmpty) {
        throw Exception('No token received from server');
      }

      await AuthProvider.saveToken(token, ref);
      await AuthProvider.saveUserData(response.user);
      await AuthProvider.initializeAuth(ref);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WidgetTree()),
        (route) => false,
      );
    } catch (e) {
      Utils.showError(
        e is String ? e : 'Login failed. Please try again.',
        context,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final FocusNode passwordFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return FractionallySizedBox(
                  widthFactor: screenWidth > 500 ? 0.5 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lotties/home.json'),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: emailController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      emailController.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        focusNode: passwordFocus,
                        controller: pwController,
                        obscureText: isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),

                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      FilledButton(
                        onPressed: () {
                          onLoginPressed();
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 40.0),
                        ),
                        child: Text(widget.title),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text("New at Texmeta, Join Now"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // class LoginPage extends StatefulWidget {
  //   const LoginPage({super.key, required this.title});

  //   final String title;

  //   @override
  //   State<LoginPage> createState() => _LoginPageState();
  // }

  // class _LoginPageState extends State<LoginPage> {
  //   TextEditingController emailController = TextEditingController(
  //     text: 'sujon@gmail.com',
  //   );
  //   TextEditingController pwController = TextEditingController(text: 'password');
  //   bool isPasswordVisible = true;
  //   // @override
  //   // void initState() {
  //   //   // TODO: implement initState
  //   //   super.initState();
  //   // }

  //   bool isLoading = false;

  //   @override
  //   void dispose() {
  //     emailController.dispose();
  //     pwController.dispose();
  //     super.dispose();
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     double screenWidth = MediaQuery.of(context).size.width;
  //     return Scaffold(
  //       appBar: AppBar(),
  //       body: Center(
  //         child: SingleChildScrollView(
  //           child: Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: LayoutBuilder(
  //               builder: (context, BoxConstraints constraints) {
  //                 if (isLoading) {
  //                   return const Center(child: CircularProgressIndicator());
  //                 }
  //                 return FractionallySizedBox(
  //                   widthFactor: screenWidth > 500 ? 0.5 : 1.0,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Lottie.asset('assets/lotties/home.json'),
  //                       SizedBox(height: 20.0),
  //                       TextField(
  //                         controller: emailController,
  //                         decoration: InputDecoration(
  //                           labelText: 'Email',
  //                           hintText: 'Email',
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                           ),
  //                           suffixIcon: emailController.text.isNotEmpty
  //                               ? IconButton(
  //                                   icon: Icon(Icons.close),
  //                                   onPressed: () {
  //                                     setState(() {
  //                                       emailController = TextEditingController(
  //                                         text: '',
  //                                       );
  //                                     });
  //                                   },
  //                                 )
  //                               : null,
  //                         ),
  //                         onEditingComplete: () {
  //                           setState(
  //                             () {},
  //                           ); // Update the UI when the name changes
  //                         },
  //                       ),
  //                       SizedBox(height: 10.0),
  //                       TextField(
  //                         controller: pwController,
  //                         obscureText: isPasswordVisible,
  //                         decoration: InputDecoration(
  //                           labelText: 'Password',
  //                           hintText: 'Password',
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                           ),
  //                           suffixIcon: IconButton(
  //                             icon: Icon(
  //                               isPasswordVisible
  //                                   ? Icons.visibility_off
  //                                   : Icons.visibility,
  //                             ),
  //                             onPressed: () {
  //                               setState(() {
  //                                 isPasswordVisible = !isPasswordVisible;
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                         onEditingComplete: () {
  //                           setState(
  //                             () {},
  //                           ); // Update the UI when the name changes
  //                         },
  //                       ),
  //                       SizedBox(height: 20.0),
  //                       FilledButton(
  //                         onPressed: () {
  //                           onLoginPressed();
  //                         },
  //                         style: FilledButton.styleFrom(
  //                           minimumSize: Size(double.infinity, 40.0),
  //                         ),
  //                         child: Text(widget.title),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   void onLoginPressed() async {
  //   final email = emailController.text.trim();
  //   final password = pwController.text.trim();

  //   if (email.isEmpty || password.isEmpty) {
  //     showError('Please enter both email and password');
  //     return;
  //   }

  //   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
  //     showError('Please enter a valid email address');
  //     return;
  //   }

  //   setState(() => isLoading = true);

  //   try {
  //     final response = await AuthApi.login(email, password);
  //     final token = response.token;
  //     if (token == null) {
  //       throw Exception('No token received from server');
  //     }

  //     await AuthService.saveToken(token, ref);
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => WidgetTree()),
  //       (route) => false,
  //     );
  //   } catch (e) {
  //     showError(e is String ? e : 'Login failed. Please try again.');
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }

  //   Future<void> saveToken(String token) async {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('auth_token', token);
  //   }

  //   void showError(String message) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(message)));
  //   }

  // void onLoginPressed() {
  //   if (emailController.text == confirmedEmail &&
  //       pwController.text == confirmedPassword) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return WidgetTree();
  //         },
  //       ),
  //       (route) => false, // Remove all previous routes
  //     );
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
  //   }
  // }
}
