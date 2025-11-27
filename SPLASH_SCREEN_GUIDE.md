# Splash Screen Setup Guide

## 🎨 Your Splash Screen is Configured!

I've set up splash screen support for your Weather Spinner app. Now you just need to add your splash image!

---

## 📋 What You Need to Do

### Step 1: Create Your Splash Image

**Image Requirements:**
- **Format**: PNG with transparency
- **Size**: 1152 x 1152 px (recommended)
- **Background**: Transparent (the blue color is set in config)
- **Content**: Your app logo/icon centered

**Design Tips:**
- Keep it simple - just your app logo/name
- Use weather-themed graphics (clouds, sun, rain)
- Make sure it looks good on both light backgrounds
- Leave padding around edges (safe area)

**Free Design Tools:**
- [Canva](https://canva.com) - Easy online design
- [GIMP](https://gimp.org) - Free desktop software
- [Figma](https://figma.com) - Professional design tool

### Step 2: Add Your Image

1. Create your splash image (1152x1152 px PNG)
2. Save it as: `splash_logo.png`
3. Place it in: `assets/splash/splash_logo.png`

**Current Location:**
```
d:\game-dev\color_catcher_game\color_catcher_game\assets\splash\splash_logo.png
```

### Step 3: Generate Splash Screens

After adding your image, run these commands:

```bash
# Install dependencies
flutter pub get

# Generate splash screens for all platforms
flutter pub run flutter_native_splash:create
```

This will automatically create all the required splash screen files for Android and iOS!

### Step 4: Test Your Splash Screen

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Run on device
flutter run
```

You should see your splash screen appear when the app launches!

---

## 🎨 Current Configuration

**Background Color**: Light Blue (#E3F2FD) - Weather themed!
**Image Location**: `assets/splash/splash_logo.png`
**Platforms**: Android ✅ | iOS ✅

---

## 💡 Customization Options

You can change the splash screen settings in `pubspec.yaml`:

### Change Background Color
```yaml
flutter_native_splash:
  color: "#FFFFFF"  # White
  # or
  color: "#5C6BC0"  # Purple (your app primary color)
```

### Use Full-Screen Image
```yaml
flutter_native_splash:
  color: "#E3F2FD"
  image: assets/splash/splash_logo.png
  fullscreen: true  # Makes image fill entire screen
```

### Add Branding Text
```yaml
flutter_native_splash:
  color: "#E3F2FD"
  image: assets/splash/splash_logo.png
  branding: assets/splash/branding.png  # Bottom branding
```

---

## 🖼️ Sample Splash Image Ideas

**Option 1: Simple Logo**
- Weather Spinner text
- Cloud icon above
- Centered on transparent background

**Option 2: Icon Only**
- Large weather icon (☁️🌦️)
- App name below in nice font
- Transparent background

**Option 3: Branded**
- App logo
- Tagline: "Discover Weather Magic"
- Weather elements around

---

## 📱 Android 12+ Support

The configuration includes Android 12+ splash screen support with the new system splash format. Your splash will work perfectly on all Android versions!

---

## ✅ Quick Checklist

- [ ] Create splash image (1152x1152 PNG)
- [ ] Save to `assets/splash/splash_logo.png`
- [ ] Run `flutter pub get`
- [ ] Run `flutter pub run flutter_native_splash:create`
- [ ] Test with `flutter run`

---

## 🎯 Example Command Sequence

```bash
# After adding your PNG image to assets/splash/

flutter clean
flutter pub get
flutter pub run flutter_native_splash:create
flutter run
```

---

## 🆘 Need Help?

**Image too small/large?** 
The package will resize automatically, but 1152x1152 works best.

**Splash not showing?**
1. Make sure the image path is correct
2. Run `flutter clean`
3. Rebuild the app completely

**Want to change colors?**
Edit the `color:` value in `pubspec.yaml` under `flutter_native_splash:`

---

Your splash screen is ready to go once you add your PNG image! 🚀
