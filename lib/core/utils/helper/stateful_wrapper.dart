import 'package:flutter/widgets.dart';

class StatefulWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onInit;
  final VoidCallback? onDispose;

  const StatefulWrapper({
    super.key,
    required this.child,
    required this.onInit,
    this.onDispose,
  });

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
