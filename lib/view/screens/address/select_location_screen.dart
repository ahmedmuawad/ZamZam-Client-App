import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/address/widget/location_search_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController googleMapController;
  SelectLocationScreen({required this.googleMapController});

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).setPickData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _openSearchDialog(
      BuildContext context, GoogleMapController mapController) async {
    showDialog(
        context: context,
        builder: (context) =>
            LocationSearchDialog(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    _locationController.text =
        '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
        '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
        '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? MainAppBar()
          : CustomAppBar(
              title: getTranslated('select_delivery_address', context),
              isCenter: true,
              onBackPressed: () {},
            ),
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(locationProvider.position.latitude,
                        locationProvider.position.longitude),
                    zoom: 17,
                  ),
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  onCameraIdle: () {
                    locationProvider.updatePosition(
                        _cameraPosition, false, null, context);
                  },
                  onCameraMove: ((_position) => _cameraPosition = _position),
                  // markers: Set<Marker>.of(locationProvider.markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                ),
                InkWell(
                  onTap: () => _openSearchDialog(context, _controller),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: 18.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: 23.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.PADDING_SIZE_SMALL)),
                    child: Row(children: [
                      Expanded(
                          child: Text(
                              locationProvider.pickAddress.name != null
                                  ? '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}'
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)),
                      Icon(Icons.search, size: 20),
                    ]),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          locationProvider.getCurrentLocation(context, false,
                              mapController: _controller);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.getCardBgColor(context),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_LARGE),
                          child: CustomButton(
                            buttonText:
                                getTranslated('select_location', context),
                            onPressed: () {
                              widget.googleMapController.moveCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(
                                        locationProvider.pickPosition.latitude,
                                        locationProvider.pickPosition.longitude,
                                      ),
                                      zoom: 17)));
                              locationProvider.setAddAddressData();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                    child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                )),
                locationProvider.loading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
