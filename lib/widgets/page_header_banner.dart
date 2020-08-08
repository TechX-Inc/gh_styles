import 'package:flutter/material.dart';

class PageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our",
          style: Theme.of(context).textTheme.headline4.apply(
              fontWeightDelta: 2, color: Color.fromRGBO(132, 140, 207, 1)),
        ),
        SizedBox(height: 5),
        Text("Products",
            style: Theme.of(context).textTheme.headline4.copyWith(
                height: .9, color: Color.fromRGBO(132, 140, 207, 0.7))),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
