import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';

PageRouteBuilder buildPageRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // احصل على اللغة الحالية من LocaleCubit
      final localeCubit = BlocProvider.of<LocaleCubit>(context);
      final isArabic = localeCubit.state.locale.languageCode == 'ar';

      // حدد الاتجاه بناءً على اللغة
      final begin = isArabic ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
