import 'package:flutter/material.dart';

class ExampleWidget extends StatefulWidget {
  ExampleWidget({Key? key}) : super(key: key);

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  double maxHeaderHeight = 200;
  late ScrollController _scrollController;
  final ValueNotifier<double> opacity = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
  }

  scrollListener() {
    if (maxHeaderHeight > _scrollController.offset && _scrollController.offset > 1) {
      opacity.value = 1 - _scrollController.offset / maxHeaderHeight;
    } else if (_scrollController.offset > maxHeaderHeight && opacity.value != 1) {
      opacity.value = 0;
    } else if (_scrollController.offset < 0 && opacity.value != 0) {
      opacity.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            title: ValueListenableBuilder<double>(
                valueListenable: opacity,
                builder: (context, value, child) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 1),
                    opacity: 1 - value,
                    child: const Text("Some Text....", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  );
                }),
            pinned: true,
            expandedHeight: maxHeaderHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Some Text....", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Some Primary Text....", style: TextStyle(color: Colors.black, fontSize: 18)),
                    ],
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: List.generate(
                        100,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text("Index $index"),
                        )),
                  )
                ],
              ))
        ],
      ),
    );
  }
}