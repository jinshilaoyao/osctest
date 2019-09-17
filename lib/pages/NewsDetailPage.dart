import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/cupertino.dart';

class NewsDetailpage extends StatefulWidget {
  final String id;

  NewsDetailpage({Key key, this.id}) : super(key: key);
  @override
  _NewsDetailpageState createState() => _NewsDetailpageState(id: this.id);
}

class _NewsDetailpageState extends State<NewsDetailpage> {
  String id;
  bool loaded = false;
  String detailDataStr;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  _NewsDetailpageState({Key key, this.id});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        setState() {
          loaded = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(
      "detail",
      style: TextStyle(color: Colors.white),
    ));
    if (!loaded) {
      titleContent.add(CupertinoActivityIndicator());
    }
titleContent.add(Container(width:50));
    return WebviewScaffold(
      appBar: AppBar(
        title: Text("detail"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      url: this.id,
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
