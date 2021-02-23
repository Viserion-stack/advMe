import 'package:advMe/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllOrders extends StatefulWidget {
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final List<String> categories = [
    'Construction',
    'Renovation',
    'Transport',
    'Mechanic',
  ];

  final List<Color> colorsDark = [
    Color(0xFFF79E1B),
    Color(0xFFCBB2AB),
    Color(0xEEC31331),
    Color(0xFF464656),
  ];

  final List<Color> colorsLight = [
    Color(0xFFFFC03D),
    Color(0xFF387CFF),
    Color(0xFFF1554C),
    Color(0xFF0D276B),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: settings.isDark ? Color(0xFF171923): Color(0xFFE9ECF5),
      ),
      child: Stack(
        children: [
          Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'advMe',
                style: GoogleFonts.ubuntu(
                  color: settings.isDark ? Color(0x40C31331) : Color(0x78FFC03D),
                  fontSize: 140,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: settings.isDark ? colorsDark[index] : colorsLight[index],
                              borderRadius: BorderRadius.circular(40)),
                          width: MediaQuery.of(context).size.width * 0.35,

                          //color: Colors.blue,
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
             // Container(child: ,)
            ],
          )
        ],
      ),
    );
  }
}
