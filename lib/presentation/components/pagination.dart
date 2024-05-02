import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/hoverable_icon_button.dart';
import 'package:admin_simpass/presentation/components/pagination_drop_down.dart';
import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final Function(int currentPage, int perPage)? onUpdated;

  final int totalCount;

  const Pagination({super.key, required this.totalCount, this.onUpdated});

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  int _selectedIndex = 0;
  int _currentPage = 1;

  int _fromCount = 1;
  int _toCount = 1;

  int _avlPaginationCount = 0;
  List<Widget> _paginationNumbersWidgets = [];

  @override
  void initState() {
    _updateNumbers();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Pagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalCount != widget.totalCount) {
      _updateNumbers();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateNumbers() {
    _fromCount = (_currentPage * perPageCounts[_selectedIndex]) - perPageCounts[_selectedIndex] + 1;
    _toCount = (_currentPage * perPageCounts[_selectedIndex]);

    _avlPaginationCount = (widget.totalCount / perPageCounts[_selectedIndex]).ceil();

    if (_toCount > (widget.totalCount)) _toCount = (widget.totalCount);
    setState(() {});
  }

  void _updateCallBack() {
    if (widget.onUpdated != null) widget.onUpdated!(_currentPage, perPageCounts[_selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    _paginationNumbersWidgets = List.generate(
      _avlPaginationCount,
      (index) {
        Widget paginationCountWidget = InkWell(
          onTap: () {
            _currentPage = index + 1;
            _updateNumbers();
            _updateCallBack();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            child: Text((index + 1).toString()),
          ),
        );

        if (_currentPage - 1 == index) {
          paginationCountWidget = Container(
            decoration: BoxDecoration(
              border: Border.all(color: MainUi.mainColor),
              borderRadius: BorderRadius.circular(3),
            ),
            child: paginationCountWidget,
          );
        }
        return paginationCountWidget;
      },
    );
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children: [
        Text(
          '$_fromCount - $_toCount / ${widget.totalCount}',
          style: const TextStyle(color: Colors.black87),
        ),
        // const Gap(10),
        const Text(
          '페이지 당 행',
          style: TextStyle(color: Colors.black87),
        ),
        // const Gap(10),
        PaginationDropDown(
          width: 80,
          items: perPageCounts,
          onSelected: (selectedIndex) {
            _selectedIndex = selectedIndex;
            _currentPage = 1;

            _updateNumbers();
            _updateCallBack();
          },
        ),
        // const Gap(20),
        HoverAbleIconButton(
          icon: Icons.keyboard_double_arrow_left,
          onTap: () {
            _currentPage = 1;
            _updateNumbers();
            _updateCallBack();
          },
        ),
        HoverAbleIconButton(
          icon: Icons.chevron_left,
          onTap: () {
            if (_currentPage > 1) _currentPage--;
            _updateNumbers();
            _updateCallBack();
          },
        ),
        // const Gap(10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _avlPaginationCount,
            (index) {
              if (_currentPage <= 3) {
                if (index <= 4) return _paginationNumbersWidgets[index];
              } else if (_currentPage >= _avlPaginationCount - 3) {
                if (index >= _avlPaginationCount - 5) return _paginationNumbersWidgets[index];
              } else {
                if (index < _currentPage - 1 && index >= _currentPage - 3) {
                  return _paginationNumbersWidgets[index];
                }

                if (index == _currentPage - 1) return _paginationNumbersWidgets[index];

                if (index > _currentPage - 1 && index <= _currentPage + 1) {
                  return _paginationNumbersWidgets[index];
                }
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        // const Gap(10),
        HoverAbleIconButton(
          icon: Icons.chevron_right,
          onTap: () {
            if (_currentPage < _avlPaginationCount) _currentPage++;
            _updateNumbers();
            _updateCallBack();
          },
        ),
        HoverAbleIconButton(
          icon: Icons.keyboard_double_arrow_right,
          onTap: () {
            _currentPage = _avlPaginationCount;
            _updateNumbers();
            _updateCallBack();
          },
        ),
      ],
    );
  }
}
