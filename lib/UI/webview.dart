import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as _widget;
class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({Key key, this.title, @required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Stack(
        children: <Widget>[
          _widget.WebView(
            initialUrl: widget.url,
            onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
            javascriptMode: _widget.JavascriptMode.unrestricted,
          ),
          // if (isLoading) kLoadingWidget(context),
        ],
      ),
    );
  }
}