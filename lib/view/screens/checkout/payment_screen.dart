import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool fromCheckout;
  PaymentScreen({required this.orderModel, required this.fromCheckout});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedUrl;
  double? value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    selectedUrl =
        '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    controller!
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            _controller.future.then((value) => controller = value);
            
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(selectedUrl!));

    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      controller!.setBackgroundColor(const Color(0x80000000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(
            title: getTranslated('PAYMENT', context),
            onBackPressed: () => _exitApp(context)),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller!,
              // javascriptMode: JavascriptMode.unrestricted,
              // initialUrl: selectedUrl,
              // userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
              // gestureNavigationEnabled: true,
              // onWebViewCreated: (WebViewController webViewController) {
              //   _controller.future.then((value) => controllerGlobal = value);
              //   _controller.complete(webViewController);
              // },
              // onPageStarted: (String? url) {
              //   print('Page started loading: $url');
              //   setState(() {
              //     _isLoading = true;
              //   });
              //   bool _isSuccess = url!.contains('success') && url.contains(AppConstants.BASE_URL);
              //   bool _isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
              //   bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
              //   if(_isSuccess){
              //     Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}${widget.orderModel.id}/payment-success');
              //   }else if(_isFailed) {
              //     Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}${widget.orderModel.id}/payment-fail');
              //   }else if(_isCancel) {
              //     Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}${widget.orderModel.id}/payment-cancel');
              //   }
              // },

              // onPageFinished: (String? url) {
              //   print('Page finished loading: $url');
              //   setState(() {
              //     _isLoading = false;
              //   });
              // },
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controller!.canGoBack()) {
      controller!.goBack();
      return Future.value(false);
    } else {
      return showDialog<bool>(
        context: context,
        builder: (_) => CancelDialog(
            orderModel: widget.orderModel, fromCheckout: widget.fromCheckout),
      ).then((value) => value ?? false);
    }
  }
}
