# Play Store Upload Checklist

## ✅ Pre-Upload Tasks

### 1. App Configuration
- [x] Updated app name to "Weather Spinner"
- [x] Changed package ID to com.weatherspinner.app
- [x] Updated version to 1.0.0+1
- [x] Added proper app description

### 2. App Signing (REQUIRED)
- [ ] Created release keystore (.jks file)
- [ ] Created android/key.properties with signing config
- [ ] Added key.properties to .gitignore
- [ ] Tested release build successfully

**Command to create keystore:**
```bash
keytool -genkey -v -keystore weather-spinner-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias weather-spinner
```

### 3. App Assets (REQUIRED)
- [ ] App icon created (512x512 px)
- [ ] App icon placed in mipmap folders
- [ ] Feature graphic created (1024x500 px)
- [ ] At least 2 phone screenshots taken
- [ ] Screenshots edited/optimized

**Screenshot Suggestions:**
1. Main game screen showing the spin machine
2. Quiz section with answer options
3. Collection/Weather Guide screen
4. Discovery modal showing new element

### 4. Play Store Listing
- [ ] Short description written (80 chars max)
- [ ] Full description written (up to 4000 chars)
- [ ] App category selected: Games > Educational or Puzzle
- [ ] Content rating questionnaire completed
- [ ] Privacy policy created (if needed)
- [ ] Pricing set (Free recommended)
- [ ] Countries/regions selected

### 5. Build & Test
- [ ] Run: `flutter clean`
- [ ] Run: `flutter pub get`
- [ ] Test app in debug mode: `flutter run`
- [ ] Build release APK: `flutter build apk --release`
- [ ] Test release APK on real device
- [ ] Build App Bundle: `flutter build appbundle --release`

### 6. Optional Enhancements
- [ ] Add promotional video (30 sec - 2 min)
- [ ] Create additional tablet screenshots
- [ ] Add app translations for other languages
- [ ] Set up Google Play Console developer account ($25 one-time fee)

---

## 📱 Build Commands (Quick Reference)

**Clean Build:**
```bash
flutter clean
flutter pub get
```

**Build APK (for testing):**
```bash
flutter build apk --release
```

**Build App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**Install and Test:**
```bash
flutter install
```

**Or use the build script:**
```powershell
.\build_release.ps1
```

---

## 📦 File Locations After Build

**APK:**
`build\app\outputs\flutter-apk\app-release.apk`

**App Bundle (AAB):**
`build\app\outputs\bundle\release\app-release.aab`

---

## 🚀 Upload Steps

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app
3. Fill in app details and store listing
4. Upload app bundle (.aab file)
5. Complete content rating
6. Set pricing & distribution
7. Submit for review

---

## 📝 Important Notes

- **First upload requires:** App bundle, screenshots, icon, descriptions
- **Review time:** Usually 1-3 days
- **Store listing can be edited** anytime, even after publish
- **Keep your signing key safe!** If lost, you can never update your app
- **Version updates:** Increment version number for each update

---

## ✨ Post-Launch

- Monitor reviews and ratings
- Respond to user feedback
- Track crash reports in Play Console
- Plan updates and new features
- Consider adding:
  - Achievements
  - Leaderboards
  - More elements/levels
  - Themes or customization

---

Good luck with your launch! 🎉
