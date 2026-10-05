# CareerConnect

## About
A clean, responsive, and student-focused Flutter mobile application designed to help university students and freshers discover, search, filter, and track entry-level jobs and internships. Built with an offline-first architecture using local mock data and persistent storage via `shared_preferences`.

---

## Features
- **Splash Screen**: Professional branded introduction ("Find jobs. Find opportunities.") with automatic transition.
- **Job & Internship Discovery**: Explore 12 realistic sample opportunities tailored for entry-level roles across top tech hubs.
- **Dynamic Search**: Instant keyword search matching job titles, company names, cities, and required technical skills.
- **Multi-criteria Filtering**:
  - Quick category chips: *All*, *Internships*, *Full Time*, *Remote*.
  - Modal bottom sheet filters: Job type, work mode (*Remote*, *Hybrid*, *On-site*), and location (*Pune*, *Mumbai*, *Bengaluru*, *Remote*).
  - Clear search & reset filters with one tap.
- **Detailed Opportunity View**: Detailed job descriptions, stipends/salaries, required skills, daily responsibilities, and eligibility requirements.
- **Saved Opportunities (Bookmarks)**: Save interesting listings to review later. Bookmarks persist locally across app restarts.
- **Application Tracking**: One-tap "Apply Now" action that records the submission date and provides visual feedback ("Applied" status badge).
- **Student Profile & Real-time Metrics**: Displays student details, technical skill badges, and live counters for total saved and applied positions.
- **Bottom Navigation Bar**: Intuitive 4-tab Material 3 navigation with real-time notification badges.

---

## Tech Stack
- **Framework**: [Flutter](https://flutter.dev/) (v3.47+ / Material 3)
- **Language**: [Dart](https://dart.dev/) (v3.13+)
- **Local Persistence**: `shared_preferences` (v2.5+)
- **Design System**: High-energy Neo-Brutalism aesthetic (crisp solid black borders, hard unblurred drop shadows, and vibrant retro-modern color blocking).

---

## Project Structure
```text
career_connect/
├── lib/
│   ├── data/
│   │   └── sample_jobs.dart         # Realistic sample opportunities data
│   ├── models/
│   │   └── job.dart                 # Job model with JSON serialization
│   ├── screens/
│   │   ├── applications_screen.dart # Track submitted applications
│   │   ├── home_screen.dart         # Job discovery, search & filter view
│   │   ├── job_details_screen.dart  # Detailed opportunity specifications & actions
│   │   ├── main_navigation_screen.dart # Material 3 bottom navigation shell
│   │   ├── profile_screen.dart      # Student portfolio & live statistics
│   │   ├── saved_jobs_screen.dart   # Bookmarked jobs list
│   │   └── splash_screen.dart       # Branded splash screen
│   ├── services/
│   │   └── storage_service.dart     # SharedPreferences persistence layer
│   ├── utils/
│   │   ├── app_colors.dart          # Palette tokens (Navy, Teal, Slate)
│   │   └── app_theme.dart           # Material 3 theme configuration
│   └── main.dart                    # Application entry point & MaterialApp bootstrap
├── test/
│   └── widget_test.dart             # Unit & widget integration tests
├── pubspec.yaml                     # Project dependencies & assets
├── README.md                        # Project documentation
├── FLUTTER_EXPLANATION.md           # Beginner concept guide (Flutter & Dart)
├── INTERVIEW_PREPARATION.md         # Interview scripts & 15 Q&A pairs
└── RESUME_CONTENT.md                # Ready-to-use resume bullet points
```

---

## How to Run

### Prerequisites
1. [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and added to your system PATH.
2. Google Chrome (for web) or an Android Emulator / physical device.

### Run on Chrome (Web)
```bash
# 1. Navigate to the project root
cd career_connect

# 2. Fetch dependencies
flutter pub get

# 3. Analyze code for quality
flutter analyze

# 4. Run automated tests
flutter test

# 5. Launch the application on Chrome
flutter run -d chrome
```

### Run on Android
```bash
# Ensure an Android emulator is running or a device is connected via USB debugging
flutter devices

# Run on the connected Android device
flutter run -d android
```

---

## Future Improvements
The following capabilities are planned for future versions:
- **Live Backend API**: Integration with a RESTful or GraphQL backend to fetch live company listings.
- **User Authentication**: Secure email/password login and OAuth integration (Google / GitHub).
- **Resume Upload & Parsing**: Local PDF upload and automated profile population.
- **Push Notifications**: Timely notifications for application status updates and new matching roles.
- **Dark Mode Support**: Dynamic system theme switching.
