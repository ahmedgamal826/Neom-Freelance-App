//t2 Core Packages Imports
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neon/features/authentication/presentation/screens/sign_up.screen.dart';

import '../../../../core/locale/app_localizations.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/Services/Auth/auth_service.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class SignInScreen extends StatefulWidget {
  //SECTION - Widget Arguments
  //!SECTION
  //
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEmailSignInLoading = false;
  bool _isGoogleSignInLoading = false;

  bool get _isAnyLoading => _isEmailSignInLoading || _isGoogleSignInLoading;

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //t2 -Values
    final l10n =
        AppLocalizations(context.watch<LocaleProvider>().locale);
    double w = MediaQuery.of(context).size.width;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/app_logo.png",
                            width: 80,
                            height: 80,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            l10n.signInTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: l10n.emailHint,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.emailRequired;
                            }
                            String pattern =
                                r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return l10n.emailInvalid;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: l10n.passwordHint,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.passwordRequired;
                            } else if (value.length < 8) {
                              return l10n.passwordMinLength;
                            }
                            return null;
                          },
                        ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      // TextButton(
                      //     onPressed: () {},
                      //     child: const Text(
                      //       "نسيت كلمة المرور؟",
                      //     )),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: w,
                        child: PrimaryButton(
                          onPressed: () async {
                            if (_isAnyLoading) {
                              return;
                            }

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isEmailSignInLoading = true;
                              });

                              final user = await AuthService()
                                  .signInWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text,
                              );

                              if (!mounted) {
                                return;
                              }

                              if (user == null) {
                                _showErrorMessage(
                                  l10n.signInFailed,
                                );
                              }

                              setState(() {
                                _isEmailSignInLoading = false;
                              });
                            }
                          },
                          title: _isEmailSignInLoading
                              ? l10n.signingIn
                              : l10n.signInButton,
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      l10n.orDivider,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: w,
                child: OutlinedButton.icon(
                  onPressed: _isAnyLoading
                      ? null
                      : () async {
                          setState(() {
                            _isGoogleSignInLoading = true;
                          });

                          final user = await AuthService().signInWithGoogle();

                          if (!mounted) {
                            return;
                          }

                          if (user == null) {
                            _showErrorMessage(
                              l10n.googleSignInFailed,
                            );
                          }

                          setState(() {
                            _isGoogleSignInLoading = false;
                          });
                        },
                  icon: _isGoogleSignInLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const FaIcon(
                          FontAwesomeIcons.google,
                          size: 18,
                        ),
                  label: Text(l10n.signInWithGoogle),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: w,
                  child: SecondaryButton(
                      title: l10n.createAccount,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SignUpScreen(),
                          ),
                        );
                      }))
            ],
          ),
        ),
      ),
        ),
        SafeArea(
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LanguageToggleButton(
                iconColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
    //!SECTION
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
