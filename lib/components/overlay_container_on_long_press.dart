import 'package:flutter/material.dart';

typedef OverlayableContainerOnLongPressBuilder = Function(
    BuildContext context, VoidCallback hideOverlay);

class OverlayableContainerOnLongPress extends StatefulWidget {
  const OverlayableContainerOnLongPress({
    super.key,
    required this.child,
    required this.overlayContentBuilder,
    this.onTap,
  });

  final Widget child;
  final OverlayableContainerOnLongPressBuilder overlayContentBuilder;
  final VoidCallback? onTap;

  @override
  State<OverlayableContainerOnLongPress> createState() =>
      _OverlayableContainerOnLongPressState();
}

class _OverlayableContainerOnLongPressState
    extends State<OverlayableContainerOnLongPress> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlayEntry();
    super.dispose();
  }

  //Remove overlay on tap/on-demand
  void _removeOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  //Calculate where to show the overlay
  Rect _getPosition(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset topLeft = box.size.topLeft(box.localToGlobal(Offset.zero));
    final Offset bottomRight =
    box.size.bottomRight(box.localToGlobal(Offset.zero));
    return Rect.fromLTRB(
        topLeft.dx, topLeft.dy, bottomRight.dx, bottomRight.dy);
  }

  //Display image on top of image item
  void _showOverlayOnTopOfItem(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    final Rect overlayPosition = _getPosition(overlayState.context);

    final Rect widgetPosition = _getPosition(context).translate(
      -overlayPosition.left,
      -overlayPosition.top,
    );

    //Display overlay entry
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () {
          //Remove overlay when user taps outside
          _removeOverlayEntry();
        },
        child: Material(
          color: Colors.black12,
          child: CustomSingleChildLayout(
            delegate: _OverlayableContainerLayout(widgetPosition),
            child: widget.overlayContentBuilder(context, _removeOverlayEntry),
          ),
        ),
      );
    });

    overlayState.insert(
      _overlayEntry!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      onLongPress: () {
        _showOverlayOnTopOfItem(context);
      },
      child: widget.child,
    );
  }
}

class _OverlayableContainerLayout extends SingleChildLayoutDelegate {
  _OverlayableContainerLayout(this.position);

  final Rect position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(Size(position.width, position.height));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(position.left, position.top);
  }

  @override
  bool shouldRelayout(_OverlayableContainerLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}