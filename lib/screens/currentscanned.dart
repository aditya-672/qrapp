import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CurrentScan extends StatefulWidget {
  const CurrentScan({
    super.key,
    required this.data,
    required this.format,
    required this.time,
    required this.index,
  });

  final String data;
  final String format;
  final DateTime time;
  final int index;

  @override
  State<CurrentScan> createState() => _CurrentScanState();
}

class _CurrentScanState extends State<CurrentScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          const Text(
            'QR Code Scanned Details',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Center(
            child: Card(
              elevation: 20,
              shadowColor: Colors.deepPurpleAccent,
              color: Theme.of(context).colorScheme.inversePrimary,
              margin: const EdgeInsets.all(26),
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Text(widget.format == "BarcodeFormat.qrCode"
                        ? "Scanned QR Code"
                        : "Scanned Barcode"),
                    Card(
                      elevation: 8,
                      child: widget.format == "BarcodeFormat.qrCode"
                          ? Hero(
                              tag: '${widget.data}+${widget.index}',
                              child: QrImageView(
                                data: widget.data,
                                version: QrVersions.auto,
                                size: 200,
                              ),
                            )
                          : Hero(
                              tag: '${widget.data}+${widget.index}',
                              child: BarcodeWidget(
                                data: widget.data,
                                barcode: Barcode.code128(),
                                drawText: false,
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                      // child: Image.memory(widget.image),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      // height: 100,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.data,
                                  style: const TextStyle(fontSize: 18),
                                  // maxLines: 3,
                                  // overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Format : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.format == 'BarcodeFormat.qrCode'
                                    ? "QR Code"
                                    : "Barcode",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Date : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy, EEE')
                                    .format(widget.time),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Time : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('hh:mm a').format(widget.time),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
