import 'dart:convert'; // For base64Decode
import 'package:admin_simpass/data/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class ScrollFormImageViewer extends StatefulWidget {
  final String applicationId;
  const ScrollFormImageViewer({super.key, required this.applicationId});

  @override
  State<ScrollFormImageViewer> createState() => _ScrollFormImageViewerState();
}

class _ScrollFormImageViewerState extends State<ScrollFormImageViewer> {
  bool _dataLoading = true;
  bool _sendingToPrint = false;
  List<String> _base64ImagesList = [];

  @override
  void initState() {
    super.initState();
    _fetchApplicationImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          _dataLoading
              ? const Align(child: CircularProgressIndicator(color: Colors.white))
              : _base64ImagesList.isEmpty
                  ? const Align(
                      child: Text('첨부파일을 찾을 수 없습니다', style: TextStyle(color: Colors.white)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: _base64ImagesList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.memory(
                          base64.decode(_base64ImagesList[index]),
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
          if (_base64ImagesList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: _sendingToPrint
                    ? const CircularProgressIndicator()
                    : InkWell(
                        hoverColor: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          _sendingToPrint = true;
                          setState(() {});

                          await Future.delayed(const Duration(milliseconds: 50));
                          await _printPdf();

                          _sendingToPrint = false;
                          setState(() {});
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

    final decodedImages = _base64ImagesList.map((e) => base64Decode(e)).toList();

    // Add compressed images to the PDF document
    for (final imageData in decodedImages) {
      final image = pw.MemoryImage(imageData);

      doc.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (_) async => await doc.save(),
    );

    setState(() {});
  }

  Future<void> _fetchApplicationImages() async {
    _dataLoading = true;
    setState(() {});

    _base64ImagesList.clear();

    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchApplicationForms(
        context: context,
        applicationId: widget.applicationId,
      );
      _base64ImagesList = result;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _dataLoading = false;
    setState(() {});
  }
}
