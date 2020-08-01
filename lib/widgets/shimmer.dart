import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoaderHorizontal extends StatefulWidget {
  @override
  _ShimmerLoaderHorizontalState createState() =>
      _ShimmerLoaderHorizontalState();
}

class _ShimmerLoaderHorizontalState extends State<ShimmerLoaderHorizontal> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 35.0,
        maxHeight: 180.0,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 16,
            itemBuilder: (context, int index) {
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 160.0,
                        maxWidth: 170.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.red,
                              height: 20,
                              width: 50,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 20,
                            padding: const EdgeInsets.only(left: 10.0),
                            color: Colors.red,
                            width: double.infinity,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  )
                ],
              );
            }),
      ),
    );
  }
}

///////////////////////////////////////////////

class ShimmerLoaderVertical extends StatefulWidget {
  @override
  _ShimmerLoaderVerticalState createState() => _ShimmerLoaderVerticalState();
}

class _ShimmerLoaderVerticalState extends State<ShimmerLoaderVertical> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: _enabled,
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 25,
                  childAspectRatio: .8),
              itemCount: 16,
              itemBuilder: (context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.red,
                        height: 20,
                        width: 50,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 20,
                      padding: const EdgeInsets.only(left: 10.0),
                      color: Colors.red,
                      width: double.infinity,
                    )
                  ],
                );
              })),
    );
  }
}
