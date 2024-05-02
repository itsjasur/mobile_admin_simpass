import 'dart:convert'; // For base64Decod
import 'package:admin_simpass/globals/main_ui.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:js/js.dart';

import 'package:flutter/foundation.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

class RegistrationImageViewerContent extends StatefulWidget {
  final List<String> binaryImageList;
  const RegistrationImageViewerContent({super.key, required this.binaryImageList});

  @override
  State<RegistrationImageViewerContent> createState() => _RegistrationImageViewerContentState();
}

class _RegistrationImageViewerContentState extends State<RegistrationImageViewerContent> {
  double _rotationAngle = 0.0; // Rotation angle in radians
  int? _currentIndex;
  bool _sendingToPrint = false;
  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
  }

  void _rotateImage() {
    // incrementint the rotation angle by 90 degrees (in radians)
    setState(() {
      _rotationAngle += 90 * (3.141592653589793 / 180); // 90 degrees in radians
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IgnorePointer(
        ignoring: _sendingToPrint,
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_currentIndex != null)
                AspectRatio(
                  aspectRatio: 1,
                  child: Transform.rotate(
                    angle: _rotationAngle,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.memory(
                        base64.decode(widget.binaryImageList[_currentIndex!]),
                      ),
                    ),
                  ),
                ),
              if (_currentIndex == null)
                const Text(
                  'No image',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white38,
                  ),
                ),
              Positioned(
                right: 0,
                top: 0,
                child: Material(
                  color: Colors.transparent,
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
                        color: Colors.black12,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    hoverColor: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (_currentIndex != null && _currentIndex! >= 1) {
                        _currentIndex = _currentIndex! - 1;
                        setState(() {});
                      }
                    },
                    onHover: (value) {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    hoverColor: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (_currentIndex != null && _currentIndex! < widget.binaryImageList.length - 1) {
                        _currentIndex = _currentIndex! + 1;
                        setState(() {});
                      }
                    },
                    onHover: (value) {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                        onTap: _rotateImage,
                        onHover: (value) {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12,
                          ),
                          padding: const EdgeInsets.all(15),
                          child: const Icon(
                            Icons.rotate_90_degrees_cw_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          setState(() {
                            _sendingToPrint = true;
                          });
                          await Future.delayed(const Duration(milliseconds: 50));

                          // _javaScriptCode();
                          _printPdf();
                          setState(() {
                            _sendingToPrint = false;
                          });
                        },
                        onHover: (value) {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12,
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
                  ],
                ),
              ),
              _sendingToPrint
                  ? const Center(
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(
                          color: MainUi.mainColor,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
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

    if (kIsWeb) {
      // Code for web
      await Printing.layoutPdf(
          format: PdfPageFormat.a4,
          onLayout: (_) async {
            var res = await _javaScriptCode();
            return res;
          });
    } else {
      // Code for other platforms
      await Printing.layoutPdf(
        format: PdfPageFormat.a4,
        onLayout: (_) async => await doc.save(),
      );
    }

    // final pdf = await rootBundle.load('pd.pdf');
    // await Printing.layoutPdf(
    //   format: PdfPageFormat.a4,
    //   onLayout: (_) => pdf.buffer.asUint8List(),
    // );

    setState(() {});
  }

  Future<Uint8List> _javaScriptCode() async {
    var jsPromise = createPdfFromImages(widget.binaryImageList);
    var dartFuture = promiseToFuture(jsPromise); // Convert the JavaScript Promise to a Dart Future
    var result = await dartFuture; // Await the resolved Future
    if (result is Uint8List) return result;
    throw "Could not receive pdf";
  }
}

@JS('createPdfFromImages')
external Uint8List createPdfFromImages(base64formslist);
