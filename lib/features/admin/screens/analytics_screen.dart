import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sabthok/features/admin/models/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    Sales sales1 = Sales('Vegetables', 123);
    Sales sales2 = Sales('Junk Food', 950);
    Sales sales3 = Sales('Fruits', 23);
    Sales sales4 = Sales('Recipes', 532);
    Sales sales5 = Sales('Fast Food', 4332);
    List<Sales> earnings = [sales1, sales2, sales3, sales4, sales5];
    return Column(
      children: [
        Text(
          'Total Earnings: \$5980',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 250,
          child: CategoryProductsChart(seriesList: [
            charts.Series(
              id: 'Sales',
              data: earnings,
              domainFn: (Sales sales, _) => sales.label,
              measureFn: (Sales sales, _) => sales.earning,
            ),
          ]),
        )
      ],
    );
  }
}

class CategoryProductsChart extends StatelessWidget {
  final List<charts.Series<Sales, String>> seriesList;
  const CategoryProductsChart({
    Key? key,
    required this.seriesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
