import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class PlutoMenuBar extends StatefulWidget {
  /// Pass [MenuItem] to List.
  /// create submenus by continuing to pass MenuItem to children as a List.
  ///
  /// ```dart
  /// MenuItem(
  ///   title: 'Menu 1',
  ///   children: [
  ///     MenuItem(
  ///       title: 'Menu 1-1',
  ///       onTap: () => print('Menu 1-1 tap'),
  ///     ),
  ///   ],
  /// ),
  /// ```
  final List<MenuItem> menus;

  /// Text of the back button. (default. 'Go back')
  final String? goBackButtonText;

  /// menu height. (default. '45')
  final double? height;

  /// BackgroundColor. (default. 'white')
  final Color backgroundColor;

  /// Border color. (default. 'black12')
  final Color borderColor;

  /// menu icon color. (default. 'black54')
  final Color menuIconColor;

  /// menu icon size. (default. '20')
  final double? menuIconSize;

  /// more icon color. (default. 'black54')
  final Color moreIconColor;

  /// Enable gradient of BackgroundColor. (default. 'true')
  final bool gradient;

  /// [TextStyle] of Menu title.
  final TextStyle textStyle;

  PlutoMenuBar({
    required this.menus,
    this.goBackButtonText = 'Go back',
    this.height = 45,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black12,
    this.menuIconColor = Colors.black54,
    this.menuIconSize = 20,
    this.moreIconColor = Colors.black54,
    this.gradient = true,
    this.textStyle = const TextStyle(),
  }) : assert(menus.length > 0);

  @override
  _PlutoMenuBarState createState() => _PlutoMenuBarState();
}

class _PlutoMenuBarState extends State<PlutoMenuBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) {
        return Container(
          width: size.minWidth,
          height: widget.height,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //   color: widget.backgroundColor,// widget.gradient ? null : widget.backgroundColor,
          //   // gradient: widget.gradient
          //   //     ? LinearGradient(
          //   //         begin: Alignment.topCenter,
          //   //         end: Alignment.bottomCenter,
          //   //         colors: [
          //   //           widget.backgroundColor,
          //   //           widget.backgroundColor.withOpacity(0.54),
          //   //         ],
          //   //         stops: [0.90, 1],
          //   //       )
          //   //     : null,
          //   // border: Border(
          //   //   top: BorderSide(color: widget.borderColor),
          //   //   bottom: BorderSide(color: widget.borderColor),
          //   // ),
          //   // boxShadow: [
          //   //   BoxShadow(
          //   //     color: Colors.grey.withOpacity(0.5),
          //   //     spreadRadius: 0,
          //   //     blurRadius: 0,
          //   //     offset: Offset(0, 0.5), // changes position of shadow
          //   //   ),
          //   // ],
          // ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.menus.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return _MenuWidget(
                widget.menus[index],
                goBackButtonText: widget.goBackButtonText,
                height: widget.height,
                backgroundColor: widget.backgroundColor,
                menuIconColor: widget.menuIconColor,
                menuIconSize: widget.menuIconSize,
                moreIconColor: widget.moreIconColor,
                textStyle: widget.textStyle,
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItem {
  /// Menu title
  final String? title;

  final IconData icon;

  /// Callback executed when a menu is tapped
  final Function() onTap;

  /// Passing [MenuItem] to a [List] creates a sub-menu.
  final List<MenuItem> children;

  MenuItem({
    this.title,
    required this.icon,
    required this.onTap,
    required this.children,
  }) : _key = GlobalKey();

  MenuItem._back(
    this.icon,
    this.onTap, {
    this.title,
    required this.children,
  })  : _key = GlobalKey(),
        _isBack = true;

  GlobalKey _key;

  bool _isBack = false;

  Offset get _position {
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;

    return box.localToGlobal(Offset.zero);
  }

  bool get _hasChildren => children.length > 0;
}

class _MenuWidget extends StatelessWidget {
  final MenuItem menu;

  final String? goBackButtonText;

  final double? height;

  final Color backgroundColor;

  final Color menuIconColor;

  final double? menuIconSize;

  final Color moreIconColor;

  final TextStyle textStyle;

  _MenuWidget(
    this.menu, {
    this.goBackButtonText,
    this.height,
    required this.backgroundColor,
    required this.menuIconColor,
    required this.menuIconSize,
    required this.moreIconColor,
    required this.textStyle,
  }) : super(key: menu._key);

  Widget _buildPopupItem(MenuItem _menu) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...[
          Icon(
            _menu.icon,
            color: menuIconColor,
            size: menuIconSize,
          ),
          SizedBox(
            width: 5,
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              _menu.title ?? '',
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        if (_menu._hasChildren && !_menu._isBack)
          Icon(
            Icons.arrow_right,
            color: moreIconColor,
          ),
      ],
    );
  }

  Future<MenuItem> _showPopupMenu(
    BuildContext context,
    List<MenuItem> menuItems,
  ) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position = menu._position + Offset(0, height! - 11);

    return await showMenu<MenuItem>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width,
        overlay.size.height,
      ),
      items: menuItems.map((menu) {
        return PopupMenuItem<MenuItem>(
          value: menu,
          child: _buildPopupItem(menu),
        );
      }).toList(),
      // elevation: 2.0,
      color: backgroundColor,
    ) ?? menuItems.first;
  }

  Widget _getMenu(
    BuildContext context,
    MenuItem menu,
  ) {
    Future<MenuItem> _getSelectedMenu(
      MenuItem menu, {
      MenuItem? previousMenu,
      int? stackIdx,
      List<MenuItem>? stack,
    }) async {
      if (!menu._hasChildren) {
        return menu;
      }

      final items = [...menu.children];

      items.add(MenuItem._back(
        Icons.arrow_back,
        () {},
        title: goBackButtonText,
        children: previousMenu!.children,
      ));

      MenuItem _selectedMenu = await _showPopupMenu(
        context,
        items,
      );

      MenuItem _previousMenu = menu;

      if (!_selectedMenu._hasChildren) {
        return _selectedMenu;
      }

      if (_selectedMenu._isBack) {
        if (stackIdx != null) {
          --stackIdx;
        }
        if (stackIdx! < 0) {
          _previousMenu = menu;
        } else {
          _previousMenu = stack![stackIdx];
        }
      } else {
        stackIdx = (stackIdx ?? 0) + 1;
        stack!.add(menu);
      }

      return await _getSelectedMenu(
        _selectedMenu,
        previousMenu: _previousMenu,
        stackIdx: stackIdx,
        stack: stack,
      );
    }

    return InkWell(
      onTap: () async {
        if (menu._hasChildren) {
          MenuItem selectedMenu = await _getSelectedMenu(menu);

          selectedMenu.onTap();
        } else
          menu.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    menu.icon,
                    size: menuIconSize,
                    color: menuIconColor,
                  ),
                  menu.title!.isEmpty
                      ? Positioned(
                          top: -7,
                          right: -7,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: Center(
                              child: Text(
                                  Provider.of<CartProvider>(context)
                                      .cartList
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          8) //rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: 8),
                                  ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              // menu.icon,
              // color: menuIconColor,
              // size: menuIconSize,

              SizedBox(
                width: 5,
              ),
            ],
            Text(
              menu.title!,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getMenu(context, menu);
  }
}
