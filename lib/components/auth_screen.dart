import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofia/components/error/http_exception.dart';
import 'package:sofia/components/policy/privacyPolicy.dart';
import 'package:sofia/components/policy/termsCondiction.dart';
import 'package:sofia/services/authService.dart';
import 'package:flutter/gestures.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  void _moveToPolicy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PrivacyPolicy();
        },
      ),
    );
  }

  void _moveToTermsCondiction(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return TermsCondiction();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.indigo[400]!,
                  Colors.red,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200.0),
                      child: Image.asset(
                        'assets/logo-white.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 3 : 2,
                    child: AuthCard(),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 60.0, right: 60, top: 20),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "By clicking sign up you will accept our \n",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "terms and conditions ",
                              style: TextStyle(color: Colors.orange),
                              recognizer: new TapGestureRecognizer()
                                ..onTap =
                                    () => _moveToTermsCondiction(context)),
                          TextSpan(
                              text: "and ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "privacy policy",
                              style: TextStyle(color: Colors.orange),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => _moveToPolicy(context)),
                          TextSpan(
                            text: ".",
                            style: TextStyle(color: Colors.black),
                          ),
                        ])),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 10,
            child: IconButton(
              icon: Image.asset("assets/images/left.png"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Signup;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Something went wrong"),
              content: Text(message),
              actions: [
                TextButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    print(_authData);

    print("click");
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthService>(context, listen: false).signIn(
            email: _authData["email"]!, password: _authData["password"]!);
      } else {
        await Provider.of<AuthService>(context, listen: false).signUp(
            email: _authData["email"]!, password: _authData["password"]!);
      }
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      // Validation data error
      const errorMessage = "Auth failed";
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      const errorMessage = "Something went wrong, Please try again later.";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
    print("END");
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Colors.orange,
                    textColor: Colors.black,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
