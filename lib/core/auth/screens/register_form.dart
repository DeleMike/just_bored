import 'package:flutter/material.dart';
import 'package:just_bored/core/auth/providers/auth_controller.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_extensions.dart';
import '../../../configs/constants.dart';

/// Regsiter form
class RegisterForm extends StatefulWidget {
  /// Regsiter form
  const RegisterForm({super.key, required this.wantsToLogin});

  final bool wantsToLogin;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Initially password is obscure
  bool _obscureText = true;
  bool _obscureText2 = true;
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _userData = {};

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authReader = context.read<AuthController>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kPaddingM),
            child: TextFormField(
              key: const ValueKey('name'),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              //textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                labelText: 'Full name',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                filled: true,
                fillColor: kCanvasColor.withOpacity(0.3),
              ),
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Your name cannot be empty';
                }
                if (!value.isValidName) {
                  return 'Invalid name';
                }
                return null;
              },
              // onFieldSubmitted: (value) {
              //   FocusScope.of(context).nextFocus();
              // },
              onSaved: (value) {
                _userData['fullname'] = value;
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPaddingM),
            child: TextFormField(
              key: const ValueKey('email'),
              keyboardType: TextInputType.emailAddress,
              // textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                labelText: 'Email',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                filled: true,
                fillColor: kCanvasColor.withOpacity(0.3),
              ),
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email cannot be empty';
                }
                if (!value.isValidEmail) {
                  return 'Invalid email';
                }
                return null;
              },
              // onFieldSubmitted: (value) {
              //   FocusScope.of(context).nextFocus();
              // },
              onSaved: (value) {
                _userData['email'] = value;
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPaddingM),
            child: TextFormField(
              controller: _passwordController,
              key: const ValueKey('password'),
              keyboardType: TextInputType.visiblePassword,
              // textInputAction: TextInputAction.next,
              obscureText: _obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: _obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                ),
                labelText: 'Password',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                filled: true,
                fillColor: kCanvasColor.withOpacity(0.3),
              ),
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password cannot be empty';
                }

                if (!value.isValidPassword) {
                  return 'Invalid password';
                }
                return null;
              },
              // onFieldSubmitted: (value) {
              //   FocusScope.of(context).nextFocus();
              // },
              onSaved: (value) {
                _userData['password'] = value;
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPaddingM),
            child: TextFormField(
              key: const ValueKey('c_password'),
              keyboardType: TextInputType.visiblePassword,
              // textInputAction: TextInputAction.done,
              obscureText: _obscureText2,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText2 = !_obscureText2;
                    });
                  },
                  icon: _obscureText2 ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                ),
                labelText: 'Confirm Password',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                filled: true,
                fillColor: kCanvasColor.withOpacity(0.3),
              ),
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password cannot be empty';
                }

                if (_passwordController.text.toString() != value) {
                  return 'Your password do not match';
                }

                if (!value.isValidPassword) {
                  return 'Invalid password';
                }
                return null;
              },
              onSaved: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingM, vertical: kPaddingS - 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: Size(kScreenWidth(context) * 0.8, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () async {
                await authReader.createUserWithEmailAndPassword(
                    context: context, data: _userData, formKey: _formKey);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'REGISTER',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("OR"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingM, vertical: kPaddingS - 4),
            child:
            //  authWatcher.isAuthenticating
            //     ? const Center(child: CircularProgressIndicator())
            //     :
                 ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kWhite,
                minimumSize: Size(kScreenWidth(context) * 0.8, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () async {
                await authReader.createUserOrSignInWithGoogleAcct(context: context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        height: 25,
                        width: 25,
                      ),
                      child: Image.asset(
                        AssetsImages.googleIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: kScreenWidth(context) * 0.05),
                    Text(
                      'Register with Google',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account with us?',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kPrimaryColor),
              ),
              SizedBox(width: kScreenWidth(context) * 0.05),
              TextButton(
                onPressed: () {
                  authReader.setLogin(widget.wantsToLogin);
                },
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
