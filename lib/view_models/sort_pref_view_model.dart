import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sortPrefViewModelProvider =
    StateNotifierProvider<SortPreferenceViewModel, String>(
  (ref) => SortPreferenceViewModel(),
);

class SortPreferenceViewModel extends StateNotifier<String> {
  SortPreferenceViewModel() : super(_loadSortPreference());

  static String _loadSortPreference() {
    final box = Hive.box("settings");
    return box.get("sortBy", defaultValue: "date");
  }

  void updateSortPreference(String sortBy) {
    state = sortBy;
    Hive.box("settings").put("sortBy", state);
  }
}
