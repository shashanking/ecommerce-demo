// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// typedef RebuildFactor = bool Function(MediaQueryData old, MediaQueryData data);

// typedef ScreenUtilInitBuilder = Widget Function(
//   BuildContext context,
//   Widget? child,
// );

// class RebuildFactors {
//   const RebuildFactors._();

//   static bool size(MediaQueryData old, MediaQueryData data) {
//     return old.size != data.size;
//   }

//   static bool orientation(MediaQueryData old, MediaQueryData data) {
//     return old.orientation != data.orientation;
//   }

//   static bool sizeAndViewInsets(MediaQueryData old, MediaQueryData data) {
//     return old.viewInsets != data.viewInsets;
//   }

//   static bool all(MediaQueryData old, MediaQueryData data) {
//     return old != data;
//   }
// }

// class ScreenUtilInit extends StatefulWidget {
//   /// A helper widget that initializes [ScreenUtil]
//   const ScreenUtilInit(
//       {Key? key,
//       required this.builder,
//       this.child,
//       this.rebuildFactor = RebuildFactors.size,
//       this.designSize = ScreenUtil.defaultSize,
//       this.splitScreenMode = false,
//       this.minTextAdapt = false,
//       this.useInheritedMediaQuery = false,
//       this.scaleByHeight = false})
//       : super(key: key);

//   final ScreenUtilInitBuilder builder;
//   final Widget? child;
//   final bool splitScreenMode;
//   final bool minTextAdapt;
//   final bool useInheritedMediaQuery;
//   final bool scaleByHeight;
//   final RebuildFactor rebuildFactor;

//   /// The [Size] of the device in the design draft, in dp
//   final Size designSize;

//   @override
//   State<ScreenUtilInit> createState() => _ScreenUtilInitState();
// }

// class _ScreenUtilInitState extends State<ScreenUtilInit>
//     with WidgetsBindingObserver {
//   MediaQueryData? _mediaQueryData;

//   bool wrappedInMediaQuery = false;

//   WidgetsBinding get binding => WidgetsFlutterBinding.ensureInitialized();

//   MediaQueryData get mediaQueryData => _mediaQueryData!;

//   MediaQueryData get newData {
//     if (widget.useInheritedMediaQuery) {
//       final data = MediaQuery.maybeOf(context);

//       if (data != null) {
//         wrappedInMediaQuery = true;
//         return data;
//       }
//     }

//     // ignore: deprecated_member_use
//     return MediaQueryData.fromView(binding.window);
//   }

//   Widget get child {
//     return widget.builder.call(context, widget.child);
//   }

//   _updateTree(Element el) {
//     el.markNeedsBuild();
//     el.visitChildren(_updateTree);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // mediaQueryData = newData;
//     binding.addObserver(this);
//   }

//   @override
//   void didChangeMetrics() {
//     final old = _mediaQueryData!;
//     final data = newData;

//     if (widget.scaleByHeight || widget.rebuildFactor(old, data)) {
//       _mediaQueryData = data;
//       _updateTree(context as Element);
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _mediaQueryData ??= newData;
//     didChangeMetrics();
//   }

//   @override
//   void dispose() {
//     binding.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (mediaQueryData.size == Size.zero) return const SizedBox.shrink();
//     if (!wrappedInMediaQuery) {
//       return MediaQuery(
//         // key: GlobalObjectKey('mediaQuery'),
//         data: mediaQueryData,
//         child: Builder(
//           builder: (context) {
//             final deviceData = MediaQuery.maybeOf(context);
//             final deviceSize = deviceData?.size ?? widget.designSize;
//             ScreenUtil.init(
//               context,
//               designSize: widget.designSize,
//               splitScreenMode: widget.splitScreenMode,
//               minTextAdapt: widget.minTextAdapt,
//             );
//             return SizedBox(
//                 width: deviceSize.width,
//                 height: deviceSize.height,
//                 child: FittedBox(
//                   fit: BoxFit.none,
//                   alignment: Alignment.center,
//                   child: SizedBox(
//                     width: widget.scaleByHeight
//                         ? (deviceSize.height * widget.designSize.width) /
//                             widget.designSize.height
//                         : deviceSize.width,
//                     height: deviceSize.height,
//                     child: child,
//                   ),
//                 ));
//           },
//         ),
//       );
//     }

//     ScreenUtil.init(
//       context,
//       designSize: widget.designSize,
//       splitScreenMode: widget.splitScreenMode,
//       minTextAdapt: widget.minTextAdapt,
//     );
//     final deviceData = MediaQuery.maybeOf(context);

//     final deviceSize = deviceData?.size ?? widget.designSize;
//     return SizedBox(
//       width: deviceSize.width,
//       height: deviceSize.height,
//       child: FittedBox(
//         fit: BoxFit.none,
//         alignment: Alignment.center,
//         child: SizedBox(
//           width: widget.scaleByHeight
//               ? (deviceSize.height * widget.designSize.width) /
//                   widget.designSize.height
//               : deviceSize.width,
//           height: deviceSize.height,
//           child: child,
//         ),
//       ),
//     );
//   }
// }
