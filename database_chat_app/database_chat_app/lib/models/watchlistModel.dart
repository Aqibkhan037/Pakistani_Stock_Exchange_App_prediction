// watchlist_model.dart

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:database_chat_app/models/watchlistItem.dart';

class WatchlistModel extends ChangeNotifier {
  final List<Stock> _watchlist = [];

  List<Stock> get watchlist => _watchlist;

  void addToWatchlist(Stock item) {
    _watchlist.add(item);
    notifyListeners();
  }

  // Add other methods like removeFromWatchlist if needed
}
