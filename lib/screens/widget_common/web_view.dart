import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String collegeName;
  final bool appbar_display;
  const WebViewPage({super.key, required this.url, this.collegeName = " ", this.appbar_display = true});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar_display? CustomAppBar(collegeName: widget.collegeName):null,
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)), // ✅ Fixed
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
