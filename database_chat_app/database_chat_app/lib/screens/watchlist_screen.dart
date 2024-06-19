import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watchlist',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff368983),
      ),
      body: const watchList(),
    );
  }
}

// ignore: camel_case_types
class watchList extends StatelessWidget {
  const watchList({super.key});

  @override
  Widget build(BuildContext context) {
    // Use FirebaseAuth.instance.currentUser to get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('watchlist')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No stocks available.'),
          );
        } else {
          // Display the list of purchased stocks
          return StockListView(data: snapshot.data!.docs);
        }
      },
    );
  }
}

class StockListView extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  const StockListView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stockData =
        data.map((doc) => doc.data()).toList();

    return ListView.builder(
      itemCount: stockData.length,
      itemBuilder: (context, index) {
        final stock = stockData[index];

        return StockCard(stock: stock);
      },
    );
  }
}

class StockCard extends StatelessWidget {
  final Map<String, dynamic> stock;

  const StockCard({super.key, required this.stock});

  Color _getColorForChangePercentage(String changePercentage) {
    try {
      if (changePercentage.isEmpty) {
        return Colors.black;
      }

      final double percentage =
          double.parse(changePercentage.replaceAll('%', ''));

      return percentage >= 0 ? Colors.green : Colors.red;
    } catch (e) {
      //  print('Error parsing change percentage: $e');
      //  print('Stack trace: $stackTrace');
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convert 'change' and 'changePercentage' to numeric values
    double change = double.tryParse(stock['change'] ?? '0') ?? 0;
    String changePercentage = stock['changePercentage'] ?? '0';

    bool isChangePositive = change >= 0;

    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          // Show a confirmation dialog if needed
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Remove ${stock['symbol']} from watchlist?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Remove'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) async {
          // Delete the stock from the watchlist
          await deleteStockFromWatchlist(context, stock['symbol']);
        },
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: Text(
                    stock['symbol']?[0] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${stock['symbol']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${stock['currentRate']}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      isChangePositive
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: _getColorForChangePercentage(changePercentage),
                      size: 24,
                    ),
                    Text(
                      '${stock['change']} (${stock['changePercentage']})',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getColorForChangePercentage(changePercentage),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> deleteStockFromWatchlist(
    BuildContext context, String symbol) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's document reference in the "users" collection
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Delete the stock from the "watchlist" subcollection
      await userDocRef.collection('watchlist').doc(symbol).delete();

      // Show a success message or update UI if needed
      // print('Stock removed from watchlist successfully');
    }
  } catch (e) {
    // Handle errors
    //  print('Error removing stock from watchlist: $e');
    //  print('Stack trace: $stackTrace');
    // Show an error message or take appropriate action
  }
}

Future<List<Map<String, dynamic>>> fetchPurchasedStocks(
    List<String> documentIds) async {
  try {
    List<Map<String, dynamic>?> results = await Future.wait(
      documentIds.map((documentId) => fetchPurchasedStockById(documentId)),
    );

    // Remove null values (documents not found)
    List<Map<String, dynamic>> stocks = results
        .where((result) => result != null)
        .map((result) => result!)
        .toList();

    return stocks;
  } catch (e) {
    //   print('Error fetching purchased stocks: $e');
    //   print('Stack trace: $stackTrace');
    rethrow; // Rethrow the error to propagate it to the UI
  }
}

Future<Map<String, dynamic>?> fetchPurchasedStockById(String documentId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      //  print('Document $documentId does not exist');
      return null;
    }
  } catch (e) {
    //  print('Error fetching purchased stock: $e');
    return null;
  }
}
