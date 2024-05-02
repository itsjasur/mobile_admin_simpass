import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class PaginationDropDown extends StatefulWidget {
  final List items;
  final Function(dynamic)? onSelected;
  final double? width;

  const PaginationDropDown({super.key, this.onSelected, required this.items, this.width});

  @override
  State<PaginationDropDown> createState() => _PaginationDropDownState();
}

class _PaginationDropDownState extends State<PaginationDropDown> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;

  final MenuController _menuController = MenuController();

  final GlobalKey _key = GlobalKey(); // Global key for the widget we want to measure
  double _dynamicWidth = 200; // Default width

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      onClose: () {
        if (mounted) {
          _isMenuOpen = false;
          setState(() {});
        }
      },
      onOpen: () {
        if (mounted) {
          _isMenuOpen = true;
          setState(() {});
        }
      },
      controller: _menuController,
      style: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
      ),
      menuChildren: List.generate(
        widget.items.length,
        (index) => InkWell(
          onTap: () {
            _selectedIndex = index;
            _toggleMenu();

            if (widget.onSelected != null) {
              widget.onSelected!(index);
            }

            setState(() {});
          },
          child: Container(
            width: widget.width ?? _dynamicWidth,
            color: _selectedIndex == index ? Colors.grey.shade200 : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(widget.items[index].toString()),
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onHover: (value) {},

        borderRadius: BorderRadius.circular(5),
        onTap: () {
          final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
          _dynamicWidth = renderBox.size.width;

          _toggleMenu();
          setState(() {});
        },

        // width of this padding widget should decice width of sizedbox above
        child: Container(
          key: _key,
          decoration: BoxDecoration(
            border: Border.all(color: MainUi.mainColor),
            borderRadius: BorderRadius.circular(3),
          ),
          width: widget.width,
          padding: const EdgeInsets.only(right: 0, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //text should be flexible if default width is not given
              widget.width != null
                  ? Flexible(
                      child: Text(
                        widget.items[_selectedIndex].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  : Text(widget.items[_selectedIndex].toString()),
              const SizedBox(width: 5),
              Icon(
                _isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }
}
