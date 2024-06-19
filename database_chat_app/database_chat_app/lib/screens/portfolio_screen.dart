import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portfolio',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff368983),
        elevation: 0, // Remove shadow
      ),
      body: const PortfolioList(),
    );
  }
}

class PortfolioList extends StatelessWidget {
  const PortfolioList({super.key});

  @override
  Widget build(BuildContext context) {
    // Use FirebaseAuth.instance.currentUser to get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('purchasedStocks')
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
            child: Text('No purchased stocks available.'),
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

  Future<void> _setDesiredPrice(BuildContext context) async {
    TextEditingController priceController = TextEditingController();

    // Show a dialog to input the desired price
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Desired Price'),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter Desired Price'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double desiredPrice =
                    double.tryParse(priceController.text) ?? 0.0;
                _startListeningForPrice(context, desiredPrice);
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startListeningForPrice(
      BuildContext context, double desiredPrice) async {
    // Set up a stream to listen for changes in currentRate
    Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection('purchasedStocks')
        .doc(stock['symbol'])
        .snapshots();

    stream.listen((DocumentSnapshot snapshot) {
      double currentRate = snapshot['currentRate'] ?? 0.0;

      if (currentRate >= desiredPrice) {
        // Notify the user when the currentRate is greater or equal to the desired price
        _showNotification(context);
      }
    });
  }

  void _showNotification(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'The stock ${stock['symbol']} reached or exceeded the desired price!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Convert 'change' and 'changePercentage' to numeric values
    double change = double.tryParse(stock['change'] ?? '0') ?? 0;
    String changePercentage = stock['changePercentage'] ?? '0';

    bool isChangePositive = change >= 0;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: GestureDetector(
        onLongPress: () {
          // Add functionality to set desired price
          _setDesiredPrice(context);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              stock['symbol']?[0] ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            '${stock['symbol']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Rate: ${stock['currentRate']}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Change: ${stock['change']}',
                style: TextStyle(
                  fontSize: 16,
                  color: _getColorForChangePercentage(changePercentage),
                ),
              ),
              Text(
                'Change Percentage: ${stock['changePercentage']}',
                style: TextStyle(
                  fontSize: 16,
                  color: _getColorForChangePercentage(changePercentage),
                ),
              ),
              Text('Quantity: ${stock['quantity']}'),
              Text('Total Cost: ${stock['totalCost']}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.monetization_on),
            color: isChangePositive ? Colors.green : Colors.red,
            onPressed: () {
              // Add functionality to sell the stock
              _sellStock(context, stock);
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _sellStock(
    BuildContext context, Map<String, dynamic> stock) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's document reference in the "users" collection
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Calculate the total value of the sold stock
      double currentRate = stock['currentRate'] ?? 0.0;
      int quantity = stock['quantity'] ?? 0;
      double totalValue = currentRate * quantity;

      // Update the user's data
      await userDocRef.update({
        'totalProfit': FieldValue.increment(totalValue - stock['totalCost']),
        'totalLoss': FieldValue.increment(stock['totalCost'] - totalValue),
        'current_balance': FieldValue.increment(totalValue),
        'totalInvestment': FieldValue.increment(-stock['totalCost']),
      });

      // Delete the stock from the "purchasedStocks" collection
      await userDocRef
          .collection('purchasedStocks')
          .doc(stock['symbol'])
          .delete();

      // Show a success message or update UI if needed
      // print('Stock sold successfully');
    }
  } catch (e) {
    // Handle errors
    // print('Error selling stock: $e');
    // print('Stack trace: $stackTrace');
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
    // print('Error fetching purchased stocks: $e');
    // print('Stack trace: $stackTrace');
    rethrow; // Rethrow the error to propagate it to the UI
  }
}

Future<Map<String, dynamic>?> fetchPurchasedStockById(String documentId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('purchasedStocks')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      // print('Document $documentId does not exist');
      return null;
    }
  } catch (e) {
    // print('Error fetching purchased stock: $e');
    return null;
  }
}
