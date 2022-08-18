


import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';


class MaterialInkWell extends StatelessWidget {
  final double? borderRadius;
  final BorderRadius? borderRadiusWidget;
  final double? opacity;
  final Color? color;
  final Color? highlightColor;
  final Widget? child;
  final Function()? onTap;
  const MaterialInkWell({Key? key, this.borderRadius, this.color, this.highlightColor = Colors.black, this.opacity, this.child, this.onTap, this.borderRadiusWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? MainColors.white!,
      borderRadius: borderRadiusWidget ?? BorderRadius.circular(borderRadius ?? 6),
      child: InkWell(
        borderRadius: borderRadiusWidget ?? BorderRadius.circular(borderRadius ?? 6),
        splashColor: Colors.transparent,
        splashFactory: CustomSplashFactory(),
        highlightColor: highlightColor!.withOpacity(opacity ?? 0.10),
        onTap: onTap,
        child: child,
      ),
    );
  }
}




// For testing
const durationMultiplier = 1;
const Duration _kUnconfirmedSplashDuration = Duration(seconds: 1);
const Duration _kSplashFadeInDuration = Duration(milliseconds: 200);

const double _kSplashInitialSize = 0.0; // logical pixels
const double _kSplashConfirmedVelocity = 1.0;

RectCallback? _getClipCallback(RenderBox referenceBox, bool containedInkWell, RectCallback rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell)
    return () => Offset.zero & referenceBox.size;
  return null;
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell, RectCallback rectCallback, Offset position) {
  if (containedInkWell) {
    final Size size = rectCallback != null ? rectCallback().size : referenceBox.size;
    return _getSplashRadiusForPositionInSize(size, position);
  }
  return Material.defaultSplashRadius;
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final double d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final double d2 = (position - bounds.topRight(Offset.zero)).distance;
  final double d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

double _getInitialSplashRadius(RenderBox referenceBox, RectCallback rectCallback,) {
  final Size bounds = rectCallback != null ? rectCallback().size : referenceBox.size;
  final double multiplier = 0.15;
  final double d1 = bounds.topLeft(Offset.zero).distance * multiplier;
  final double d2 = bounds.topRight(Offset.zero).distance * multiplier;
  final double d3 = bounds.bottomLeft(Offset.zero).distance * multiplier;
  final double d4 = bounds.bottomRight(Offset.zero).distance * multiplier;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

class CustomSplashFactory extends InteractiveInkFeatureFactory {
  const CustomSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return CustomSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

/// A visual reaction on a piece of [Material] to user input.
///
/// A circular ink feature whose origin starts at the input touch point
/// and whose radius expands from zero.
///
/// This object is rarely created directly. Instead of creating an ink splash
/// directly, consider using an [InkResponse] or [InkWell] widget, which uses
/// gestures (such as tap and long-press) to trigger ink splashes.
///
/// See also:
///
///  * [InkRipple], which is an ink splash feature that expands more
///    aggressively than this class does.
///  * [InkResponse], which uses gestures to trigger ink highlights and ink
///    splashes in the parent [Material].
///  * [InkWell], which is a rectangular [InkResponse] (the most common type of
///    ink response).
///  * [Material], which is the widget on which the ink splash is painted.
///  * [InkHighlight], which is an ink feature that emphasizes a part of a
///    [Material].
class CustomSplash extends InteractiveInkFeature {
  /// Begin a splash, centered at position relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If `containedInkWell` is true, then the splash will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by `rectCallback`, if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  /// The ink splash is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the splash is removed, `onRemoved` will be called.
  CustomSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    Offset? position,
    Color? color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) : assert(textDirection != null),
        _position = position!,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder!,
        _targetRadius = radius ?? _getTargetRadius(referenceBox, containedInkWell, rectCallback!, position),
        _clipCallback = _getClipCallback(referenceBox, containedInkWell, rectCallback!)!,
        _repositionToReferenceBox = !containedInkWell,
        _textDirection = textDirection,
        super(controller: controller, referenceBox: referenceBox, color: color!, onRemoved: onRemoved) {
    assert(_borderRadius != null);
    _radiusController = AnimationController(duration: _kUnconfirmedSplashDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = _radiusController.drive(Tween<double>(
      //begin: _kSplashInitialSize,
      begin: _getInitialSplashRadius(referenceBox, rectCallback),
      end: _targetRadius,
    ).chain(CurveTween(curve: Curves.decelerate)));
    _alphaController = AnimationController(duration: _kSplashFadeInDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _alpha = _alphaController.drive(IntTween(
      begin: 1,
      end: color.alpha,
    ).chain(CurveTween(curve: Curves.decelerate)));

    controller.addInkFeature(this);
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final ShapeBorder _customBorder;
  final double _targetRadius;
  final RectCallback _clipCallback;
  final bool _repositionToReferenceBox;
  final TextDirection _textDirection;

  late Animation<double> _radius;
  late AnimationController _radiusController;

  late Animation<int> _alpha;
  late AnimationController _alphaController;

  /// Used to specify this type of ink splash for an [InkWell], [InkResponse]
  /// or material [Theme].
  static const InteractiveInkFeatureFactory splashFactory = CustomSplashFactory();

  @override
  void confirm() => _endAnimations();

  @override
  void cancel() => _endAnimations();

  void _endAnimations() {
    if (_alphaController.value < 0.5) {
      _alphaController.animateTo(1, duration: Duration(milliseconds: 100 * durationMultiplier));
    }

    if (_radiusController.status == AnimationStatus.completed) return _reverseAlpha();

    _radiusController
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) _reverseAlpha();
      })
      ..forward();
  }

  void _reverseAlpha() {
    _alphaController
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          //////// print('dispose');
          dispose();
        }
      })
      ..animateBack(0, duration: _kSplashFadeInDuration, curve: Curves.decelerate);
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController.dispose();
    // _alphaController = null;
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()..color = color.withAlpha(_alpha.value);
    Offset center = _position;
    if (_repositionToReferenceBox)
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero), _radiusController.value)!;
    final Offset originOffset = MatrixUtils.getAsTranslation(transform)!;
    canvas.save();
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }
    if (_clipCallback != null) {
      final Rect rect = _clipCallback();
      if (_customBorder != null) {
        canvas.clipPath(_customBorder.getOuterPath(rect, textDirection: _textDirection));
      } else if (_borderRadius != BorderRadius.zero) {
        canvas.clipRRect(RRect.fromRectAndCorners(
          rect,
          topLeft: _borderRadius.topLeft, topRight: _borderRadius.topRight,
          bottomLeft: _borderRadius.bottomLeft, bottomRight: _borderRadius.bottomRight,
        ));
      } else {
        canvas.clipRect(rect);
      }
    }
    canvas.drawCircle(center, _radius.value, paint);
    canvas.restore();
  }
}