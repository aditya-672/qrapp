import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrapp/screens/currentscanned.dart';

class ScanHistory extends StatelessWidget {
  const ScanHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('scans')
              .orderBy('time', descending: true)
              .get()
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Handle cases where there is no data or data is empty
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Scan Something !!!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            }

            var data = snapshot.data!.docs.toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(data[index]),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('scans')
                        .doc(data[index].id)
                        .delete();
                  },
                  background: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red.shade400),
                    padding: const EdgeInsets.only(left: 240),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: InkWell(
                      enableFeedback: true,
                      // splashColor: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(22),
                      highlightColor: Colors.deepPurple.shade300,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CurrentScan(
                              data: data[index]['data'],
                              format: data[index]['format'],
                              time: data[index]['time'].toDate(),
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              12,
                            ),
                          ),
                        ),
                        child: ListTile(
                          enabled: true,
                          enableFeedback: true,
                          focusColor: Colors.deepPurple,
                          tileColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                12,
                              ),
                            ),
                          ),
                          leading:
                              data[index]['format'] == "BarcodeFormat.qrCode"
                                  ? Hero(
                                      tag: '${data[index]['data']}+$index',
                                      child: QrImageView(
                                        data: data[index]['data'],
                                        size: 50,
                                      ),
                                    )
                                  : Hero(
                                      tag: '${data[index]['data']}+$index',
                                      child: BarcodeWidget(
                                        data: data[index]['data'],
                                        barcode: Barcode.code128(),
                                        drawText: false,
                                        padding: const EdgeInsets.all(16),
                                        width: 70,
                                        // height: 50,
                                      ),
                                    ),
                          title: Text(
                            'Data : ${data[index]['data']}',
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy, EEE')
                                    .format(data[index]['time'].toDate()),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                DateFormat('hh:mm a')
                                    .format(data[index]['time'].toDate()),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          subtitleTextStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          leadingAndTrailingTextStyle:
                              const TextStyle(color: Colors.black),
                          trailing:
                              data[index]['format'] == "BarcodeFormat.qrCode"
                                  ? const Text('QR Code')
                                  : const Text('Barcode'),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.length,
            );
          },
        ),
      ),
    );
  }
}
