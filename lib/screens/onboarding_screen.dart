import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/utils/constants.dart';
import 'package:gh_styles/screens/onboarding/slider.dart';
import 'package:gh_styles/screens/onboarding/slide_item.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: topSliderLayout());

  Widget topSliderLayout() => Container(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: sliderArrayList.length,
                  itemBuilder: (context, i) => OnboardingSliderItem(i),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                        child: Text(
                          Constants.NEXT,
                          style: TextStyle(
                            fontFamily: Constants.OPEN_SANS,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/main_screen_wrapper');
                            },
                            child: Text(
                              Constants.SKIP,
                              style: TextStyle(
                                fontFamily: Constants.OPEN_SANS,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                          )),
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < sliderArrayList.length; i++)
                            if (i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
}

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        border: isActive
            ? Border.all(
                color: Color(0xff927DFF),
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
