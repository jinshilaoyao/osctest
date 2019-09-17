import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:osctest/api/Api.dart';
import 'package:osctest/pages/NewsDetailPage.dart';
import 'package:osctest/util/NetUtils.dart';
import 'package:osctest/widgets/SlideView.dart';
import 'package:osctest/widgets/SlideViewIndicator.dart';
import 'package:osctest/Constants.dart';
import 'package:osctest/widgets/CommonEndLine.dart';

final slideViewIndicatorStateKey = GlobalKey<SlideViewIndicatorState>();

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final ScrollController _controller = ScrollController();
  final TextStyle titleTextStyle = TextStyle(fontSize: 15.0);
  final TextStyle subtitleStyle =
      TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);

  var listData;
  var slideData;
  var curPage = 1;
  SlideView slideView;
  var listTotalSize = 0;
  SlideViewIndicator indicator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        curPage++;
        getNewsList(true);
      }
    });
    getNewsList(false);
  }

  getNewsList(bool isLoadMore) {
    String url = Api.newsList;

    url += "?pageIndex=$curPage&pageSize=10";
    NetUtils.get(url).then((data) {
      if (data != null) {
        print(data);
        Map<String, dynamic> map = json.decode(data);
        if (map["code"] == 0) {
          var msg = map['msg'];
          listTotalSize = msg['news']['total'];
          var _listData = msg['news']['data'];
          var _slideData = msg['slide'];

          setState(() {
            if (!isLoadMore) {
              listData = _listData;
              slideData = _slideData;
            } else {
              List list1 = List();
              list1.addAll(listData);
              list1.addAll(_listData);

              if (list1.length >= listTotalSize) {
                // list1.add(Contents)
              }
              listData = list1;
              slideData = _slideData;
            }
            initSlider();
          });
        }
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewsList(false);
    return null;
  }

  void initSlider() {
    indicator =
        SlideViewIndicator(slideData.length, key: slideViewIndicatorStateKey);
    slideView = SlideView(slideData, indicator, slideViewIndicatorStateKey);
  }

  Widget renderRow(i) {
    if (i == 0) {
      return Container(
        height: 180,
        child: Stack(
          children: <Widget>[
            slideView,
            Container(
              alignment: Alignment.bottomCenter,
              child: indicator,
            )
          ],
        ),
      );
    }

    i -= 1;
    if (i.isOdd) {
      return Divider(height: 1.0);
    }

    i = i ~/ 2;
    var itemData = listData[i];
    if (itemData is String && itemData == Constants.endLineTag) {
      return CommonEndLine();
    }

    var titleRow = Row(
      children: <Widget>[
        Expanded(
          child: Text(itemData['title'], style: titleTextStyle),
        )
      ],
    );

    var timeRow = Row(
      children: <Widget>[
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFECECEC),
              image: DecorationImage(
                  image: NetworkImage(itemData['authorImg']),
                  fit: BoxFit.cover),
              border: Border.all(color: const Color(0xFFECECEC), width: 2.0)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(itemData["timeStr"], style: subtitleStyle),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${itemData['commCount']}", style: subtitleStyle),
              Image.asset(
                './images/ic_comment.png',
                width: 16.0,
                height: 16.0,
              )
            ],
          ),
        )
      ],
    );
    
    var thumbImgUrl = itemData['thumb'];
    bool flag = thumbImgUrl != null && thumbImgUrl.length > 0;
    var thumbImg = Container(
      margin: EdgeInsets.all(10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: DecorationImage(
            image: flag ? NetworkImage(thumbImgUrl) : ExactAssetImage('./images/ic_img_default.jpg'),
            fit: BoxFit.cover),
        border: Border.all(
          color: const Color(0xFFECECEC),
          width: 2.0,
        ),
      ),
    );

    var row = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                titleRow,
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6.0),
          child: Container(
            width: 100,
            height: 80,
            color: Color(0xFFECECEC),
            child: Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );
    return InkWell(
      child: row,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => NewsDetailpage(id: itemData['detailUrl'])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length * 2,
        itemBuilder: (context, i) => renderRow(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }
}
