# Firebase Setup Guide for SBA7O

## Prerequisites
- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Step 1: Complete Firebase Configuration

You need to complete the Firebase configuration that was started. Run:

```bash
flutterfire configure
```

When prompted:
1. Select your Firebase project or create a new one
2. Choose the platforms you want to support (Android, iOS, Web)
3. This will generate the `firebase_options.dart` file with your actual Firebase credentials

## Step 2: Download Configuration Files

After running `flutterfire configure`, you'll need to download the configuration files:

### For Android:
- Download `google-services.json` from Firebase Console
- Place it in `android/app/google-services.json`

### For iOS:
- Download `GoogleService-Info.plist` from Firebase Console
- Place it in `ios/Runner/GoogleService-Info.plist`

### For Web:
- The configuration will be automatically added to `web/index.html`

## Step 3: Enable Firebase Services

In the Firebase Console:

### Authentication
1. Go to Authentication > Sign-in method
2. Enable Email/Password authentication
3. Optionally enable other providers (Google, Facebook, etc.)

### Firestore Database
1. Go to Firestore Database
2. Create a database in test mode (for development)
3. Set up security rules

### Storage
1. Go to Storage
2. Create a storage bucket
3. Set up security rules

## Step 4: Security Rules

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read/write rooms
    match /rooms/{roomId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 5: Test the Setup

1. Run the app:
```bash
flutter run
```

2. Test authentication:
   - Try registering a new user
   - Try logging in with the registered user
   - Check if the user appears in Firebase Console

3. Test Firestore:
   - Create a room and check if it appears in Firestore
   - Join/leave rooms and verify the data updates

## Step 6: Environment Variables (Optional)

For production, consider using environment variables for sensitive data:

1. Create `.env` file:
```
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

2. Add to `.gitignore`:
```
.env
google-services.json
GoogleService-Info.plist
```

## Troubleshooting

### Common Issues:

1. **"Target of URI doesn't exist: 'firebase_options.dart'"**
   - Run `flutterfire configure` to generate the file

2. **"Google Services plugin not found"**
   - Make sure `google-services.json` is in `android/app/`
   - Clean and rebuild: `flutter clean && flutter pub get`

3. **Authentication errors**
   - Check if Email/Password auth is enabled in Firebase Console
   - Verify the Firebase configuration is correct

4. **Firestore permission errors**
   - Check Firestore security rules
   - Ensure the database is created and accessible

## Next Steps

1. **Add more Firebase features:**
   - Push notifications
   - Analytics
   - Crashlytics
   - Remote Config

2. **Implement advanced features:**
   - Real-time chat
   - File uploads
   - User profiles
   - Room management

3. **Production deployment:**
   - Set up proper security rules
   - Configure production Firebase project
   - Add CI/CD pipeline

## Support

If you encounter issues:
1. Check Firebase Console for error logs
2. Verify all configuration files are in place
3. Ensure all dependencies are properly installed
4. Check Flutter and Firebase documentation 