// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockDetailScreen extends StatelessWidget {
  final Map<String, String> stockDetails;

  const StockDetailScreen({Key? key, required this.stockDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Detail - ${stockDetails['symbol'] ?? 'N/A'}'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section

            const SizedBox(height: 8),
            Text(
              'Current Rate: ${stockDetails['currentRate'] ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Change: ${stockDetails['change'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 16,
                color: _getColorForChangePercentage(
                  stockDetails['changePercentage'] ?? '0',
                ),
              ),
            ),
            Text(
              'Change Percentage: ${stockDetails['changePercentage'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 16,
                color: _getColorForChangePercentage(
                  stockDetails['changePercentage'] ?? '0',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Graph Section
            SizedBox(
              height: 200,
            ),

            const SizedBox(height: 16),

            // Additional Stock Details

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showBuyStockDialog(
                    context, stockDetails); // Change the quantity as needed
              },
              child: const Text('Buy Stock'),
            ),
            ElevatedButton(
              onPressed: () {
                _AddToWatchlist(context, stockDetails);
              },
              child: const Text('Add to Watchlist'),
            ),
            // Action Buttons
          ],
        ),
      ),
    );
  }

  // Function to show the Buy Stock dialog
  Future<void> _showBuyStockDialog(
      BuildContext context, Map<String, String> stockDetails) async {
    int? quantity;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buy Stock'),
          content: Column(
            children: [
              const Text('Enter quantity:'),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = int.tryParse(value);
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (quantity != null && quantity! > 0) {
                  _buyStockAndReloadProfile(context, quantity!, stockDetails);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Buy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to buy stock and reload the user profile

  void _buyStockAndReloadProfile(BuildContext context, int quantity,
      Map<String, String> stockDetails) async {
    try {
      // Assuming you have a reference to your Firebase instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      // Get the current user
      User? user = auth.currentUser;

      // Validate if the user is signed in
      if (user == null) {
        // Handle the case when the user is not signed in
        // print('User not signed in');
        return;
      }

      // Get the user's document reference in the "User_data" collection
      DocumentReference userDocRef =
          firestore.collection('users').doc(user.uid);

      // Get the stock details
      String stockSymbol = stockDetails['symbol'] ?? '';
      double currentRate = double.parse(stockDetails['currentRate'] ?? '0');
      String change = stockDetails['change'] ?? '';
      String changePercentage = stockDetails['changePercentage'] ?? '';

      // Calculate the total cost based on the current rate and quantity
      double totalCost = currentRate * quantity;

      // Add the stock to "Purchased_stocks" collection
      DocumentReference purchasedStockRef =
          userDocRef.collection('purchasedStocks').doc(stockSymbol);

      await purchasedStockRef.set({
        'symbol': stockSymbol,
        'quantity': quantity,
        'totalCost': totalCost,
        'currentRate': currentRate,
        'change': change,
        'changePercentage': changePercentage,
        // Add other stock details as needed
      });

      // Update the "User_data" collection
      await userDocRef.update({
        'totalInvestment': FieldValue.increment(totalCost),
        'current_balance': FieldValue.increment(-totalCost),

        // Update other fields as needed
      });

      // Show a success message or navigate to another screen if needed
      //  print('Stock purchased successfully');

      // Reload the user profile data
      await _getUserData();

      // Show a success message or navigate to another screen if needed
      // print('User data reloaded successfully');

      // Reload the current screen or navigate back
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // Handle errors
      //  print('Error buying stock: $e');
      //  print('Stack trace: $stackTrace');
      // Show an error message or take appropriate action
    }
  }

  // ignore: non_constant_identifier_names
  void _AddToWatchlist(
      BuildContext context, Map<String, String> stockDetails) async {
    try {
      // Assuming you have a reference to your Firebase instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      // Get the current user
      User? user = auth.currentUser;

      // Validate if the user is signed in
      if (user == null) {
        // Handle the case when the user is not signed in
        //   print('User not signed in');
        return;
      }

      // Get the user's document reference in the "users" collection
      DocumentReference userDocRef =
          firestore.collection('users').doc(user.uid);

      // Get the stock details
      String stockSymbol = stockDetails['symbol'] ?? '';
      double currentRate = double.parse(stockDetails['currentRate'] ?? '0');
      String change = stockDetails['change'] ?? '';
      String changePercentage = stockDetails['changePercentage'] ?? '';

      // Add the stock to the "watchlist" subcollection
      DocumentReference watchlistRef =
          userDocRef.collection('watchlist').doc(stockSymbol);

      await watchlistRef.set({
        'symbol': stockSymbol,
        'currentRate': currentRate,
        'change': change,
        'changePercentage': changePercentage,
        // Add other stock details as needed
      });

      // Show a success message or navigate to another screen if needed
      //  print('Stock added to watchlist successfully');

      // Show a success message or navigate to another screen if needed
      // print('User data reloaded successfully');

      // Reload the current screen or navigate back
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // Handle errors
      //  print('Error adding stock to watchlist: $e');
      // print('Stack trace: $stackTrace');
      // Show an error message or take appropriate action
    }
  }

  Future<void> _getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      // Now you can use userSnapshot.data() to access user data
      // Update your UI with the fetched data
    }
  }

  Color _getColorForChangePercentage(String changePercentage) {
    try {
      if (changePercentage.isEmpty) {
        return Colors.black;
      }

      final double percentage =
          double.parse(changePercentage.replaceAll('%', ''));

      return percentage >= 0 ? Colors.green : Colors.red;
    } catch (e) {
//      print('Error parsing change percentage: $e');
      //     print('Stack trace: $stackTrace');
      return Colors.black;
    }
  }
}
