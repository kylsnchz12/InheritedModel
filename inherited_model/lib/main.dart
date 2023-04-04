import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'dart:developer' as devtools;

void main() {
  runApp(MaterialApp(
    title: 'Fultter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _color1 = Colors.yellow;
  var _color2 = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: AvailableColorsWidget(
          color1: _color1,
          color2: _color2,
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _color1 = colors.getRandomElement();
                        });
                      },
                      child: const Text("Change color 1")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _color2 = colors.getRandomElement();
                        });
                      },
                      child: const Text("Change color 2"))
                ],
              ),
              const ColorWidget(color: AvailableColors.one),
              const ColorWidget(color: AvailableColors.two)
            ],
          )),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget(
      {Key? key,
      required this.color1,
      required this.color2,
      required Widget child})
      : super(key: key, child: child);

  static AvailableColorsWidget of(
      BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log('Color1 widget got rebuilt!');
        break;
      case AvailableColors.two:
        devtools.log('Color2 widget got rebuilt!');
        break;
    }

    final provider = AvailableColorsWidget.of(context, color);

    return Container(
        height: 100,
        color:
            color == AvailableColors.one ? provider.color1 : provider.color2);
  }
}

final colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.cyan,
  Colors.deepPurple,
  Colors.amber
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}
