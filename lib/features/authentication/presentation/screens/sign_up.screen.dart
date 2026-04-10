//t2 Core Packages Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neon/Data/Models/App%20User/app_user.model.dart';
import 'package:neon/core/Services/Id%20Generating/id_generating.service.dart';
import 'package:neon/features/authentication/presentation/screens/sign_in.screen.dart';

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
class SignUpScreen extends StatefulWidget {
  //SECTION - Widget Arguments
  //!SECTION
  //
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  //SECTION - State Variables
  //t2 --Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //t2 --Controllers
  //
  //t2 --State
  //t2 --State
  //
  //t2 --Constants
  //t2 --Constants
  //!SECTION

  @override
  void initState() {
    super.initState();
    //
    //SECTION - State Variables initializations & Listeners
    //t2 --Controllers & Listeners
    //t2 --Controllers & Listeners
    //
    //t2 --State
    //t2 --State
    //
    //t2 --Late & Async Initializers
    //t2 --Late & Async Initializers
    //!SECTION
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //
    //SECTION - State Variables initializations & Listeners
    //t2 --State
    //t2 --State
    //!SECTION
  }

  //SECTION - Stateless functions
  //!SECTION

  //SECTION - Action Callbacks
  //!SECTION
  final _formKey = GlobalKey<FormState>();

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
                            l10n.signUpTitle,
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
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  hintText: l10n.firstNameHint,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.firstNameRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: secondNameController,
                                decoration: InputDecoration(
                                  hintText: l10n.secondNameHint,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.secondNameRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
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
                            return null;
                          },
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
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: w,
                          child: PrimaryButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String userId = IdGeneratingService.generate();
                                AppUser appUser = AppUser(
                                  id: userId,
                                  firstName: firstNameController.text,
                                  secondName: secondNameController.text,
                                  email: emailController.text.trim(),
                                );
                                bool? user = await AuthService()
                                    .signUpWithEmailAndPassword(
                                  appUser: appUser,
                                  password: passwordController.text,
                                );
                                if (user && context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            title: l10n.createAccountButton,
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
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          l10n.orDivider,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            height: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: w,
                    child: SecondaryButton(
                      title: l10n.signInNav,
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                          return;
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SignInScreen(),
                          ),
                        );
                      },
                    ),
                  )
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
    //SECTION - Disposable variables
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    //!SECTION
    super.dispose();
  }
}
