// ignore_for_file: file_names, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/signin/signin.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: (currentIndex == contents.length - 1) ? kPrimaryColor : kBGColor,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: kLightColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          contents[i].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: kLightColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => Spacing(index, context),
              ),
            ),
            Container(
              height: 60,
              width: 150,
              margin: const EdgeInsets.all(40),
              // color: kLightColor,
              child: ElevatedButton(
                
                onPressed: () {
                  if (currentIndex == contents.length - 1) {
                    //transition to login/signup page

                    print("Button CLicked");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  }
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceIn);
                },
                
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: kLightColor, width: 1),
                  backgroundColor: (currentIndex == contents.length - 1) ? kBGColor : kPrimaryColor
                ),
                child: Text(
                  currentIndex == contents.length - 1 ? 'Continue' : 'Next',
                  style: const TextStyle(color: kLightColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container Spacing(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (currentIndex == contents.length - 1) ? kBGColor : kPrimaryColor,
      ),
    );
  }
}

class OnboardContents {
  String image;
  String title;
  String description;

  OnboardContents(
      {required this.image, required this.title, required this.description});
}

List<OnboardContents> contents = [
  OnboardContents(
      image: 'assets/images/slide1.jpg',
      title: 'Locate Potential Boarding Houses',
      description:
          'Wherever your endeavors go, there will always be a suitable place for you.'),
  OnboardContents(
      image: 'assets/images/slide2.png',
      title: 'Communicate in Real-Time',
      description:
          'Interact with fellow boarding house enthusiasts and future roommates.'),
  OnboardContents(
    image: 'assets/images/slide3.png',
    title: 'Peruse according to your preferences',
    description:
        'Choose the boarding house that suits you best in a smart way.',
  ),
];
