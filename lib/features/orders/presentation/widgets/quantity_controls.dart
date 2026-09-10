import 'dart:async';

import 'package:flutter/material.dart';

class QuantityControls extends StatefulWidget {
  final int maxInventory;
  final int quantity;
  final int index;
  final void Function({required int index, required int quantity})
  onQuantityChanged;

  const QuantityControls({
    super.key,
    required this.maxInventory,
    required this.quantity,
    required this.onQuantityChanged,
    required this.index,
  });

  @override
  State<QuantityControls> createState() => _QuantityControlsState();
}

class _QuantityControlsState extends State<QuantityControls> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantity = widget.quantity;
    _controller.text = quantity.toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //  increment
          _HoldableButton(
            onPressed: () {
              // ensures that we don't exceed the current inventory
              if (quantity < widget.maxInventory) {
                widget.onQuantityChanged(
                  index: widget.index,
                  quantity: quantity + 1,
                );
              }
            },
            icon: Icons.add_circle_outline_rounded,
            ignoring: !(quantity < widget.maxInventory),
          ),

          //
          SizedBox(width: 45, child: _quantity()),

          //  decrement
          _HoldableButton(
            onPressed: () {
              // min quantity is 1
              if (quantity < 2) return;

              widget.onQuantityChanged(
                index: widget.index,
                quantity: quantity - 1,
              );
            },
            ignoring: quantity < 2,
            icon: Icons.remove_circle_outline_rounded,
          ),
        ],
      ),
    );
  }

  Widget _quantity() {
    return TextField(
      //
      onChanged: (newQuantity) {
        // ensure the user can't enter more then maxInventory
        int quantity = int.tryParse(newQuantity) ?? 0;
        if (quantity > widget.maxInventory) {
          quantity = widget.maxInventory;
        }
        widget.onQuantityChanged(index: widget.index, quantity: quantity);
      },
      onTap: () => _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      ),
      onTapOutside: (event) => _focusNode.unfocus(),
      controller: _controller,
      focusNode: _focusNode,
      textAlign: TextAlign.center,
      decoration: InputDecoration(border: InputBorder.none),
      keyboardType: TextInputType.number,
    );
  }
}

class _HoldableButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool ignoring;

  const _HoldableButton({
    required this.icon,
    required this.onPressed,
    this.ignoring = false,
  });

  @override
  State<_HoldableButton> createState() => _HoldableButtonState();
}

class _HoldableButtonState extends State<_HoldableButton> {
  Timer? _timer;

  void _startHolding() {
    if (_timer != null) return;
    widget.onPressed();

    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      widget.onPressed();
    });
  }

  void _stopHolding() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.ignoring,
      child: Listener(
        onPointerDown: (_) => _startHolding(),
        onPointerUp: (_) => _stopHolding(),
        onPointerCancel: (_) => _stopHolding(),
        child: Icon(
          widget.icon,
          weight: 30,
          color: widget.ignoring ? Theme.of(context).disabledColor : null,
        ),
      ),
    );
  }
}
