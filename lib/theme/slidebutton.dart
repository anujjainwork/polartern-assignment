import 'package:flutter/material.dart';
import 'package:rsvp/rsvp_screens/success_screen.dart';
import 'package:rsvp/theme/customtext.dart';

class SlideToConfirmButton extends StatefulWidget {
  const SlideToConfirmButton({super.key});

  @override
  _SlideToConfirmButtonState createState() => _SlideToConfirmButtonState();
}

class _SlideToConfirmButtonState extends State<SlideToConfirmButton> {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      final screenWidth = MediaQuery.of(context).size.width;
      _dragPosition =
          (details.localPosition.dx).clamp(0.0, screenWidth * 0.9 - 80);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (_dragPosition >= screenWidth * 0.9 - 80) {
      setState(() {
        _isConfirmed = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SuccessScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      });
    } else {
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: screenWidth * 0.9,
          height: 70,
          child: GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5ea3b2), // Background color
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: _isConfirmed
                        ? screenWidth * 0.9 - 70
                        : _dragPosition + 10,
                    top: 5,
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      child: _isConfirmed
                          ? const Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30, // Adjust the radius as needed
                                  backgroundColor: Colors.white,
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 30, // Adjust the icon size as needed
                                ),
                              ],
                            )
                          : const Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30, // Adjust the radius as needed
                                  backgroundColor: Colors.white,
                                ),
                                Icon(
                                  Icons.arrow_right_alt_rounded,
                                  color: Colors.black,
                                  size: 30, // Adjust the icon size as needed
                                ),
                              ],
                            ),
                    ),
                  ),
                  Center(
                    child: _isConfirmed
                        ? const CustomText(
                            text: "RSVP'd",
                            color: Colors.white,
                            size: 16,
                          )
                        : const CustomText(
                            text: "Slide to RSVP",
                            color: Colors.white,
                            size: 16,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
