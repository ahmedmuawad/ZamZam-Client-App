import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/view/base/mars_menu_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/view/base/mars_menu_bar.dart' as item;

class MenuBar extends StatelessWidget {
  // final scaffoldKey;
  //
  // PlutoMenuBarDemo({
  //   this.scaffoldKey,
  // });

  // void message(context, String? text) {
  // //  scaffoldKey.currentState.hideCurrentSnackBar();
  //
  //   // final snackBar = SnackBar(
  //   //   content: Text(text),
  //   // );
  //   //
  //   // Scaffold.of(context).showSnackBar(snackBar);
  // }

  List<item.MenuItem> getMenus(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return [
      item.MenuItem(
          children: [],
          title: getTranslated('home', context),
          icon: Icons.home_filled,
          onTap: () => Navigator.pushNamed(context, RouteHelper.menu)
          //RouteHelper.router.navigateTo(context, Routes.DASHBOARD),
          ),
      item.MenuItem(
        title: getTranslated('all_categories', context),
        icon: Icons.category,
        onTap: () => Navigator.pushNamed(context, RouteHelper.categorys),
        children: [],
      ),
      /*    MenuItem(
        title: 'Settings',
        icon: Icons.settings,
        children: [
          MenuItem(
            title: getTranslated('privacy_policy', context),
           // onTap: () => RouteHelper.router.navigateTo(context, Routes.POLICY_SCREEN),
          ),
          MenuItem(
            title: getTranslated('terms_and_condition', context),
           // onTap: () => RouteHelper.router.navigateTo(context, Routes.TERMS_SCREEN),
          ),
          MenuItem(
            title: getTranslated('about_us', context),
           // onTap: () => RouteHelper.router.navigateTo(context, Routes.ABOUT_US_SCREEN),
          ),

        ],
      ),*/
      item.MenuItem(
        title: getTranslated('useful_links', context),
        icon: Icons.settings,
        children: [
          item.MenuItem(
            title: getTranslated('privacy_policy', context),
            icon: Icons.privacy_tip,
            onTap: () =>
                Navigator.pushNamed(context, RouteHelper.getPolicyRoute()),
            children: [],
          ),
          item.MenuItem(
            title: getTranslated('terms_and_condition', context),
            icon: Icons.description,
            onTap: () =>
                Navigator.pushNamed(context, RouteHelper.getTermsRoute()),
            children: [],
          ),
          item.MenuItem(
            title: getTranslated('about_us', context),
            icon: Icons.info,
            onTap: () =>
                Navigator.pushNamed(context, RouteHelper.getAboutUsRoute()),
            children: [],
          ),
        ],
        onTap: () {},
      ),
      /*  MenuItem(
        title: 'Favourite',
        icon: Icons.favorite_border,
        //onTap: () => RouteHelper.router.navigateTo(context, Routes.WISHLIST_SCREEN),
      ),*/

      item.MenuItem(
        title: getTranslated('search', context),
        icon: Icons.search,
        onTap: () => Navigator.pushNamed(context, RouteHelper.searchProduct),
        children: [],
      ),
      item.MenuItem(
        title: getTranslated('menu', context),
        icon: Icons.menu,
        onTap: () => Navigator.pushNamed(context, RouteHelper.profileMenus),
        children: [],
      ),
      _isLoggedIn
          ? item.MenuItem(
              title: getTranslated('profile', context),
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(context, RouteHelper.profile),
              children: [],
            )
          : item.MenuItem(
              title: getTranslated('login', context),
              icon: Icons.lock,
              onTap: () => Navigator.pushNamed(context, RouteHelper.login),
              children: [],
            ),
      item.MenuItem(
        title: '',
        icon: Icons.shopping_cart,
        onTap: () => Navigator.pushNamed(context, RouteHelper.cart),
        children: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      width: 800,
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).cardColor,
        gradient: false,
        goBackButtonText: 'Back',
        textStyle: TextStyle(
            color:
                Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black),
        moreIconColor:
            Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        menuIconColor:
            Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        menus: getMenus(context),
      ),
    );
  }
}
