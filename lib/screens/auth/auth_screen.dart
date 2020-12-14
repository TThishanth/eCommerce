import 'package:eCommerce/services/auth_services.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eCommerce/screens/auth/forgot_password_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reTypePasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLogIn = true;
  var _isLoading = false;

  _submitForm(
      String name, String email, String password, BuildContext context) {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        if (_isLogIn) {
          Provider.of<Authentication>(context, listen: false)
              .signIn(email, password, context);
        } else {
          Provider.of<Authentication>(context, listen: false)
              .signUp(name, email, password, context);
        }
      } on FirebaseAuthException catch (e) {
        var message = 'An error occured, Please check your credentials.';

        if (e.message != null) {
          message = e.message;
        }

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ).createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/auth.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Text(
                        _isLogIn ? 'Welcome back' : 'Register User',
                        style: GoogleFonts.righteous(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLogIn)
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Container(
                              height: _size.height * 0.08,
                              width: _size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      fontSize: 14.0,
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Icon(
                                        FontAwesomeIcons.user,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: 'Name',
                                    hintStyle: TextStyle(color: Colors.white60),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.name,
                                  autocorrect: true,
                                  textCapitalization: TextCapitalization.words,
                                  enableSuggestions: false,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your name';
                                    } else if (value.trim().length < 4) {
                                      return 'Username must be atleast 4 letters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: _isLogIn ? 180.0 : 20.0),
                          child: Container(
                            height: _size.height * 0.08,
                            width: _size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.grey[500].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: _emailController,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    fontSize: 14.0,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Icon(
                                      FontAwesomeIcons.envelope,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.white60),
                                ),
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your email address';
                                  } else if (!value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: _size.height * 0.08,
                            width: _size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.grey[500].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    fontSize: 14.0,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Icon(
                                      Icons.lock_outline,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.white60),
                                ),
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                keyboardType: TextInputType.name,
                                textInputAction: _isLogIn
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.trim().length < 7) {
                                    return 'Password must be atleast 7 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        if (!_isLogIn)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              height: _size.height * 0.08,
                              width: _size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: _reTypePasswordController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      fontSize: 14.0,
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Icon(
                                        Icons.lock_outline,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: 'Re-type Password',
                                    hintStyle: TextStyle(color: Colors.white60),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  obscureText: true,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please re-type your password';
                                    } else if (value.trim() !=
                                        _passwordController.text.trim()) {
                                      return 'Password did\'t match, Please re-enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_isLogIn)
                    Container(
                      margin: EdgeInsets.only(right: 25.0),
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        ),
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: _isLogIn ? 30 : 30.0,
                  ),
                  _isLoading
                      ? circularProgress()
                      : Container(
                          height: _size.height * 0.08,
                          width: _size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: FlatButton(
                            onPressed: () => _submitForm(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              context,
                            ),
                            child: Text(
                              _isLogIn ? 'Sign In' : 'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    padding: EdgeInsets.only(bottom: 50.0),
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isLogIn
                              ? 'Don\'t have an account?'
                              : 'Already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _isLogIn = !_isLogIn;
                            });
                          },
                          child: Text(
                            _isLogIn ? 'Create Account' : 'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _reTypePasswordController.dispose();
  }
}
