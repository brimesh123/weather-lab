# Fix: Debug Mode Signing Error ⚠️

## The Problem
You uploaded an APK/AAB signed in **debug mode**. Play Store requires **release mode** signing with your own keystore.

## Solution: Create Release Keystore & Sign Properly

### Step 1: Create Your Release Keystore

Open PowerShell/Terminal and run:

```bash
keytool -genkey -v -keystore weather-spinner-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias weather-spinner
```

**You'll be asked:**
- Enter keystore password: (choose a strong password)
- Re-enter password: (same password)
- What is your first and last name? (Your name or company name)
- What is the name of your organizational unit? (e.g., "Development" or just press Enter)
- What is the name of your organization? (Your company or just press Enter)
- What is the name of your City or Locality? (Your city)
- What is the name of your State or Province? (Your state)
- What is the two-letter country code? (e.g., "US", "IN", etc.)
- Is this correct? (Type "yes")

**IMPORTANT:** 
- Save this .jks file in a SAFE location (e.g., `C:\Users\YourName\keys\`)
- **NEVER lose this file or password!** You can't update your app without it!
- **Backup this file** to multiple secure locations

### Step 2: Create key.properties File

1. Go to: `android/key.properties.template`
2. Copy it and rename to: `android/key.properties`
3. Edit `android/key.properties` with your actual values:

```properties
storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
keyAlias=weather-spinner
storeFile=C:/Users/YourName/keys/weather-spinner-release-key.jks
```

**Example:**
```properties
storePassword=MySecurePass123!
keyPassword=MySecurePass123!
keyAlias=weather-spinner
storeFile=C:/Users/brime/keys/weather-spinner-release-key.jks
```

**Note:** Use forward slashes `/` even on Windows!

### Step 3: Verify key.properties is Ignored by Git

Check that `android/key.properties` is in your `.gitignore` file. It should already be there, but verify:

```
# .gitignore should contain:
*.jks
*.keystore
key.properties
/android/key.properties
```

### Step 4: Clean and Build Release Bundle

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build RELEASE app bundle (properly signed)
flutter build appbundle --release
```

### Step 5: Verify the Build

After building, check:
- File location: `build/app/outputs/bundle/release/app-release.aab`
- File size: Should be around 20-40 MB

### Step 6: Upload to Play Store

1. Go to Google Play Console
2. Delete the previous debug upload (if still there)
3. Upload the NEW `app-release.aab` file
4. This time it should work! ✅

---

## Quick Command Reference

```bash
# 1. Create keystore (one time only)
keytool -genkey -v -keystore weather-spinner-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias weather-spinner

# 2. Configure android/key.properties (see above)

# 3. Build release
flutter clean
flutter pub get
flutter build appbundle --release

# 4. Find your file
# Location: build/app/outputs/bundle/release/app-release.aab
```

---

## Troubleshooting

**Error: "keystore not found"**
- Check the `storeFile` path in `key.properties`
- Use absolute path with forward slashes

**Error: "incorrect password"**
- Double-check your password in `key.properties`
- Make sure there are no extra spaces

**Still signing with debug?**
- Make sure `key.properties` exists in `android/` folder (not `android/app/`)
- Run `flutter clean` before building

---

## ⚠️ CRITICAL REMINDERS

1. **BACKUP YOUR KEYSTORE**: Copy `weather-spinner-release-key.jks` to:
   - External hard drive
   - Cloud storage (encrypted)
   - USB drive
   
2. **SAVE YOUR PASSWORDS**: Write them down in a password manager

3. **NEVER COMMIT**: Never add `.jks` or `key.properties` to Git

**If you lose your keystore, you can NEVER update your app on Play Store!**

---

Your app is ready once you complete these steps! 🚀
