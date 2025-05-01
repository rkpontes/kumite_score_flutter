import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kumite_score/src/app/kumite_score/kumite_score_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;

      double x = 0;
      double y = 0;

      if (width < 600) {
        x = 1600;
        y = 1220;
      } else if (width > 600 && height > 550) {
        x = 1149;
        y = 800;
      } else if (width > 600 && height > 470) {
        x = 1149;
        y = 1000;
      } else {
        x = 1680;
        y = 1220;
      }

      return ScreenUtilInit(
        designSize: Size(x, y),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            title: 'Kumitê Score',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Inknut Antiqua',
            ),
            home: child,
          );
        },
        child: const KumiteScorePage(),
      );
    });
  }
}
