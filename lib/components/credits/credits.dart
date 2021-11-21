import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
Play button, Coins-Reward, Coming-soon, Coins, Start, Arrow, Unknown, Monument, Vechicle, Correct symbol -  Freepik https://www.freepik.com" 
Sports - Pause08 https://www.flaticon.com/authors/pause08
Medal - Vectors Market https://www.flaticon.com/authors/vectors-market
Game-play button - abdul-allib https://www.flaticon.com/authors/abdul-allib
Logout - wahyu-adam https://www.flaticon.com/authors/wahyu-adam
items - pixel-perfect https://www.flaticon.com/authors/pixel-perfect
End race - eight-black-dots https://www.flaticon.com/authors/eight-black-dots 
Music Instruments - surang https://www.flaticon.com/authors/surang

Sounds: Zapsplat.com




                """)),
              ),
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
      ),
    );
  }
}
