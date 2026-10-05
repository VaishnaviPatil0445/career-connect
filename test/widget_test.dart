import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:career_connect/main.dart';
import 'package:career_connect/data/sample_jobs.dart';
import 'package:career_connect/services/storage_service.dart';
import 'package:career_connect/screens/job_details_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetCache();
  });

  testWidgets('Splash screen renders branding and transitions to Home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CareerConnectApp());

    // Verify splash screen elements
    expect(find.text('CareerConnect'), findsOneWidget);
    expect(find.text('Find jobs. Find opportunities.'), findsOneWidget);

    // Fast-forward past the 2-second splash timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify Home screen loaded
    expect(find.text('Find your next opportunity'), findsOneWidget);
    expect(find.text('Search jobs or internships...'), findsOneWidget);
    expect(find.text('Opportunities (${sampleJobs.length})'), findsOneWidget);
  });

  testWidgets('Search filters jobs correctly and handles no results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CareerConnectApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Enter search text "Flutter"
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Flutter');
    await tester.pumpAndSettle();

    // Verify Flutter Developer Intern is found
    expect(find.text('Flutter Developer Intern'), findsOneWidget);

    // Enter search text that matches nothing
    await tester.enterText(searchField, 'NonExistentXYZRole');
    await tester.pumpAndSettle();

    expect(find.text('No opportunities found'), findsOneWidget);
    expect(find.text('Clear search & filters'), findsOneWidget);

    // Tap clear search
    await tester.tap(find.text('Clear search & filters'));
    await tester.pumpAndSettle();

    expect(find.text('Opportunities (${sampleJobs.length})'), findsOneWidget);
  });

  testWidgets('StorageService persists saved and applied jobs',
      (WidgetTester tester) async {
    const testJobId = 'job_001';

    // Verify initial states
    expect(await StorageService.isJobSaved(testJobId), false);
    expect(await StorageService.isJobApplied(testJobId), false);

    // Save job
    final isSaved = await StorageService.toggleSavedJob(testJobId);
    expect(isSaved, true);
    expect(await StorageService.isJobSaved(testJobId), true);

    final savedList = await StorageService.getSavedJobIds();
    expect(savedList.contains(testJobId), true);

    // Apply for job
    final appliedSuccess = await StorageService.applyJob(testJobId);
    expect(appliedSuccess, true);
    expect(await StorageService.isJobApplied(testJobId), true);

    final appliedJobs = await StorageService.getAppliedJobs();
    expect(appliedJobs.containsKey(testJobId), true);
    expect(appliedJobs[testJobId], isNotNull);
  });

  testWidgets('JobDetailsScreen displays details and handles Apply action',
      (WidgetTester tester) async {
    final sampleJob = sampleJobs.first;

    await tester.pumpWidget(
      MaterialApp(
        home: JobDetailsScreen(job: sampleJob),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Job Details'), findsOneWidget);
    expect(find.text(sampleJob.title), findsOneWidget);
    expect(find.text(sampleJob.company), findsOneWidget);
    expect(find.text('Apply Now'), findsOneWidget);

    // Tap Apply Now
    await tester.tap(find.text('Apply Now'));
    await tester.pumpAndSettle();

    // Verify confirmation and button text change
    expect(find.text('Application saved successfully.'), findsOneWidget);
    expect(find.text('Applied'), findsWidgets);
  });
}
