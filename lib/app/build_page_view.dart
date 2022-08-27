// import 'package:flutter/material.dart';
//
// class ExpandablePageView extends StatefulWidget {
//   final List<Widget> children;
//   final List<String> items;
//
//   const ExpandablePageView({
//     key,
//     required this.children,
//     required this.items,
//   }) : super(key: key);
//
//   @override
//   _ExpandablePageViewState createState() => _ExpandablePageViewState();
// }
//
// class _ExpandablePageViewState extends State<ExpandablePageView>
//     with TickerProviderStateMixin {
//   PageController? _pageController;
//   List<double>? _heights;
//   int _currentPage = 0;
//
//   double get _currentHeight => _heights![_currentPage];
//
//   @override
//   void initState() {
//     _heights = widget.children.map((e) => 0.0).toList();
//     super.initState();
//     _pageController = PageController() //
//       ..addListener(() {
//         final _newPage = _pageController?.page?.round();
//         if (_currentPage != _newPage) {
//           setState(() => _currentPage = _newPage!);
//         }
//       });
//   }
//
//   @override
//   void dispose() {
//     _pageController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 // shrinkWrap: true,
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _pageController?.animateToPage(
//                               index,
//                               duration: Duration(milliseconds: 100),
//                               curve: Curves.easeIn,
//                             );
//                           });
//                         },
//                         child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 8, right: 8, top: 4, bottom: 2),
//                             child: Text(widget.items[index],
//                                 style: TextStyle(
//                                     color: index == _currentPage
//                                         ? Colors.red
//                                         : Colors.black))),
//                       ),
//                       if (index == _currentPage)
//                         Container(
//                           width: 40,
//                           height: 3,
//                           color: Colors.red,
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               child: Text("Khai "),
//               onPressed: () {},
//             ),
//             ElevatedButton(
//               child: Text("Khai "),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         Divider(),
//         TweenAnimationBuilder<double>(
//           curve: Curves.easeInOutCubic,
//           duration: const Duration(milliseconds: 100),
//           tween: Tween<double>(begin: _heights![0], end: _currentHeight),
//           builder: (context, value, child) =>
//               SizedBox(height: value, child: child),
//           child: PageView(
//             controller: _pageController,
//             children: _sizeReportingChildren
//                 .asMap() //
//                 .map((index, child) => MapEntry(index, child))
//                 .values
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   List<Widget> get _sizeReportingChildren => widget.children
//       .asMap() //
//       .map(
//         (index, child) => MapEntry(
//           index,
//           OverflowBox(
//             //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
//             minHeight: 0,
//             maxHeight: double.infinity,
//             alignment: Alignment.topCenter,
//             child: SizeReportingWidget(
//               onSizeChange: (size) =>
//                   setState(() => _heights?[index] = size.height),
//               child: Align(child: child),
//             ),
//           ),
//         ),
//       )
//       .values
//       .toList();
// }
//
// class SizeReportingWidget extends StatefulWidget {
//   final Widget child;
//   final ValueChanged<Size> onSizeChange;
//
//   const SizeReportingWidget({
//     key,
//     required this.child,
//     required this.onSizeChange,
//   }) : super(key: key);
//
//   @override
//   _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
// }
//
// class _SizeReportingWidgetState extends State<SizeReportingWidget> {
//   Size? _oldSize;
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance?.addPostFrameCallback((_) => _notifySize());
//     return widget.child;
//   }
//
//   void _notifySize() {
//     if (!this.mounted) {
//       return;
//     }
//     final size = context.size;
//     if (_oldSize != size) {
//       _oldSize = size;
//       widget.onSizeChange(size!);
//     }
//   }
// }
