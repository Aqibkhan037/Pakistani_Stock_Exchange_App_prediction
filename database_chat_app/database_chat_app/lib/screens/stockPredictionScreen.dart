import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockPredictionScreen extends StatefulWidget {
  final Map<String, dynamic> indexData;

  StockPredictionScreen(this.indexData);

  @override
  _StockPredictionScreenState createState() => _StockPredictionScreenState();
}

class _StockPredictionScreenState extends State<StockPredictionScreen> {
  String predictedValue = '';

  @override
  void initState() {
    super.initState();
    // Call method to fetch predicted value when the screen is initialized
    fetchPredictedValue();
  }

  Future<void> fetchPredictedValue() async {
    try {
      // Make HTTP GET request to the server
      var response =
          await http.get(Uri.parse('http://192.168.43.79:5000/predict'));

      // Parse the JSON response
      var responseData = json.decode(response.body);

      // Update the predicted value
      setState(() {
        predictedValue = responseData['prediction'].toString();
      });
    } catch (e) {
      print('Error fetching predicted value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Prediction',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff368983),
        elevation: 0, // Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${widget.indexData['date']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            ...List<Widget>.generate(
              widget.indexData['stats'].length,
              (index) => ListTile(
                title: Text(
                  widget.indexData['stats'][index]['label'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  widget.indexData['stats'][index]['value'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Predicted Value:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  predictedValue,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
