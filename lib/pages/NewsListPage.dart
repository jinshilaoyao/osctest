import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:osctest/api/Api.dart';
import 'package:osctest/util/NetUtils.dart';
import 'package:osctest/widgets/SlideView.dart';
import 'package:osctest/widgets/SlideViewIndicator.dart';

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
    print(url);
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
          });
        }
      }
    });
  }

  _pullToRefresh() {}

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length * 2,
        itemBuilder: (context, i) => Text("data"),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh());
    }
  }
}
