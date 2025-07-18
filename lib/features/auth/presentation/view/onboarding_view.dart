import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view/signup_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<OnbordingViewModel>(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 361,
                        width: 450,
                        child: Image.asset('assets/image/onboarding.png'),
                      ),
                      const Text(
                        "Borrow and lend easily Quickly!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Inter Bold',
                        ),
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "Borrow easily and conveniently, with quick access anytime, anywhere.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: 'Inter Regular',
                        ),
                      ),
                      const SizedBox(height: 33),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // This now works because the ViewModel is provided above.
                            context.read<OnbordingViewModel>().add(
                              NavigateToLoginView(
                                context: context,
                                destination: LoginView(),
                              ),
                            );
                          },
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter Regular',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // This also works correctly now.
                            context.read<OnbordingViewModel>().add(
                              NavigateToSignupView(
                                context: context,
                                destination: SignupView(),
                              ),
                            );
                          },
                          child: const Text(
                            "I'm new, sign me up",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Inter Regular',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
