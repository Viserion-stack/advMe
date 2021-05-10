import 'package:advMe/providers/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final settings = Provider.of<user.User>(context);
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: settings.isDark ? Color(0x0000001A) : Colors.grey[300],
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            color: settings.isDark ? Color(0xFF565656) : Colors.white,
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFCECECE),
                    //Colors.white54,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      _previewImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey[300],
                    //     blurRadius: 10,
                    //     spreadRadius: 0.5,
                    //     offset: Offset(0, 8),
                    //   ),
                    // ],
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                      width: 2,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.location_on,
                      color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                      //Colors.white54,
                    ),
                    label: Text(
                      'Current Location',
                      style: TextStyle(
                         
                        color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                        //Colors.white54,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _getCurrentUserLocation,
                  ),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey[300],
                    //     blurRadius: 10,
                    //     spreadRadius: 0.5,
                    //     offset: Offset(0, 8),
                    //   ),
                    // ],
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                      width: 2,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.map,
                      color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                      //Colors.white54,
                    ),
                    label: Text(
                      'Select on Map',
                      style: TextStyle(
                        color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                        //Colors.white54,
                      ),
                    ),
                    textColor: Theme.of(context).accentColor,
                    onPressed: _selectOnMap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
