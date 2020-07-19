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
                fontWeightDelta: 2,
                color: Colors.black,
              ),
        ),
        Text("Products",
            style: Theme.of(context).textTheme.headline4.copyWith(height: .9)),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
