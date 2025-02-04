import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String collegeName;
  const WebViewPage({Key? key, required this.url, required this.collegeName}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(collegeName: widget.collegeName),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)), // ✅ Fixed
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
