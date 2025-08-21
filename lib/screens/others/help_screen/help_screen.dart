import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import 'bloc/help_screen_bloc.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/HelpScreen'),
        builder: (_) => const HelpScreen());
  }
}

class _HelpScreenState extends State<HelpScreen> {
  late final HelpScreenBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<HelpScreenBloc>();
    super.initState();
    _bloc.add(FetchFaqsEvent());
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const LeftArrowBackButton(),
                      Expanded(
                          child: Text(
                        'HelpScreen_help'.localized,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'HelpScreen_faq'.localized,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color:
                            Theme.of(context).colorScheme.primaryElementColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: BlocConsumer<HelpScreenBloc, HelpScreenState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      _onStateChanged(state, context);
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: (state is HelpScreenFetchedFaqsState)
                            ? _listView()
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

  Widget _listView() {
    return ListView.builder(
        itemCount: _bloc.faqs.length,
        itemBuilder: (context, index) {
          final item = _bloc.faqs[index];
          return InkWell(
            onTap: () {
              _bloc.faqs[index].isExpanded = !_bloc.faqs[index].isExpanded;
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        color: AppColors.secondaryElementColor
                            .withValues(alpha: 0.2))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.tilte,
                            style: GoogleFonts.quicksand(
                                color: item.isExpanded
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .primaryElementColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(item.isExpanded
                            ? Icons.arrow_drop_down
                            : Icons.arrow_right)
                      ],
                    ),
                  ),
                  if (item.isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        item.detail,
                        style: GoogleFonts.quicksand(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryElementColor,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }

  void _onStateChanged(HelpScreenState state, BuildContext context) {
    if (state is HelpScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }
}
