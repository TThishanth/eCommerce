import 'package:eCommerce/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _resetPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _resetPasswordKey = GlobalKey<ScaffoldState>();

  _submitResetForm(String email, BuildContext context) {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      Provider.of<Authentication>(context, listen: false)
          .resetPassword(email)
          .whenComplete(() {
        SnackBar snackBar = SnackBar(
          content: Text('A password reset link has been sent to ' + email),
          backgroundColor: Colors.orange,
        );

        _resetPasswordKey.currentState.showSnackBar(snackBar);
      });
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
            key: _resetPasswordKey,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70.0),
                    child: Center(
                      child: Text(
                        'Forgot Password',
                        style: GoogleFonts.righteous(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Please enter your email, We will send instruction to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 180.0),
                          child: Container(
                            height: _size.height * 0.08,
                            width: _size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.grey[500].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: _resetPasswordController,
                                decoration: InputDecoration(
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
                                textInputAction: TextInputAction.done,
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: _size.height * 0.08,
                    width: _size.width * 0.8,
                    margin: EdgeInsets.only(bottom: 100.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: FlatButton(
                      onPressed: () => _submitResetForm(
                          _resetPasswordController.text.trim(), context),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
    _resetPasswordController.dispose();
  }
}
