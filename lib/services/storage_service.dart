import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// StorageService manages persistent local storage using SharedPreferences.
///
/// It persists:
/// 1. Saved Job IDs (bookmarks)
/// 2. Applied Job IDs along with their application dates
///
/// This ensures user data remains intact even after closing/restarting the app.
class StorageService {
  static const String _keySavedJobs = 'career_connect_saved_jobs';
  static const String _keyAppliedJobs = 'career_connect_applied_jobs';

  // In-memory caches to speed up reads and avoid repeated disk parsing
  static List<String>? _cachedSavedIds;
  static Map<String, String>? _cachedAppliedJobs;

  /// Retrieves the list of saved job IDs from SharedPreferences.
  static Future<List<String>> getSavedJobIds() async {
    if (_cachedSavedIds != null) {
      return List<String>.from(_cachedSavedIds!);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_keySavedJobs) ?? [];
      _cachedSavedIds = List<String>.from(list);
      return List<String>.from(_cachedSavedIds!);
    } catch (e) {
      // In case of any storage error, return empty list gracefully
      return _cachedSavedIds ?? [];
    }
  }

  /// Checks if a specific job ID is currently saved.
  static Future<bool> isJobSaved(String jobId) async {
    final savedIds = await getSavedJobIds();
    return savedIds.contains(jobId);
  }

  /// Toggles saved state for a job.
  /// Returns `true` if the job is now saved, or `false` if it was removed.
  static Future<bool> toggleSavedJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = await getSavedJobIds();

      bool isNowSaved;
      if (savedIds.contains(jobId)) {
        savedIds.remove(jobId);
        isNowSaved = false;
      } else {
        savedIds.add(jobId);
        isNowSaved = true;
      }

      await prefs.setStringList(_keySavedJobs, savedIds);
      _cachedSavedIds = List<String>.from(savedIds);
      return isNowSaved;
    } catch (e) {
      return false;
    }
  }

  /// Explicitly removes a job from saved list.
  static Future<void> removeSavedJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = await getSavedJobIds();
      if (savedIds.contains(jobId)) {
        savedIds.remove(jobId);
        await prefs.setStringList(_keySavedJobs, savedIds);
        _cachedSavedIds = List<String>.from(savedIds);
      }
    } catch (_) {}
  }

  /// Retrieves a map of applied jobs where:
  /// Key = Job ID
  /// Value = Formatted date string when application was submitted
  static Future<Map<String, String>> getAppliedJobs() async {
    if (_cachedAppliedJobs != null) {
      return Map<String, String>.from(_cachedAppliedJobs!);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyAppliedJobs);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        _cachedAppliedJobs = decoded.map((k, v) => MapEntry(k, v.toString()));
      } else {
        _cachedAppliedJobs = {};
      }
      return Map<String, String>.from(_cachedAppliedJobs!);
    } catch (e) {
      return _cachedAppliedJobs ?? {};
    }
  }

  /// Checks if the student has already applied for this job.
  static Future<bool> isJobApplied(String jobId) async {
    final appliedJobs = await getAppliedJobs();
    return appliedJobs.containsKey(jobId);
  }

  /// Records an application for the job with the current date.
  /// Returns `true` if successful.
  static Future<bool> applyJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appliedJobs = await getAppliedJobs();

      // Format date e.g. "05 Oct 2026"
      final now = DateTime.now();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final day = now.day.toString().padLeft(2, '0');
      final month = months[now.month - 1];
      final year = now.year.toString();
      final formattedDate = '$day $month $year';

      appliedJobs[jobId] = formattedDate;

      await prefs.setString(_keyAppliedJobs, jsonEncode(appliedJobs));
      _cachedAppliedJobs = Map<String, String>.from(appliedJobs);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets the date when the student applied for the given job.
  static Future<String?> getAppliedDate(String jobId) async {
    final appliedJobs = await getAppliedJobs();
    return appliedJobs[jobId];
  }

  /// Clears in-memory cache (useful for testing or full resets).
  static void resetCache() {
    _cachedSavedIds = null;
    _cachedAppliedJobs = null;
  }
}
