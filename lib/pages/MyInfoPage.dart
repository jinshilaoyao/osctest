import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:osctest/event/ChangeThemeEvent.dart';
import 'package:osctest/event/LoginEvent.dart';
import 'package:osctest/model/UserInfo.dart';
import 'package:osctest/util/DataUtils.dart';
import 'package:osctest/util/NetUtils.dart';
import 'package:osctest/util/ThemeUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants.dart';
import '../event/LogoutEvent.dart';
import '../api/Api.dart';
import '../pages/NewLoginPage.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  Color themeColor = ThemeUtils.currentColorTheme;

  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var titles = ["我的消息", "阅读记录", "我的博客", "我的问答", "我的活动", "我的团队", "邀请好友"];
  var imagePaths = [
    "images/ic_my_message.png",
    "images/ic_my_blog.png",
    "images/ic_my_blog.png",
    "images/ic_my_question.png",
    "images/ic_discover_pos.png",
    "images/ic_my_team.png",
    "images/ic_my_recommend.png"
  ];

  var icons = [];
  var userAvatar;
  var userName;
  var titleTextStyle = TextStyle(fontSize: 16.0);
  var rightArrowIcon = Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  _MyInfoPageState() {
    print("object");
    for (int i = 0; i < imagePaths.length; i++) {
      icons.add(getIconImage(imagePaths[i]));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showUserInfo();

    Constants.eventBus.on<LogoutEvent>().listen((event) {
      _showUserInfo();
    });

    Constants.eventBus.on<LoginEvent>().listen((event) {
      getUserInfo();
    });

    Constants.eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        themeColor = event.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: titles.length + 1,
      itemBuilder: (context, i) => renderRow(i),
    );
  }

  renderRow(i) {
    if (i == 0) {
      var avatorContainer = Container(
        color: themeColor,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? Image.asset("images/ic_avatar_default.png", width: 60)
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: NetworkImage(userAvatar), fit: BoxFit.cover),
                        border: Border.all(color: Colors.white, width: 2.0),
                      ),
                    ),
              Text(
                userName == null ? "点击头像登录" : userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
      return GestureDetector(
        onTap: () {
          DataUtils.isLogin().then((islogin) {
            if (islogin) {
              // _showUserInfoDetail();
            } else {
              _login();
            }
          });
        },
        child: avatorContainer,
      );
    }
    --i;
    String title = titles[i];
    var listItemContent = Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: Row(
        children: <Widget>[
          icons[i],
          Expanded(
            child: Text(title, style: titleTextStyle),
          ),
          rightArrowIcon
        ],
      ),
    );
    return InkWell(
      child: listItemContent,
      onTap: () {
        // _handleListItemClickP(title);
      },
    );
  }

_login() async {
  final result = await Navigator.of(context).push(MaterialPageRoute(builder: (conetxt) {
    return NewLoginPage();
  }));


}

  _showUserInfo() {
    DataUtils.getUserInfo().then((UserInfo userInfo) {
      if (userInfo != null) {
        userAvatar = userInfo.avatar;
        userName = userInfo.name;
      } else {
        setState(() {
          userAvatar = null;
          userName = null;
        });
      }
    });
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  getUserInfo() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String accessToken = sp.get(DataUtils.SP_AC_TOKEN);
      Map<String, String> params = Map();
      params['access_token'] = accessToken;
      NetUtils.get(Api.userInfo, params: params).then((data) {
        if (data != null) {
          var map = json.decode(data);
          setState(() {
            userAvatar = map['avater'];
            userName = map['name'];
          });
          DataUtils.saveUserInfo(map);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
