# Weather Spinner - Build Instructions
# Run these commands to prepare your app for Play Store upload

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Weather Spinner - Build Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
flutter --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Flutter not found! Please install Flutter first." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Choose build option:" -ForegroundColor Green
Write-Host "1. Build APK (for testing)" -ForegroundColor White
Write-Host "2. Build App Bundle (for Play Store - RECOMMENDED)" -ForegroundColor White
Write-Host "3. Clean and rebuild" -ForegroundColor White
Write-Host "4. Just run in debug mode" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "`nBuilding APK..." -ForegroundColor Yellow
        flutter build apk --release
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nSUCCESS! APK built successfully!" -ForegroundColor Green
            Write-Host "Location: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Cyan
        }
    }
    "2" {
        Write-Host "`nBuilding App Bundle for Play Store..." -ForegroundColor Yellow
        
        # Check if signing is configured
        if (!(Test-Path "android\key.properties")) {
            Write-Host "`nWARNING: No key.properties file found!" -ForegroundColor Red
            Write-Host "You need to configure app signing first." -ForegroundColor Yellow
            Write-Host "See PLAY_STORE_README.md for instructions." -ForegroundColor Yellow
            Write-Host "`nDo you want to build anyway with debug signing? (y/n)" -ForegroundColor Yellow
            $continue = Read-Host
            if ($continue -ne "y") {
                exit 0
            }
        }
        
        flutter build appbundle --release
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nSUCCESS! App Bundle built successfully!" -ForegroundColor Green
            Write-Host "Location: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor Cyan
            Write-Host "`nYou can now upload this to Google Play Console!" -ForegroundColor Green
        }
    }
    "3" {
        Write-Host "`nCleaning project..." -ForegroundColor Yellow
        flutter clean
        Write-Host "Getting dependencies..." -ForegroundColor Yellow
        flutter pub get
        Write-Host "`nRebuilding..." -ForegroundColor Yellow
        flutter build appbundle --release
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nSUCCESS! Clean build completed!" -ForegroundColor Green
        }
    }
    "4" {
        Write-Host "`nRunning in debug mode..." -ForegroundColor Yellow
        flutter run
    }
    default {
        Write-Host "Invalid choice!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "Build process completed!" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
