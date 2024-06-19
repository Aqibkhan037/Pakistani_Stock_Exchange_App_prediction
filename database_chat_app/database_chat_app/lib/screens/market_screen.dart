import 'package:database_chat_app/screens/stockPredictionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  Map<String, dynamic> indicesData = {};
  List<String> dates = [];
  List<double> closes = [];

  @override
  void initState() {
    super.initState();
    fetchIndicesData();
    fetchDataFromExcel();
  }

  Future<void> fetchIndicesData() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.79:3000/api/indices'));
    if (response.statusCode == 200) {
      setState(() {
        indicesData = json.decode(response.body);
      });
    } else {
      print('Failed to load data');
    }
  }

  Future<void> fetchDataFromExcel() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.43.79:3000/api/readExcel'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> rawDates = data['dates'];
        final List<dynamic> rawCloses = data['closes'];

        setState(() {
          dates = rawDates.map<String>((date) => date.toString()).toList();
          closes = rawCloses.map<double>((close) {
            final String closeStr = close.toString();

            return double.parse(closeStr);
          }).toList();

          closes = closes.reversed.toList();
          dates = dates.reversed.toList();
        });
      } else {
        throw Exception('Failed to load data from Excel');
      }
    } catch (error) {
      print('Error fetching data from server: $error');
    }
  }

  Widget buildLineChart() {
    return Container(
      height: 500, // Set the height to 200 pixels
      width: 300, // Set the width to 300 pixels
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: dates.length.toDouble() - 1,
          minY: closes.reduce((a, b) => a < b ? a : b),
          maxY: closes.reduce((a, b) => a > b ? a : b),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(dates.length, (index) {
                return FlSpot(index.toDouble(), closes[index]);
              }),
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  void openStockPredictionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockPredictionScreen(indicesData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff368983),
      ),
      body: indicesData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                GestureDetector(
                  onTap: () => openStockPredictionScreen(context),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Card(
                      child: ListTile(
                        title: Text(indicesData['name']),
                        subtitle: Text(indicesData['price']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              indicesData['change'],
                              style: TextStyle(
                                color: indicesData['change'].contains('(') &&
                                        indicesData['change'].contains('-')
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            Icon(
                              indicesData['change'].contains('(') &&
                                      indicesData['change'].contains('-')
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: indicesData['change'].contains('(') &&
                                      indicesData['change'].contains('-')
                                  ? Colors.red
                                  : Colors.green,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(child: buildLineChart()), // Add the line chart
              ],
            ),
    );
  }
}











// closes = closes.reversed.toList();
      //    dates = dates.reversed.toList();