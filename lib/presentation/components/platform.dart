// import 'dart:convert'; // For base64Decode
// import 'package:flutter/foundation.dart';

// import 'package:js/js.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:js_util';

// Future<void> printPdfFiles(base64Images) async {
//   var doc = pw.Document(
//     compress: false,
//     version: PdfVersion.pdf_1_5,
//   );

//   final decodedImages = base64Images.map((e) => base64Decode(e)).toList();

//   // Add compressed images to the PDF document
//   for (final imageData in decodedImages) {
//     final image = pw.MemoryImage(imageData);

//     doc.addPage(
//       pw.Page(
//         margin: pw.EdgeInsets.zero,
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Image(
//               image,
//               // height: 100,
//               // width: 100,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   if (kIsWeb) {
//     // Code for web
//     await Printing.layoutPdf(
//         format: PdfPageFormat.a4,
//         onLayout: (_) async {
//           var res = await _javaScriptCode();
//           return res;
//         });
//   } else {
//     // Code for other platforms
//     await Printing.layoutPdf(
//       format: PdfPageFormat.a4,
//       onLayout: (_) async => await doc.save(),
//     );
//   }

//   // final pdf = await rootBundle.load('pd.pdf');
//   // await Printing.layoutPdf(
//   //   format: PdfPageFormat.a4,
//   //   onLayout: (_) => pdf.buffer.asUint8List(),
//   // );
// }

// Future<Uint8List> _javaScriptCode(List base64Images) async {
//   var jsPromise = createPdfFromImages(base64Images);
//   var dartFuture = promiseToFuture(jsPromise); // Convert the JavaScript Promise to a Dart Future
//   var result = await dartFuture; // Await the resolved Future
//   if (result is Uint8List) return result;
//   throw "Could not receive pdf";
// }

// @JS('createPdfFromImages')
// external Uint8List createPdfFromImages(base64formslist);
