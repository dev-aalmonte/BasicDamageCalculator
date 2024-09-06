import 'package:flutter/material.dart';
import 'package:ntbd_damage_calculator/widgets/value_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _dmg = 0.0;
  double _dmgFinal = 0.0;
  double _critBonus = 0.0;
  double _dmgBonus = 0.0;

  double _atk = 0.0;
  double _percentage = 0.0;
  double _bonus = 0.0;
  double _crit = 0.0;

  final TextEditingController _atk_controller =
      TextEditingController(text: "0.00");
  final TextEditingController _percentage_controller =
      TextEditingController(text: "0.00");
  final TextEditingController _bonus_controller =
      TextEditingController(text: "0.00");
  final TextEditingController _crit_controller =
      TextEditingController(text: "0.00");

  final FocusNode _atk_focus_node = FocusNode();
  final FocusNode _percentage_focus_node = FocusNode();
  final FocusNode _bonus_focus_node = FocusNode();
  final FocusNode _crit_focus_node = FocusNode();

  @override
  void initState() {
    super.initState();
    _atk_controller.addListener(() {
      double number = double.parse(_atk_controller.text);
      _atk = number;
      _atk_controller.value =
          _atk_controller.value.copyWith(text: number.toStringAsFixed(2));
      _calculateDamage();
    });
    _percentage_controller.addListener(() {
      double number = double.parse(_percentage_controller.text);
      _percentage = number;
      _percentage_controller.value = _percentage_controller.value
          .copyWith(text: number.toStringAsFixed(2));
      _calculateDamage();
    });
    _bonus_controller.addListener(() {
      double number = double.parse(_bonus_controller.text);
      _bonus = number;
      _bonus_controller.value =
          _bonus_controller.value.copyWith(text: number.toStringAsFixed(2));
      _calculateDamage();
    });
    _crit_controller.addListener(() {
      double number = double.parse(_crit_controller.text);
      _crit = number;
      _crit_controller.value =
          _crit_controller.value.copyWith(text: number.toStringAsFixed(2));
      _calculateDamage();
    });
  }

  void _calculateDamage() {
    double finalDamage = 0.0;
    finalDamage = _atk * (_percentage / 100);
    _dmg = finalDamage;
    _dmgBonus = finalDamage * (_bonus / 100);
    finalDamage = finalDamage + (finalDamage * (_bonus / 100));
    _critBonus = finalDamage * (_crit / 100);
    finalDamage = finalDamage + (finalDamage * (_crit / 100));
    finalDamage = finalDamage * _crit;
    setState(() {
      _dmgFinal = finalDamage;
    });
  }

  void _increaseInput(TextEditingController controller) {
    double number = double.parse(controller.text);
    number += 5.0;
    setState(() {
      controller.text = number.toStringAsFixed(2);
    });
  }

  void _decrementInput(TextEditingController controller) {
    double number = double.parse(controller.text);
    number -= 5.0;
    if (number < 0.0) {
      number = 0.0;
    }
    setState(() {
      controller.text = number.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 75, top: 35),
                  child: FinalDamageDisplay(
                    dmg: _dmg,
                    crit: _critBonus,
                  ),
                ),
                ValueContainer(
                  title: "ATK",
                  type: ValueType.base,
                  text_controller: _atk_controller,
                  focus_node: _atk_focus_node,
                  onIncrement: () => _increaseInput(_atk_controller),
                  onDecrement: () => _decrementInput(_atk_controller),
                ),
                const SizedBox(height: 8),
                ValueContainer(
                  title: "Skill",
                  type: ValueType.percentage,
                  text_controller: _percentage_controller,
                  focus_node: _percentage_focus_node,
                  onIncrement: () => _increaseInput(_percentage_controller),
                  onDecrement: () => _decrementInput(_percentage_controller),
                ),
                const SizedBox(height: 8),
                ValueContainer(
                  title: "Bonus",
                  type: ValueType.percentage,
                  text_controller: _bonus_controller,
                  focus_node: _bonus_focus_node,
                  onIncrement: () => _increaseInput(_bonus_controller),
                  onDecrement: () => _decrementInput(_bonus_controller),
                ),
                const SizedBox(height: 8),
                ValueContainer(
                  title: "Crit",
                  type: ValueType.percentage,
                  text_controller: _crit_controller,
                  focus_node: _crit_focus_node,
                  onIncrement: () => _increaseInput(_crit_controller),
                  onDecrement: () => _decrementInput(_crit_controller),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _atk_controller.dispose();
    _percentage_controller.dispose();
    _bonus_controller.dispose();
    _crit_controller.dispose();
    super.dispose();
  }
}

class FinalDamageDisplay extends StatelessWidget {
  const FinalDamageDisplay({
    super.key,
    required double dmg,
    required double crit,
  })  : _dmg = dmg,
        _crit = crit;

  final double _dmg;
  final double _crit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _dmg.toStringAsFixed(2),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Base",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _dmg.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Crit",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _crit.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
