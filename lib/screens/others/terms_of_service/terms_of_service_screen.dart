import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import 'bloc/terms_of_service_bloc.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/TermsOfServiceScreen'),
        builder: (_) => const TermsOfServiceScreen());
  }
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  late final TermsOfServiceBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<TermsOfServiceBloc>();
    super.initState();
    _bloc.add(FetchTermsOfServiceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: -150, // Adjust top margin as needed
              right: -150, // Adjust right margin as needed
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -100, // Adjust top margin as needed
              left: -100, // Adjust right margin as needed
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      const LeftArrowBackButton(),
                      Expanded(
                          child: Text(
                        'TermsScreen_title'.localized,
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryElementColor,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(
                        width: 50,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child:
                          BlocConsumer<TermsOfServiceBloc, TermsOfServiceState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      _onStateChanged(state, context);
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: (state is TermsOfServiceFetchedState)
                            ? SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                primary: true,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      state.content,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryElementColor),
                                    ))
                                  ],
                                ))
                            : const Center(
                                child: Loader(),
                              ),
                      );
                    },
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onStateChanged(TermsOfServiceState state, BuildContext context) {
    if (state is TermsOfServiceApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }
}
