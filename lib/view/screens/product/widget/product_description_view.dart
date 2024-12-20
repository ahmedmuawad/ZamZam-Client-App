import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:url_launcher/url_launcher.dart';

class ProductDescription extends StatelessWidget {
  final String? productDescription;
  final String? id;
  ProductDescription({required this.productDescription, required this.id});

  @override
  Widget build(BuildContext context) {
    final String? _viewID = id;

    return Column(
      children: [
        productDescription!.isNotEmpty
            ? Center(
                child: Container(
                  width: 1170,
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Colors.white,
                  child: ResponsiveHelper.isWeb()
                      ? Column(
                          children: [
                            Expanded(
                                child: IgnorePointer(
                                    child: HtmlElementView(
                                        viewType: _viewID!, key: Key(id!)))),
                          ],
                        )
                      : Center(
                          child: SizedBox(
                            width: 1170,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: HtmlWidget(
                              productDescription!,
                              textStyle:
                                  poppinsRegular.copyWith(color: Colors.black),
                              onTapUrl: (String? url) {
                                return launch(url!);
                              },
                            ),
                          ),
                        ),
                ),
              )
            : Center(child: Text(getTranslated('no_description', context))),
      ],
    );
  }
}
