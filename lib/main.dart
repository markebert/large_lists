import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(
    MyApp(
      items: List<int>.generate(10000, (i) => i),
    ),
  );
}

class MyApp extends StatefulWidget {
  final List<int> items;

  const MyApp({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ScrollController _scrollController = ScrollController();

  Widget _orderItemTile(List<int> items, int index) {
    var displayNumber = items[index];
    return SizedBox.fromSize(
      size: const Size(500, 250),
      child: LayoutGrid(
        columnSizes: [5.px, 1.fr, 10.px, 3.fr, 10.px, 1.fr, 5.px],
        rowSizes: [5.px, 1.fr, 1.fr, 1.fr, 5.px],
        children: [
          Center(
            child: IconButton(
              onPressed: () => setState(() {
                items.removeAt(index);
              }),
              icon: const Icon(Icons.delete),
            ),
          ).withGridPlacement(columnStart: 1, rowStart: 1, rowSpan: 3),
          const VerticalDivider(
            color: Colors.blueGrey,
          ).withGridPlacement(columnStart: 2, rowStart: 1, rowSpan: 3),
          Container(
            color: Colors.amber[200],
          ).withGridPlacement(columnStart: 3, rowStart: 1),
          Container(
            color: Colors.amber[300],
            child: Center(child: Text('Item $displayNumber')),
          ).withGridPlacement(columnStart: 3, rowStart: 2),
          Container(
            color: Colors.amber[400],
          ).withGridPlacement(columnStart: 3, rowStart: 3),
          const VerticalDivider(
            color: Color.fromARGB(255, 2, 3, 3),
          ).withGridPlacement(columnStart: 4, rowStart: 1, rowSpan: 3),
          Center(
            child: IconButton(
              onPressed: () => setState(() {
                items[index]++;
              }),
              icon: const Icon(Icons.edit),
            ),
          ).withGridPlacement(columnStart: 5, rowStart: 1, rowSpan: 3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Long List';

    var items = widget.items;

    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemCount: items.length,
            prototypeItem: _orderItemTile(items, 0),
            itemBuilder: (context, index) =>
                _orderItemTile(items, items.length - 1 - index),
          ),
          bottomNavigationBar: SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    for (int i = 0; i < 1000; i++) {
                      setState(() {
                        items.addAll(
                            List<int>.generate(1, (i) => items.last + 1 + i));
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.jumpTo(0);
                      });
                      await Future.delayed(const Duration(milliseconds: 5));
                    }
                  },
                  child: const Text('Add More Data'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    for (int i = 0; i < 10; i++) {
                      setState(() {
                        items.removeLast();
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.jumpTo(0);
                      });
                      await Future.delayed(const Duration(milliseconds: 100));
                    }
                  },
                  child: const Text('Remove Data'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var randomIndex = Random().nextInt(items.length - 1);
                    print(
                        'Changing Index $randomIndex | ${items[randomIndex]}');
                    setState(() {
                      items[randomIndex]++;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController
                          .jumpTo(250.0 * (items.length - 2 - randomIndex));
                    });
                  },
                  child: const Text('Change Random Data'),
                ),
              ],
            ),
          )),
    );
  }
}
