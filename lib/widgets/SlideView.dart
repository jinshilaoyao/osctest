import 'package:flutter/material.dart';

import '../pages/NewsDetailPage.dart';
import 'SlideViewIndicator.dart';

class SlideView extends StatefulWidget {
  final List data;
  final SlideViewIndicator slideViewIndicator;
  final GlobalKey<SlideViewIndicatorState> globalKey;

  SlideView(this.data, this.slideViewIndicator, this.globalKey);

  @override
  _SlideViewState createState() => _SlideViewState();
}

class _SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List slideData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slideData = this.widget.data;
    tabController = TabController(
        length: slideData == null ? 0 : slideData.length, vsync: this);
    tabController.addListener(() {
      this.widget.globalKey.currentState.setSelectedIndex(tabController.index);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  Widget generateCard() {
    return Card(
      color: Colors.blue,
      child: Image.asset("images/ic_avatar_default.png", width: 20, height: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    if (slideData != null && slideData.length > 0) {
      for (var i = 0; i < slideData.length; i++) {
        var item = slideData[i];
        var imgUrl = item['imgUrl'];
        var title = item['title'];
        var detailUrl = item['detailUrl'];

        items.add(GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => NewsDetailpage(id: detailUrl)
            ));
          },
          child: Stack(
            children: <Widget>[
              Image.network(imgUrl,width: MediaQuery.of(context).size.width, fit:BoxFit.cover),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0x50000000),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(title, style:TextStyle(color:Colors.white,fontSize:15.0)),
                ),
              )
            ],
          ),
        ));
      }
    }

    return TabBarView(
      controller: tabController,
      children: items,
    );
  }
}
