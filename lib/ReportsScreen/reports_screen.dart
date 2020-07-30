import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportsScreen extends StatefulWidget {
  final coinId;

  ReportsScreen(this.coinId);

  @override
  _ReportsScreenState createState() => _ReportsScreenState(coinId);
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = true;
  PDFDocument doc;
  final coinId;

  _ReportsScreenState(this.coinId);

  @override
  void initState() {
    loadFromUrl().then((value) => null);
    super.initState();
  }

  loadFromAssets() async {
    setState(() {
      _isLoading = true;
    });
    doc = await PDFDocument.fromAsset('assets/sample.pdf');
    setState(() {
      _isLoading = false;
    });
  }

  loadFromUrl() async {
    setState(() {
      _isLoading = true;
    });
    doc = await PDFDocument.fromURL(
        'https://live.curs-valutar.xyz/reports/$coinId/');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 8,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : PDFViewer(
                      document: doc,
                    ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
