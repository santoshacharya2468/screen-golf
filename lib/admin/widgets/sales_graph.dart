import 'package:flutter/material.dart';
import 'package:massageapp/admin/models/sale_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesGraph extends StatefulWidget {
  const SalesGraph({ Key? key }) : super(key: key);

  @override
  _SalesGraphState createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(

            primaryXAxis: CategoryAxis(),
            
            // Chart title
            title: ChartTitle(text: 'Half yearly order analysis',
            alignment: ChartAlignment.near
            ),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
           

            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                dataSource:  <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 40)
                ],
                xValueMapper: (SalesData sales, _) => sales.date,
                yValueMapper: (SalesData sales, _) => sales.totalSell,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]
          );
  }
}