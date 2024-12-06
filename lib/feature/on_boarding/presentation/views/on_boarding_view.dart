import 'package:blood_bank/constants.dart';
import 'package:blood_bank/feature/on_boarding/presentation/views/widget/build_nav_bottom.dart';
import 'package:blood_bank/feature/on_boarding/presentation/views/widget/on_boarding_page_view.dart';
import 'package:blood_bank/feature/on_boarding/presentation/views/widget/skip_widget.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController pageController;
  var currentPage = 0;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
          child: Column(
            children: [
              const SizedBox(height: 25),
              SkipWidget(
                currentPage: currentPage,
                pageController: pageController,
              ),
              Expanded(
                child: OnBoardingPageView(
                  pageController: pageController,
                ),
              ),
              const SizedBox(height: 20),
              buildNavigationBar(context, pageController, currentPage),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
