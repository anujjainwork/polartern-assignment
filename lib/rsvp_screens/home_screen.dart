import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rsvp/theme/slidebutton.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rsvp/rsvp_screens/success_screen.dart';
import 'package:rsvp/theme/customtext.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isRSVPd = false;
  final GlobalKey _screenshotKey = GlobalKey();

  final List<String> imgList = [
    'lib/assets/cover-image-01.jpg',
    'lib/assets/cover-image-02.jpg',
    'lib/assets/cover-image-03.jpg',
  ];

  Future<void> _shareScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgPath = await File('$directory/screenshot.png').create();
        await imgPath.writeAsBytes(pngBytes);

        Share.shareFiles([imgPath.path]);
      }
    } catch (e) {
      print('Error taking screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(children: [
      RepaintBoundary(
        key: _screenshotKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarousel(screenHeight, screenWidth),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildEventDetails(screenWidth),
              ),
            ],
          ),
        ),
      ),
      const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: SlideToConfirmButton(),
          ))
    ]));
  }

  Widget _buildCarousel(double screenHeight, double screenWidth) {
    return Stack(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: screenHeight / 3,
            autoPlay: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemCount: imgList.length,
          itemBuilder: (context, index, _) {
            return Image.asset(
              imgList[index],
              fit: BoxFit.cover,
              width: screenWidth,
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon:
                    const Icon(Icons.more_horiz_outlined, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('No Implementation?'),
                        backgroundColor: Colors.white,
                        content: const Text(
                            'Wonder what I would have done here? hire me :)'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Closes the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: screenWidth / 2 - (imgList.length * 10) / 2, // Center dots
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imgList.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.white : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: "Canyon road trip",
              weight: FontWeight.w400,
              size: 28,
            ),
            IconButton(
                onPressed: () {
                  _shareScreenshot();
                },
                icon: const Icon(
                  Icons.mobile_screen_share_outlined,
                  color: Colors.grey,
                ))
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildEventInfo(
              icon: Icons.watch_later_outlined,
              label: "Date and time",
              value: "3rd Feb,'24 - 6:00 PM",
            ),
            const SizedBox(
              width: 20,
            ),
            _buildEventInfo(
              icon: Icons.account_balance_wallet_outlined,
              label: "Cost",
              value: "Rs. 400",
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildEventInfo(
          icon: Icons.location_on_outlined,
          label: "Location",
          value: "Denpasar → Jakarta",
        ),
        const SizedBox(height: 8),
        _buildDescription(),
        const SizedBox(height: 16),
        _buildHostsRow(),
      ],
    );
  }

  Widget _buildEventInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black.withOpacity(0.5)),
            const SizedBox(width: 8),
            CustomText(
              text: label,
              color: Colors.black.withOpacity(0.5),
              alignment: TextAlign.center,
              size: 14,
            ),
          ],
        ),
        const SizedBox(height: 3),
        CustomText(
          text: value,
          color: Colors.black.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return const CustomText(
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      color: Colors.grey,
      size: 14,
    );
  }

  Widget _buildHostsRow() {
    return Column(
      children: [
        const Row(
          children: [
            Icon(
              Icons.person_outline_rounded,
              color: Colors.grey,
              size: 22,
            ),
            SizedBox(
              width: 4,
            ),
            CustomText(
              text: "Hosts",
              size: 14,
              color: Colors.grey,
            ),
            Spacer(),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Stack(
              children: [
                Transform.translate(
                    offset: const Offset(0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage('lib/assets/profile-image-01.jpg'),
                      ),
                    )),
                Transform.translate(
                    offset: const Offset(
                        23, 0), // Adjust this value for the desired overlap
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage('lib/assets/profile-image-02.jpg'),
                      ),
                    )),
                Transform.translate(
                    offset: const Offset(
                        45, 0), // Adjust this value for the desired overlap
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage('lib/assets/profile-image-03.jpg'),
                      ),
                    )),
              ],
            ),
            const SizedBox(
                width: 64), // Add space to the right of the last avatar
          ],
        )
      ],
    );
  }
}
