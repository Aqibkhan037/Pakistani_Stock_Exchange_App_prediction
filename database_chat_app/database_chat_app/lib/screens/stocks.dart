import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stockDetaildScreen.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  bool isALoading = true;
  List<Map<String, String>> tableData = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Indices',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff368983),
      ),
      body: Center(
        child: isALoading
            ? const CircularProgressIndicator()
            : (tableData.isNotEmpty)
                ? ListView.builder(
                    itemCount: tableData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StockDetailScreen(
                                  stockDetails: tableData[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                '${tableData[index]['symbol']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Rate: ${tableData[index]['currentRate']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Change: ${tableData[index]['change']}',
                                    style: TextStyle(
                                      color: tableData[index]['change']!
                                              .contains('-')
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'Change Percentage: ${tableData[index]['changePercentage']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${tableData[index]['change']}',
                                    style: TextStyle(
                                      color: tableData[index]['change']!
                                              .contains('-')
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  Icon(
                                    tableData[index]['change']!.contains('-')
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: tableData[index]['change']!
                                            .contains('-')
                                        ? Colors.red
                                        : Colors.green,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : errorMessage.isNotEmpty
                    ? Text(
                        'Error: $errorMessage',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      )
                    : const Text(
                        'No data available.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
      ),
    );
  }

  void _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.43.79:3000/api/scrape'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        List<Map<String, String>> data = [];

        for (var item in jsonResponse) {
          data.add({
            'symbol': item['symbol'],
            'currentRate': item['currentRate'],
            'change': item['change'],
            'changePercentage': item['changePercentage'],
          });
        }

        setState(() {
          tableData = data;
          isALoading = false;
        });
      } else {
        throw Exception('Failed to fetch data (${response.statusCode}).');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isALoading = false;
      });
    }
  }
}
