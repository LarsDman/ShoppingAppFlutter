import 'package:flutter/material.dart';
import 'package:my_app/constants/constants.dart' as constants;
import 'package:my_app/models/custom_exception.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/screens/overview_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  final GlobalKey<FormState> _key = GlobalKey();

  final Map<String, String> _authData = {
    constants.email: '',
    constants.password: '',
    constants.name: "",
  };

  LogingState mode = LogingState.login;

  void _switchAuthMode() {
    if (mode == LogingState.login) {
      setState(() {
        mode = LogingState.signup;
      });
    } else {
      setState(() {
        mode = LogingState.login;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    var snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> networking(LogingState logingState) async {
    if (_key.currentState != null) {
      if (!_key.currentState!.validate()) {
        return;
      }
      _key.currentState!.save();
    }

    if (_authData[constants.name].toString().isEmpty &&
        logingState == LogingState.signup) {
      _showError("Enter a valid name.");
      return;
    }
    if (_authData[constants.email].toString().length <= 4) {
      _showError("Enter a valid email.");
      return;
    }
    if (_authData[constants.password].toString().length <= 5) {
      _showError("Enter a valid password (min. 6 characters).");
      return;
    }

    try {
      if (logingState == LogingState.login ||
          logingState == LogingState.signup) {
        await Provider.of<AuthProvider>(context, listen: false).networking(
          _authData[constants.email] as String,
          _authData[constants.password] as String,
          _authData[constants.name] as String,
          mode,
        );
        Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
      }
    } on CustomException catch (error) {
      var errorMessage = "Authentication failed.";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email already in use.";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Email does not exist.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Wrong password for email.";
      } else if (error.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        errorMessage =
            "You tried to often with the wrong password. Come back later.";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password is too weak.";
      }
      _showError(errorMessage);
    } catch (error) {
      _showError(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCA914),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        splashColor: Colors.red,
        elevation: 0,
        onPressed: () {
          networking(mode);
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  "Shopping List",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
              mode == LogingState.login
                  ? SizedBox(
                      height: 225,
                      child: Card(
                        color: const Color(0xffFDC055),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'E-Mail',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                    onSaved: (value) {
                                      _authData[constants.email] =
                                          value as String;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                    onSaved: (value) {
                                      _authData[constants.password] =
                                          value as String;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      networking(mode);
                                    },
                                    child: const Text(
                                      "Log in!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    )
                  : SizedBox(
                      height: 290,
                      child: Card(
                        color: const Color(0xffFDC055),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onSaved: (value) {
                                    _authData[constants.name] = value as String;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'E-Mail',
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onSaved: (value) {
                                    _authData[constants.email] =
                                        value as String;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onSaved: (value) {
                                    _authData[constants.password] =
                                        value as String;
                                  },
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  networking(mode);
                                },
                                child: const Text(
                                  "Sign up!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
              TextButton(
                onPressed: _switchAuthMode,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  mode == LogingState.login
                      ? "Switch to sign in"
                      : "Switch to log in",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum LogingState {
  login,
  signup,
}
