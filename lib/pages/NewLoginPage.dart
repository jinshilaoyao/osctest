import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:osctest/util/DataUtils.dart';
import 'package:osctest/util/NetUtils.dart';
import 'package:osctest/util/ThemeUtils.dart';
import '../Constants.dart';

class NewLoginPage extends StatefulWidget {
  @override
  _NewLoginPageState createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  // 首次加载登录页
  static const int stateFirstLoad = 1;
  // 加载完毕登录页，且当前页面是输入账号密码的页面
  static const int stateLoadedInputPage = 2;
  // 加载完毕登录页，且当前页面不是输入账号密码的页面
  static const int stateLoadedNotInputPage = 3;

  int curState = stateFirstLoad;

  // 标记是否是加载中
  bool loading = true;
  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  // 是否正在登录
  bool isOnLogin = false;
  // 是否隐藏输入的文本
  bool obscureText = true;
  // 是否解析了结果
  bool parsedResult = false;

  final usernameCtrl = TextEditingController(text: '');
  final passwordCtrl = TextEditingController(text: '');

  // 检查当前是否是输入账号密码界面，返回1表示是，0表示否
  final scriptCheckIsInputAccountPage =
      "document.getElementById('f_email') != null";

  final jsCtrl = TextEditingController(
      text: 'document.getElementById(\'f_email\') != null');
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // URL变化监听器
  StreamSubscription<String> _onUrlChanged;
  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            // 当前是回调页面，则调用js方法获取数据，延迟加载防止get()获取不到数据
            Timer(const Duration(seconds: 1), () {
              // parseResult();
            });
            return;
          }
          switch (curState) {
            case stateFirstLoad:
            case stateLoadedInputPage:
              // 首次加载完登录页，判断是否是输入账号密码的界面
//               isInputPage().then((result) {
//                 if ("true".compareTo(result) == 0) {
//                   // 是输入账号的页面，则直接填入账号密码并模拟点击登录按钮
// //                  autoLogin();
//                 } else {
//                   // 不是输入账号的页面，则需要模拟点击"换个账号"按钮
//                   redirectToInputPage();
//                 }
              // });
              break;
            case stateLoadedNotInputPage:
              // 不是输入账号密码的界面，则需要模拟点击"换个账号"按钮
              break;
          }
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((url) {
      // 登录成功会跳转到自定义的回调页面，该页面地址为http://yubo725.top/osc/osc.php?code=xxx
      // 该页面会接收code，然后根据code换取AccessToken，并将获取到的token及其他信息，通过js的get()方法返回
      if (url != null && url.length > 0 && url.contains("/logincallback?")) {
        isLoadingCallbackPage = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0,
              child: WebviewScaffold(
                hidden: true,
                key: _scaffoldKey,
                url: Constants.loginUrl,
                withZoom: true, // 允许网页缩放
                withLocalStorage: true, // 允许LocalStorage
                withJavascript: true, //
              ),
            ),
            Center(child: Text("请使用OSC帐号密码登录")),
            Container(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("userName:"),
                Expanded(
                  child: TextField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      hintText: "OSC帐号/注册邮箱",
                      hintStyle: TextStyle(color: Color(0xff808080)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0))
                      ),
                      contentPadding: EdgeInsets.all(10)
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
