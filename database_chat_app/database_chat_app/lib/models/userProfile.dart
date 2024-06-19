// ignore_for_file: file_names

class UserProfile {
  double totalInvestment;
  double totalProfit;
  double totalLoss;
  double currentBalance;

  UserProfile({
    required this.totalInvestment,
    required this.totalProfit,
    required this.totalLoss,
    required this.currentBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalInvestment': totalInvestment,
      'totalProfit': totalProfit,
      'totalLoss': totalLoss,
      'currentBalance': currentBalance,
    };
  }

  UserProfile.fromMap(Map<String, dynamic> map)
      : totalInvestment = map['totalInvestment'],
        totalProfit = map['totalProfit'],
        totalLoss = map['totalLoss'],
        currentBalance = map['currentBalance'];
}
