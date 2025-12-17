import 'package:flutter/widgets.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseWrapper extends StatefulWidget {
  const ShowcaseWrapper({super.key, required this.child, required this.showcaseKeys});

  final Widget child;
  final List<GlobalKey> showcaseKeys;

  @override
  State<ShowcaseWrapper> createState() => _ShowcaseWrapperState();
}

class _ShowcaseWrapperState extends State<ShowcaseWrapper> {
  late final String _scope = 'showcase_${identityHashCode(this)}';
  bool _hasRegistered = false;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _registerShowcase();
  }

  void _registerShowcase() {
    if (_hasRegistered) return;
    ShowcaseView.register(scope: _scope);
    _hasRegistered = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasStarted || widget.showcaseKeys.isEmpty) return;
      ShowcaseView.getNamed(_scope).startShowCase(widget.showcaseKeys);
      _hasStarted = true;
    });
  }

  @override
  void didUpdateWidget(covariant ShowcaseWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hasStarted && widget.showcaseKeys.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _hasStarted) return;
        ShowcaseView.getNamed(_scope).startShowCase(widget.showcaseKeys);
        _hasStarted = true;
      });
    }
  }

  @override
  void dispose() {
    if (_hasRegistered) {
      ShowcaseView.getNamed(_scope).unregister();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
