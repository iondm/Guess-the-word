import 'package:flutter/material.dart';
import 'package:sofia/components/policy/privacyPolicy.dart';
import 'package:sofia/components/policy/termsCondiction.dart';

class Credits extends StatelessWidget {
  void showAboutDialog({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    List<Widget>? children,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    assert(context != null);
    assert(useRootNavigator != null);
    showDialog<void>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: applicationName,
          applicationVersion: applicationVersion,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
          children: children,
        );
      },
      routeSettings: routeSettings,
    );
  }

  void _moveToPolicy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PrivacyPolicy();
        },
      ),
    );
  }

  void _moveToTermsCondiction(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return TermsCondiction();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("""
Created by:
Ion Drumea

Images and data:
BabelNet https://babelnet.org/
Wikipedia http://www.wikipedia.org   

Logo icon - icon4yu https://thenounproject.com/icon4yu/

Icons from www.flaticon.com:

Sounds: Zapsplat.com




                    """)),
                  ),
                  Column(
                    children: [
                      TextButton(
                        child: Text(
                          "Other licences",
                        ),
                        onPressed: () {
                          showAboutDialog(
                              context: context,
                              applicationName: "Guess the Word",
                              applicationVersion: "Version 0.1");
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Privacy Policy",
                        ),
                        onPressed: () {
                          _moveToPolicy(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Terms & Condition",
                        ),
                        onPressed: () {
                          _moveToTermsCondiction(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.bottom,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.indigo[400]!,
                  Colors.red,
                ],
              )),
            ),
            Positioned(
              left: 15,
              top: 10,
              child: IconButton(
                icon: Image.asset("assets/images/left.png"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
