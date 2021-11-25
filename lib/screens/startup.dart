import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vchat/main.dart';
import 'package:vchat/screens/auth_screens/profile_setup.dart';
import 'package:vchat/screens/get_started.dart';

class StartUp extends ConsumerWidget {
  const StartUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authPro = ref.read(authProvider);
    final pages = [
      const GetStartedPage(),
      // const EnterPhone(),
      // OtpVerification(),
      const ProfileSetup(),
    ];

    return WillPopScope(
      onWillPop: () async {
        int curIndex = authPro.curPage;
        if (curIndex == 0) {
          return false;
        } else if (curIndex == 1) {
          authPro.moveToPage(0);
          return false;
        }
        return false;
      },
      child: Consumer(
        builder: (context, ref, _) {
          return PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final curIndex = ref.watch(authProvider).curPage;
              return pages[curIndex];
            },
          );
        },
      ),
    );
  }
}
