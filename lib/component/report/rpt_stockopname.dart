import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pos_new/component/message/getwarning.dart';
import 'package:flutter_pos_new/component/server.dart';
import 'package:flutter_pos_new/component/report/pdfcreate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
 
 
import 'dart:io';

//import 'package:webview_flutter/webview_flutter.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:get_storage/get_storage.dart';

class InAppWebViewExampleScreen_StockOpnm extends StatefulWidget {

final String kodecab;
final String u_name;
 final String? title;

InAppWebViewExampleScreen_StockOpnm({Key?key,required this.kodecab,required this.u_name,required this.title}):super(key: key);


// Future<void> _convertImageToPDF(screenShot) async {
 
  

// //Create a new PDF document.
// final PdfDocument document = PdfDocument();
// //Read image data.
// final Uint8List imageData = File(screenShot).readAsBytesSync();
// //Load the image using PdfBitmap.
// final PdfBitmap image = PdfBitmap(imageData);
// //Draw the image to the PDF page.
// document.pages
//     .add()
//     .graphics
//     .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));
// // Save the document.

// File('ImageToPDF.pdf').writeAsBytes(await document.save());
// // Dispose the document.
// document.dispose();


//   }

  @override
  _InAppWebViewExampleScreen_StockOpnmState createState() =>
      new _InAppWebViewExampleScreen_StockOpnmState(kodecab:kodecab,u_name:u_name,title: title);
}

class _InAppWebViewExampleScreen_StockOpnmState extends State<InAppWebViewExampleScreen_StockOpnm> {
//InAppWebViewController webViewController;

  final String? kodecab;
  final String? u_name;
  final String? title;

  _InAppWebViewExampleScreen_StockOpnmState({required this.kodecab,required this.u_name,required this.title});

// getprint() async {
  
// final printJobController = await webViewController.printCurrentPage(settings: PrintJobSettings(handledByClient: true));
// } 



  InAppWebViewController? webView;
  Uint8List? screenshotBytes;
  final box=GetStorage();

 
  static String _temp_nophone='';
  


  @override
  void initState() {
    //EasyLoading.dismiss();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title!,style: TextStyle(fontSize: 13,)),
        automaticallyImplyLeading: false,
        actions: [

           IconButton(onPressed: ()  {
             
               Navigator.pop(context);
            

          }, icon: Icon(Icons.close,size: 30,)) ,  

          IconButton(onPressed: ()  {
             
                   final  filename=DateTime.now().microsecondsSinceEpoch;  
                screenToPdf("Rpt"+filename.toString(), screenshotBytes!,u_name!);
              //setMessage(nohp!, context);
            

          }, icon: Icon(Icons.picture_as_pdf_sharp,size: 30,)) , 

          IconButton(onPressed: ()  {
             
               final  filename=DateTime.now().microsecondsSinceEpoch;  
               screenToImage("Rpt"+filename.toString(), screenshotBytes!,u_name!);
            

          }, icon: Icon(Icons.image_search,size: 30,)),
          SizedBox(width: 5,),

              IconButton(onPressed: ()  async {
             
                final  filename=DateTime.now().microsecondsSinceEpoch;  
             screenToPrint("Rpt"+filename.toString(), screenshotBytes!);
            

          }, icon: Icon(Icons.print,size: 30,)),
          SizedBox(width: 5,)
           
        ], 
        ),
         
        
        body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
          Expanded(
              child: InAppWebView(
          //  initialUrlRequest: URLRequest(url: Uri.parse(NamaServer.server+'tests/flutter/crude_2/reportinventeorynew.php?pr_no='+pr_no!+'&u_name='+box.read('u_name'),)),
        //initialUrlRequest: URLRequest(url: Uri.parse(NamaServer.Server+'posheru/printpos_return_1.php?nopos='+nopos!,)),
        initialUrlRequest: URLRequest(url: WebUri(NamaServer.Server+'posheru/Stockopnamesaja.php?kodecab='+kodecab!+'&u_name='+u_name!,)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                //  debuggingEnabled: true
                supportZoom: true
                 ),
              android: AndroidInAppWebViewOptions(
                textZoom: 300,
                builtInZoomControls: true,
                displayZoomControls: true,
                 

              )   
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onPrint: (InAppWebViewController  controller, url) {
              // webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, url) {},
            onLoadStop: (InAppWebViewController controller, url) async {
             screenshotBytes = await controller.takeScreenshot();
             //screenToPdf("irawanxxx", screenshotBytes!);
              // screenToImage("irawanimage", screenshotBytes!);


              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return AlertDialog(
              //       content: Image.memory(screenshotBytes!),
              //     );
              //   },
              // );
            },
          ))
        ])));
  }
}