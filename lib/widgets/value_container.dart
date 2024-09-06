import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ValueType { base, percentage }

class ValueContainer extends StatefulWidget {
  const ValueContainer({
    super.key,
    required this.title,
    required this.type,
    required this.text_controller,
    required this.focus_node,
    required this.onIncrement,
    required this.onDecrement,
  });
  final String title;
  final ValueType type;
  final TextEditingController text_controller;
  final FocusNode focus_node;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  State<ValueContainer> createState() => _ValueContainerState();
}

class _ValueContainerState extends State<ValueContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.type == ValueType.base ? Icons.add : Icons.percent,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.text_controller,
              focusNode: widget.focus_node,
              textDirection: TextDirection.rtl,
              showCursor: false,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DecimalInputFormatter()
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          FeaturedButton(
            icon: Icons.remove,
            onLongPress: widget.onDecrement,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 10),
          FeaturedButton(
            icon: Icons.add,
            onLongPress: widget.onIncrement,
          )
        ],
      ),
    );
  }
}

class FeaturedButton extends StatefulWidget {
  const FeaturedButton({
    super.key,
    required this.icon,
    required this.onLongPress,
    this.foregroundColor,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback onLongPress;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  State<FeaturedButton> createState() => _FeaturedButtonState();
}

class _FeaturedButtonState extends State<FeaturedButton> {
  Timer? _timer;
  int tick = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onLongPress,
      onLongPressStart: (_) {
        _timer = Timer.periodic(
          const Duration(milliseconds: 250),
          (t) {
            tick = t.tick;
            if (tick > 5) {
              _timer?.cancel();
              _timer = Timer.periodic(const Duration(milliseconds: 100),
                  (_) => widget.onLongPress());
            } else {
              widget.onLongPress();
            }
          },
        );
      },
      onLongPressEnd: (_) {
        _timer?.cancel();
        tick = 0;
      },
      child: Container(
        decoration: BoxDecoration(
            color:
                widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ]),
        width: MediaQuery.of(context).size.width * 0.17,
        height: MediaQuery.of(context).size.height * 0.05,
        child: Icon(
          widget.icon,
          color:
              widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(".", "");
    double numericValue = double.tryParse(newText) ?? 0.0;
    String formattedValue = (numericValue / 100).toStringAsFixed(2);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
