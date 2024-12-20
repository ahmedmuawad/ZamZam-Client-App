import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/view/screens/onboarding/on_boarding_screen.dart';
import 'package:flutter_grocery/view/screens/set_Language/language_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;
  late LatLng currentPostion;
  
  String? index;
  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged!.cancel();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        print('-----------------${isNotConnected ? 'Not' : 'Yes'}');
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context) 
                : getTranslated('connected', context) ,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();

    //_getUserLocation();
    _route();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      /*if (isSuccess) {
        _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;
        _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
        if(Provider.of<SplashProvider>(context, listen: false).configModel.maintenanceMode) {
          Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMaintenanceRoute(), (route) => false);
        }else {
          if(!_isAvailable) {
            double? _distance = Geolocator.distanceBetween(
              double?.parse(_branches[0].latitude), double?.parse(_branches[0].longitude),
                currentPostion.latitude,currentPostion.longitude ,
            ) / 1000;
            _isAvailable = _distance < _branches[0].coverage;
          }

          if(_isAvailable){
            index = '0' ;
            print('index ====================================== $index');
            Timer(Duration(seconds: 3), () async {
              if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                Provider.of<AuthProvider>(context, listen: false).updateToken();
                Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.set_lang, (route) => false, arguments: LanguageScreen(isFirst: false));
              } else {
                */ /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OnBoardingScreen(index: index,)),
                );*/ /*
                Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => OnBoardingScreen(index: index,)), (route) => false);
                //Navigator.pushNamedAndRemoveUntil(context, RouteHelper.onBoarding, (route) => false, arguments: OnBoardingScreen(index: index,));
              }
            });

          }else{
            index = '1' ;
            print('index ====================================== $index');
            Timer(Duration(seconds: 1), () async {
              if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                Provider.of<AuthProvider>(context, listen: false).updateToken();
                Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.set_lang, (route) => false, arguments: LanguageScreen(isFirst: false,));
              } else {
                Navigator.pushNamedAndRemoveUntil(context, RouteHelper.onBoarding, (route) => false, arguments: OnBoardingScreen(index: index,));
              }
            });
          }

        }
      }*/
      Timer(Duration(seconds: 3), () async {
        if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
          Provider.of<AuthProvider>(context, listen: false).updateToken();
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteHelper.set_lang, (route) => false,
              arguments: LanguageScreen(isFirst: false));
        } else {
          /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OnBoardingScreen(index: index,)),
                );*/
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => OnBoardingScreen(
                        index: index,
                      )),
              (route) => false);
          //Navigator.pushNamedAndRemoveUntil(context, RouteHelper.onBoarding, (route) => false, arguments: OnBoardingScreen(index: index,));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _globalKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            Images.splash_animation,
            height: 130,
          ),
          SizedBox(height: 10),
          Image.asset(Images.app_logo,
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Theme.of(context).primaryColor),
          SizedBox(height: 30),
          /*Text(AppConstants.APP_NAME,
              textAlign: TextAlign.center,
              style: poppinsMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 50,
              )),*/
        ],
      ),
    );
  }
}
