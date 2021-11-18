import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:vchat/main.dart';
import 'package:vchat/screens/auth_screens/enter_phone.dart';
import 'package:vchat/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Welcome extends ConsumerWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Consumer(builder: (context, ref, _) {
              final isDark = ref.watch(themeProvider).isDark;
              return SvgPicture.asset('assets/vchat.svg',
                  fit: BoxFit.contain,
                  color: isDark ? Colors.white : Colors.black);
            }),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  callback: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EnterPhone(),
                      ),
                    );
                  },
                  width: 80.w,
                  name: 'Get Started',
                ),
                SizedBox(height: 10.h)
              ],
            ),
          )
        ],
      ),
    );
  }
}
