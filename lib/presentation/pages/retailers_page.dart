import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/data/models/retailers_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/presentation/components/custom_alert_dialog.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/pagination.dart';
import 'package:admin_simpass/presentation/components/retailer_details_content.dart';
import 'package:admin_simpass/presentation/components/retailerer_status_update_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RetailersPage extends StatefulWidget {
  const RetailersPage({super.key});

  @override
  State<RetailersPage> createState() => _RetailersPageState();
}

class _RetailersPageState extends State<RetailersPage> {
  bool _dataLoading = true;

  final List _columns = retailersColumns;

  int _totalCount = 0;
  int _currentPage = 1;
  int _perPage = perPageCounts[0];

  final TextEditingController _retailerNameContr = TextEditingController();
  final ScrollController _horizontalScrolCntr = ScrollController();

  String _selectedStatusCode = "";
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<PartnerModel> _retailersList = [];
  final List<CodeValue> _statusesList = [];

  @override
  void initState() {
    super.initState();
    _fetchRetailers();
  }

  @override
  void dispose() {
    _retailerNameContr.dispose();
    _horizontalScrolCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _dataLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SelectionArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(title: "판매점 계약현황"),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) => CustomTextInput(
                            title: "판매점명",
                            controller: _retailerNameContr,
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) => CustomDropDownMenu(
                            label: const Text("상태"),
                            enableSearch: true,
                            width: constraints.maxWidth,
                            items: _statusesList.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                            selectedItem: _selectedStatusCode,
                            onSelected: (selectedItem) {
                              _selectedStatusCode = selectedItem;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 120),
                        height: 47,
                        child: ElevatedButton(
                          onPressed: () {
                            _fetchRetailers();
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_outlined,
                                color: Colors.white,
                                size: 17,
                              ),
                              SizedBox(width: 5),
                              Text("검색"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Pagination(
                    totalCount: _totalCount,
                    onUpdated: (currentPage, perPage) async {
                      if (currentPage != _currentPage || perPage != _perPage) {
                        _currentPage = currentPage;
                        _perPage = perPage;
                        _fetchRetailers();
                      }
                    },
                  ),
                ),
                const Gap(5),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Scrollbar(
                      controller: _horizontalScrolCntr,
                      scrollbarOrientation: ScrollbarOrientation.top,
                      child: SingleChildScrollView(
                        controller: _horizontalScrolCntr,
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 50,
                            ),
                            child: DataTable(
                              sortColumnIndex: _sortColumnIndex,
                              sortAscending: _sortAscending,
                              showCheckboxColumn: false,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              border: TableBorder.all(
                                color: Colors.transparent, // Make border color transparent
                                width: 0,
                              ),
                              headingRowHeight: 50,
                              columnSpacing: 40,
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              columns: List.generate(
                                _columns.length,
                                (index) {
                                  return DataColumn(
                                    onSort: (columnIndex, ascending) {
                                      _sortAscending = ascending;
                                      _sortColumnIndex = columnIndex;

                                      void mysort<T>(Comparable<T> Function(PartnerModel model) getField) {
                                        _retailersList.sort((a, b) {
                                          final aValue = getField(a);
                                          final bValue = getField(b);

                                          return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
                                        });
                                      }

                                      // sorting table on tap on header
                                      if (columnIndex == 0) mysort((model) => model.num ?? 0);
                                      if (columnIndex == 1) mysort((model) => model.statusNm?.toLowerCase() ?? "");
                                      if (columnIndex == 2) mysort((model) => model.partnerNm?.toLowerCase() ?? "");
                                      if (columnIndex == 3) mysort((model) => model.contractor?.toLowerCase() ?? "");
                                      if (columnIndex == 4) mysort((model) => model.phoneNumber?.toLowerCase() ?? "");
                                      if (columnIndex == 5) mysort((model) => model.businessNum?.toLowerCase() ?? "");
                                      if (columnIndex == 6) mysort((model) => model.applyDate ?? "");
                                      if (columnIndex == 7) mysort((model) => model.contractDate ?? "");

                                      setState(() {});
                                    },
                                    label: Text(_columns[index]),
                                  );
                                },
                              ),
                              rows: List.generate(
                                _retailersList.length,
                                (rowIndex) => DataRow(
                                  // onSelectChanged: (value) {},

                                  cells: List.generate(
                                    _columns.length,
                                    (columnIndex) {
                                      if (columnIndex == 0) {
                                        return DataCell(
                                          Text(_retailersList[rowIndex].num.toString()),
                                          onTap: () async {},
                                        );
                                      }

                                      if (columnIndex == 1) {
                                        bool editable = false;

                                        Color containerColor = Colors.grey;
                                        if (_retailersList[rowIndex].status == 'Y') containerColor = Colors.green;
                                        if (_retailersList[rowIndex].status == 'N') containerColor = Colors.grey;

                                        if (_retailersList[rowIndex].status == 'W') {
                                          containerColor = Colors.orange;
                                          editable = true;
                                        }

                                        return DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
                                            decoration: BoxDecoration(
                                              color: containerColor,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  _retailersList[rowIndex].statusNm ?? "",
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                if (editable)
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 3),
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            if (editable) {
                                              showCustomDialog(
                                                context: context,
                                                content: RetailerStatusUpdateContent(
                                                  selectedItem: _retailersList[rowIndex].status ?? "",
                                                  items: _statusesList.where((i) => i.cd.isNotEmpty).map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                                                  reetailerCd: _retailersList[rowIndex].partnerCd ?? "",
                                                  callBack: _fetchRetailers,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }

                                      if (columnIndex == 2) {
                                        return DataCell(
                                          Container(
                                            constraints: const BoxConstraints(maxWidth: 150),
                                            child: Text(
                                              _retailersList[rowIndex].partnerNm ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 3) {
                                        return DataCell(
                                          Text(_retailersList[rowIndex].contractor ?? ""),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 4) {
                                        return DataCell(
                                          Container(
                                            constraints: const BoxConstraints(maxWidth: 250),
                                            child: Text(
                                              _retailersList[rowIndex].phoneNumber ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 5) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_retailersList[rowIndex].businessNum ?? ""),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 6) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(CustomFormat().formatDateTime(_retailersList[rowIndex].applyDate) ?? ""),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 7) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(CustomFormat().formatDateTime(_retailersList[rowIndex].contractDate) ?? ""),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 8) {
                                        return DataCell(
                                          placeholder: false,
                                          OutlinedButton(
                                            onPressed: () {
                                              showCustomDialog(
                                                context: context,
                                                content: RetailerDetailsContent(
                                                  id: _retailersList[rowIndex].partnerCd ?? "",
                                                ),
                                              );
                                            },
                                            child: const Text('가입정보'),
                                          ),
                                          onTap: () {},
                                        );
                                      }

                                      return DataCell(onTap: () {}, const SizedBox());
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> _fetchRetailers() async {
    try {
      final APIService apiService = APIService();

      var result = await apiService.fetchRetailers(
        context: context,
        requestModel: {
          "partner_nm": _retailerNameContr.text,
          "status": _selectedStatusCode,
          "currentPage": _currentPage,
          "rowLimit": _perPage,
        },
      );

      _totalCount = result.totalNum ?? 0;

      _statusesList.clear();
      _statusesList.add(CodeValue(cd: "", value: '전체'));
      _statusesList.addAll(result.statusList);

      _retailersList = result.partnerList;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _dataLoading = false;
    setState(() {});
  }
}
