import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/network_indicator.dart';
import 'package:e_wallet/Notifications/notifications_flushbar/notifications_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';

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
            NetworkIndicator(),
            NotificationsFlushbar(),
            Flexible(
              flex: 8,
              child: _isLoading
                  ? Column(
                      children: [
                        SizedBox(height: 300),
                        Container(child: CircularProgressIndicator())
                      ],
                    )
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
