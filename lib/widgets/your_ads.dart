import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YourAds extends StatefulWidget {
  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color(0xFF171923),
      ),
      child: Stack(
        children: [
          Center(
            child: RotatedBox(
              quarterTurns: 1,
                          child: Text(
                'advMe',
                style: GoogleFonts.ubuntu(
                  color: Color(0x40C31331),
                  fontSize: 140,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}