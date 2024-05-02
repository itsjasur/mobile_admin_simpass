import 'dart:convert'; // For base64Decode
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class ScrollFormImageViewer extends StatefulWidget {
  final List<String> binaryImageList;
  const ScrollFormImageViewer({super.key, required this.binaryImageList});

  @override
  State<ScrollFormImageViewer> createState() => _ScrollFormImageViewerState();
}

class _ScrollFormImageViewerState extends State<ScrollFormImageViewer> {
  bool _sendingToPrint = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Align(
            child: _sendingToPrint
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 1200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: widget.binaryImageList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.memory(
                          base64.decode(widget.binaryImageList[index]),
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                hoverColor: Colors.white54,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  context.pop();
                },
                onHover: (value) {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black38,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: const Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                hoverColor: Colors.white54,
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  setState(() {
                    _sendingToPrint = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 500));

                  _printPdf();

                  setState(() {
                    _sendingToPrint = false;
                  });
                },
                onHover: (value) {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black38,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: const Icon(
                    Icons.print,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printPdf() async {
    var doc = pw.Document(
      compress: false,
      version: PdfVersion.pdf_1_5,
    );

    final decodedImages = widget.binaryImageList.map((e) => base64Decode(e)).toList();

    // Add compressed images to the PDF document
    for (final imageData in decodedImages) {
      final image = pw.MemoryImage(imageData);

      doc.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                image,
                // height: 100,
                // width: 100,
              ),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (_) async => await doc.save(),
    );

    // final pdf = await rootBundle.load('pd.pdf');
    // await Printing.layoutPdf(
    //   format: PdfPageFormat.a4,
    //   onLayout: (_) => pdf.buffer.asUint8List(),
    // );

    setState(() {});
  }
}
