# QR/Barcode Scanner App

This app features a scanner that can read both QR codes and barcodes. Upon scanning, it navigates to a page displaying the scanned data, including whether it’s a QR code or barcode, along with the date and time of the scan. The app also vibrates upon a successful scan and provides an option to use the torch while scanning. All scanned data is stored in Firebase. Additionally, the app includes a history feature that allows users to view and delete previously scanned QR codes and barcodes.

## How To Use:

**Step1:**
Download or clone this repo by using the link below:

```
https://github.com/zubairehman/flutter-boilerplate-project.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

**Step 3:**

If FlutterCLI not configured , please follow the below link and install fluttercli in your system.
Follow the link to configure Firebase in your app.
https://firebase.google.com/docs/flutter/setup?platform=android

Enable _Firestore Database_ in Firebase Console.

Make sure these files are created after configuring FlutterCLI and Firebase Configuration

```
qrapp/
|-android
    |-app
        |-google-services.json
|-lib
    |-firebase_options.dart
```

**Step 4:**

Select any emulator or actual phone to run app:

```
 flutter run
```

## Libraries Used:

- [FirebaseCore](https://pub.dev/packages/firebase_core)
- [CloudFirestore](https://pub.dev/packages/cloud_firestore)
- [Vibration](https://pub.dev/packages/vibration) (to vibrate phone when scanned)
- [Barcode_Widget](https://pub.dev/packages/barcode_widget) (to create & display barcode image)
- [INTL](https://pub.dev/packages/barcode_widget) (to format date and time)
- [QR_Flutter](https://pub.dev/packages/qr_flutter) (to create & display qr image)
- [Mobile_Scanner](https://pub.dev/packages/mobile_scanner) (to scan barcode/qrcode)


## Video Implementation : 
https://drive.google.com/file/d/1LfjTyi603epu3uJCCSUxFDPvfltfoPAT/view?usp=sharing
