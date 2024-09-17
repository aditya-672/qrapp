import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrapp/screens/currentscanned.dart';
import 'package:qrapp/screens/scanhistory.dart';
import 'package:qrapp/widgets/corner.dart';
import 'package:vibration/vibration.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  var selectedIndex = 0;
  final _firebase = FirebaseFirestore.instance;
  final MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool toggleFlash = false;
  DateTime? time;
  String format = '';
  String data = '';
  late AnimationController _anicontroller;
  late Animation<double> _animation;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    controller.start(); // Start the controller in initState
    _isScanning = true;
    _anicontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _anicontroller,
      curve: Curves.easeInOut,
    ).drive(Tween<double>(begin: 60, end: 340));
  }

  @override
  void dispose() {
    controller.dispose(); // Properly dispose of the controller
    _anicontroller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  void scanQR(BarcodeCapture capture) {
    if (!_isScanning) return; // Prevent multiple scans
    setState(() {
      _isScanning = false; // Set flag to false to indicate scanning has stopped
    });
    controller.stop();
    final List<Barcode> barcodes = capture.barcodes;
    var barcode = barcodes.first;

    if (barcode.rawValue!.isNotEmpty) {
      Vibration.vibrate(duration: 500);
      // Stop scanning and navigate to the next screen
      controller.stop().then((_) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => CurrentScan(
              data: barcode.rawValue.toString(),
              format: barcode.format.toString(),
              time: DateTime.now(),
              index: 0,
            ),
          ),
        ).then(
          (_) {
            setState(() {
              _isScanning = true;
            });
            controller.start(); // Restart the scanner after navigation returns
          },
        );
        // Store the scanned data in Firestore
        _firebase.collection('scans').add({
          'data': barcode.rawValue.toString(),
          'format': barcode.format.toString(),
          'time': DateTime.now(),
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('Place the QR Code in the area',
                style: TextStyle(fontSize: 18)),
            const Text('Scanning will start automatically',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    width: 320,
                    margin: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (barcodes) => scanQR(barcodes),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value,
                        left: 40,
                        right: 40,
                        child: Container(
                          height: 5,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    child: CustomCorner(sides: ['top', 'left', 'topLeft']),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: CustomCorner(sides: ['top', 'right', 'topRight']),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child:
                        CustomCorner(sides: ['bottom', 'right', 'bottomRight']),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    child:
                        CustomCorner(sides: ['bottom', 'left', 'bottomLeft']),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            IconButton.filled(
              onPressed: () {
                controller.toggleTorch();
                setState(() {
                  toggleFlash = !toggleFlash;
                });
              },
              icon: toggleFlash
                  ? const Icon(Icons.flash_on)
                  : const Icon(Icons.flash_off),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              style: const ButtonStyle(
                enableFeedback: true,
                elevation: WidgetStatePropertyAll(10),
                shadowColor: WidgetStatePropertyAll(Colors.deepPurpleAccent),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _isScanning =
                      false; // Stop scanning when navigating to ScanHistory
                });
                controller.stop(); //
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => const ScanHistory(),
                ))
                    .then(
                  (_) {
                    setState(() {
                      _isScanning = true;
                    });
                    controller.start();
                  },
                );
              },
              child: const Text(
                'Scan History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
