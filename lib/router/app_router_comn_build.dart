// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:skrrskrr/prov/app_prov.dart';
// import 'package:skrrskrr/router/app_screen.dart';
//
// class AppRouterComnBuild extends StatelessWidget {
//   const AppRouterComnBuild({
//     super.key,
//     required this.child,
//     required this.isShowAudioPlayer
//   });
//
//   final Widget child;
//   final bool isShowAudioPlayer;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final AppProv appProv = Provider.of<AppProv>(context, listen: false);
//     appProv.testWidget = child;
//
//     return CustomTransitionPage(
//       child: AppScreen(child: child, isShowAudioPlayer: isShowAudioPlayer),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(opacity: animation, child: child);
//       }
//     );
//
//   }
// }
