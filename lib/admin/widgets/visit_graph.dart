import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/models/bookmark.dart';
import 'package:massageapp/admin/models/visit.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/group_items.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VisitGraph extends StatefulWidget {
  const VisitGraph({Key? key}) : super(key: key);

  @override
  _VisitGraphState createState() => _VisitGraphState();
}

class _VisitGraphState extends State<VisitGraph> {
  List<Visit> getDataSet() {
    final List<Visit> _visits = [];
    for (var i = 0; i < 7; i++) {
      _visits.add(Visit(
          dateTime: DateTime.now()
              .subtract(Duration(days: math.Random.secure().nextInt(10))),
          total: math.Random.secure().nextInt(1000)));
    }
    return _visits;
  }

  @override
  Widget build(BuildContext context) {
    final shop = Get.find<AuthController>().currentUser.value.shop;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseCollections.SHOP_COLLECTIONS)
          .doc(shop?.id)
          .collection(FirebaseCollections.SHOP_VIEWS)
          .snapshots(),
      builder:
          (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final count = snapshot.hasData && snapshot.data != null
              ? snapshot.data?.docs.length
              : 0;
          final views = <Visit>[];
          snapshot.data?.docs.forEach((element) {
            views.add(Visit(
                dateTime: (element.data()['time'] as Timestamp).toDate(),
                total: 1));
          });
          final data = groupItem<Visit, String>(views,
              labelBuilder: (t) =>
                  '${t.dateTime.year}-${t.dateTime.month}-${t.dateTime.day}',
              valueComparator: (a, b) =>
                  a.dateTime.year == b.dateTime.year &&
                  a.dateTime.month == b.dateTime.month &&
                  a.dateTime.day == b.dateTime.day);

          return Column(
            children: [
              SfCartesianChart(
                  primaryYAxis: NumericAxis(),
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(
                      text: '${translator.total} ${translator.clicks} $count',
                      alignment: ChartAlignment.near),
                  series: <ColumnSeries<Map<String, List<Visit>>, String>>[
                    ColumnSeries<Map<String, List<Visit>>, String>(
                      dataSource: data,
                      xValueMapper: (visit, _) {
                        return visit.keys.first;
                      },
                      yValueMapper: (visit, _) =>
                          visit[visit.keys.first]!.length,
                    )
                  ])
            ],
          );
        } else
          return SizedBox();
      },
    );
  }
}

class BookMarkGraph extends StatefulWidget {
  const BookMarkGraph({Key? key}) : super(key: key);

  @override
  _BookMarkGraphState createState() => _BookMarkGraphState();
}

class _BookMarkGraphState extends State<BookMarkGraph> {
  @override
  Widget build(BuildContext context) {
    final shop = Get.find<AuthController>().currentUser.value.shop;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseCollections.BOOKMARK_COLLECTION)
          .where('shopId', isEqualTo: shop?.id)
          .snapshots(),
      builder:
          (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final count = snapshot.hasData && snapshot.data != null
              ? snapshot.data?.docs.length
              : 0;
          final views = <BookMark>[];
          snapshot.data?.docs.forEach((element) {
            views.add(BookMark(
                dateTime: (element.data()['createdAt'] as Timestamp).toDate(),
                total: 1));
          });
          final data = groupItem<BookMark, String>(views,
              labelBuilder: (t) =>
                  '${t.dateTime.year}-${t.dateTime.month}-${t.dateTime.day}',
              valueComparator: (a, b) =>
                  a.dateTime.year == b.dateTime.year &&
                  a.dateTime.month == b.dateTime.month &&
                  a.dateTime.day == b.dateTime.day);

          return Column(
            children: [
              SfCartesianChart(
                  primaryYAxis: NumericAxis(),
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(
                      text: '${translator.total} ${translator.bookmark} $count',
                      alignment: ChartAlignment.near),
                  series: <ColumnSeries<Map<String, List<BookMark>>, String>>[
                    ColumnSeries<Map<String, List<BookMark>>, String>(
                      dataSource: data,
                      xValueMapper: (visit, _) {
                        return visit.keys.first;
                      },
                      yValueMapper: (visit, _) =>
                          visit[visit.keys.first]!.length,
                    )
                  ])
            ],
          );
        } else
          return SizedBox();
      },
    );
  }
}
