import 'package:database_chat_app/components/appBar.dart';
import 'package:database_chat_app/components/myStyle.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User? _user;
  Map<String, dynamic>? _userData;
  late String name;
  late String email;
  late String currentbal;
  late String totalInv;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    await _user!.reload(); // Refresh user data
    _loadUserDataFromFirestore(); // Load additional user data from Firestore
  }

  Future<void> _loadUserDataFromFirestore() async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

      if (snapshot.exists) {
        setState(() {
          _userData = snapshot.data();
        });
      } else {
        // If the user profile doesn't exist, create it with initial values.
        await docRef.set({
          'display_name': _user!.displayName ?? '',
          'totalInvestment': 0.0, // Initial investment
          'totalProfit': 0.0,
          'totalLoss': 0.0,
          'current_balance': 100000.0, // Initial balance set to $100,000
        });

        // Fetch the updated data after creating the user profile.
        await _loadUserDataFromFirestore();
      }
    } catch (e) {
      //  print('Error loading user data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 330,
                  child: _head(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Performance Overview',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Text(
                          'Pnl',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 25, left: 25, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Positioned(
                        top: 50,
                        left: 20,
                        child: _buildCircularChart(7, Colors.green),
                      ),
                      Positioned(
                        top: 50,
                        right: 20,
                        child: _buildCircularChart(30, Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
                  width: double.infinity,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                        color: Color(0xff368983),
                        pointColorMapper: (SalesData sales, _) {
                          // Return the color for each data point based on your logic
                        },
                        dataSource: <SalesData>[
                          SalesData(
                              '1w',
                              3,
                              Colors
                                  .red), // Set the color for each data point individually
                          SalesData('2w', 4, Colors.green),
                          SalesData('3w', 3.5, Colors.blue),
                          SalesData('4w', 7, Colors.orange),
                          SalesData('5w', 4.5, Colors.purple),
                          SalesData('6w', 6, Colors.yellow),
                          SalesData('7w', 10, Colors.cyan),
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                color: Color(0xff368983),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: const Color.fromRGBO(250, 250, 250, 0.1),
                        child: const Icon(
                          Icons.notification_add_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good afternoon',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        if (_userData != null)
                          Text(
                            _userData!['display_name']
                                    .substring(0, 1)
                                    .toUpperCase() +
                                _userData!['display_name'].substring(1),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

        Positioned(
          top: 140,
          left: 22,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: Color.fromARGB(255, 47, 125, 121),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        'Rs.${_userData!['current_balance']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Profit',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Loss',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs.${_userData!['totalProfit']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Rs.${_userData!['totalLoss']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // Positioned(
        //   // padding: EdgeInsets.only(top: 430),
        //   top: 350,
        //   left: 4,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Performance Overview',
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.black,
        //         ),
        //       ),

        //     ],
        //   ),
        // ),

        // Container(
        //   decoration: const BoxDecoration(
        //     color: Color.fromARGB(255, 3, 45, 59),
        //   ),
        //   padding: EdgeInsets.only(top: 430),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Performance Overview',
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white60,
        //         ),
        //       ),
        //       Container(
        //         padding: EdgeInsets.only(bottom: 50),
        //         height: 350,
        //         width: double.infinity,
        //         child: SfCartesianChart(
        //           primaryXAxis: CategoryAxis(),
        //           series: <LineSeries<SalesData, String>>[
        //             LineSeries<SalesData, String>(
        //               color: Colors.white,
        //               pointColorMapper: (SalesData sales, _) {
        //                 // Return the color for each data point based on your logic
        //               },
        //               dataSource: <SalesData>[
        //                 SalesData(
        //                     '1w',
        //                     3,
        //                     Colors
        //                         .red), // Set the color for each data point individually
        //                 SalesData('2w', 4, Colors.green),
        //                 SalesData('3w', 3.5, Colors.blue),
        //                 SalesData('4w', 7, Colors.orange),
        //                 SalesData('5w', 4.5, Colors.purple),
        //                 SalesData('6w', 6, Colors.yellow),
        //                 SalesData('7w', 10, Colors.cyan),
        //               ],
        //               xValueMapper: (SalesData sales, _) => sales.year,
        //               yValueMapper: (SalesData sales, _) => sales.sales,
        //             )
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // if (_userData != null)
        //   Profile(
        //     _userData!['display_name'],
        //     '${_user!.email}',
        //     'Rs.${_userData!['current_balance']}',
        //     'Rs.${_userData!['totalInvestment']}',
        //   ),
        // MyAppBar(),
        // //InformationTab(),
      ],
    );
  }

  Widget _buildCircularChart(int days, Color color) {
    final dummyData = [10.0, 20.0, 30.0]; // Replace with actual data

    return SizedBox(
      width: 100,
      height: 100,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 20,
          borderData: FlBorderData(show: false),
          sections: [
            for (var i = 0; i < dummyData.length; i++)
              PieChartSectionData(
                value: dummyData[i],
                color: i == 0 ? color : Colors.grey[300],
                radius: 20 + i * 10,
              ),
          ],
        ),
      ),
    );
  }
}

Widget Profile(String username, String email, String currentBalance,
    String totalInvestent) {
  return Container(
    //padding: EdgeInsets.symmetric(horizontal: 35.0),
    padding: EdgeInsets.only(top: 170),
    width: double.infinity,
    height: 400,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(80.0),
      ),
    ),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.person,
            size: 20.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          username,
          style: heading4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email,
              size: 16.0,
              color: Colors.grey,
            ),
            Text(
              email,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  currentBalance,
                  style: countText,
                ),
                Text(
                  'Current Balance',
                  style: followText,
                )
              ],
            ),
            SizedBox(
              width: 24.0,
            ),
            Column(
              children: [
                Text(
                  totalInvestent,
                  style: countText,
                ),
                Text(
                  'Total Investment',
                  style: followText,
                )
              ],
            ),
          ],
        )
      ],
    ),
  );
}
// Widget _buildUserMetric(String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,w
//             fontWeight: FontWeight.bold,
//             color: Colors.green, // You can customize color based on values
//           ),
//         ),
//       ],
//     ),
//   );
// }

class SalesData {
  SalesData(this.year, this.sales, this.color);

  final String year;
  final double sales;
  final Color color;
}


//  if (_userData != null)
//                         _buildUserMetric(
//                           'Current Balance',
//                           'Rs.${_userData!['current_balance']}',
//                         ),
//                       if (_userData != null)
//                         _buildUserMetric(
//                           'Total Investment',
//                           'Rs.${_userData!['totalInvestment']}',
//                         ),
//                       if (_userData != null)
//                         _buildUserMetric(
//                           'Total Profit',
//                           'Rs.${_userData!['totalProfit']}',
//                         ),
//                       if (_userData != null)
//                         _buildUserMetric(
//                           'Total Loss',
//                           'Rs.${_userData!['totalLoss']}',
//                         ),