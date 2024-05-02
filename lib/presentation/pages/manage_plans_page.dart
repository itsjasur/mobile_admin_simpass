import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/update_add_plan_content.dart';
import 'package:admin_simpass/presentation/components/custom_alert_dialog.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/plans_filter_content.dart';
import 'package:admin_simpass/presentation/components/pagination.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ManagePlansPage extends StatefulWidget {
  const ManagePlansPage({super.key});

  @override
  State<ManagePlansPage> createState() => _ManagePlansPageState();
}

class _ManagePlansPageState extends State<ManagePlansPage> {
  int _totalCount = 0;
  int _currentPage = 1;
  int _perPage = perPageCounts[0];
  bool _dataLoading = true;
  final List _columns = mangePlansColumns;
  final List<PlanModel> _plansList = [];
  late ManagePlansModel _plansInfo;

  ManagePlanSearchModel _requestModel = ManagePlanSearchModel(
    agentCd: '',
    carrierCd: '',
    carrierPlanType: '',
    carrierType: '',
    mvnoCd: '',
    status: '',
    usimPlanNm: '',
    page: 1,
    rowLimit: 10,
  );

  int? _filterBadgeNumber;

  final ScrollController _horizontalScrolCntr = ScrollController();
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    _fetchPlansData();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _horizontalScrolCntr.dispose();
    super.dispose();
  }

  int? _sortColumnIndex;
  bool _sortAscending = true;

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
                const Header(title: "요금제 관리"),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      /// ADD BUTTON
                      SizedBox(
                        height: 47,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            showCustomDialog(
                              content: AddOrUpdatePlanContent(
                                info: _plansInfo,
                                callback: _fetchPlansData,
                              ),
                              context: context,
                            );
                          },
                          child: const Text("신규등록 +"),
                        ),
                      ),
                      Badge(
                        alignment: Alignment.topLeft,
                        isLabelVisible: _filterBadgeNumber != null,
                        label: Text(_filterBadgeNumber.toString()),
                        textStyle: const TextStyle(fontSize: 14),
                        backgroundColor: Colors.redAccent,
                        child: SizedBox(
                          height: 47,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              showCustomDialog(
                                context: context,
                                content: ManagePlansFilterContent(
                                  info: _plansInfo,
                                  requestModel: _requestModel,
                                  onApply: (requestModel) async {
                                    setState(() {
                                      _requestModel = requestModel;
                                      _filterBadgeNumber = _requestModel.countNonEmptyFields();
                                    });

                                    await Future.delayed(Duration.zero);
                                    _fetchPlansData();
                                  },
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sort,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                SizedBox(width: 5),
                                Text("필터"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 300,
                        ),
                        child: CustomTextInput(
                          controller: _searchTextController,
                          title: '요금제명',
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 120),
                        height: 47,
                        child: ElevatedButton(
                          onPressed: () {
                            _fetchPlansData();
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
                // if (!_dataLoading)
                //   Scrollbar(
                //     controller: _horizontalScrolCntr,
                //     child: Container(
                //       color: Colors.amber.shade50,
                //       height: 20,
                //       width: 1500,
                //     ),
                //   ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Pagination(
                    totalCount: _totalCount,
                    onUpdated: (currentPage, perPage) async {
                      if (currentPage != _currentPage || perPage != _perPage) {
                        _currentPage = currentPage;
                        _perPage = perPage;
                        await _fetchPlansData();
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
                            margin: const EdgeInsets.only(top: 15, bottom: 50, left: 20, right: 20),
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 10,
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
                              dataRowMinHeight: 40,
                              columnSpacing: 40,
                              headingRowHeight: 50,
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

                                      void mysort<T>(Comparable<T> Function(PlanModel model) getField) {
                                        _plansList.sort((a, b) {
                                          final aValue = getField(a);
                                          final bValue = getField(b);

                                          return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
                                        });
                                      }

                                      // sorting table on tap on header
                                      if (columnIndex == 0) mysort((model) => model.id);
                                      if (columnIndex == 1) mysort((model) => model.status.toLowerCase());
                                      if (columnIndex == 2) mysort((model) => model.usimPlanNm.toLowerCase());
                                      if (columnIndex == 3) mysort((model) => model.carrierNm.toLowerCase());
                                      if (columnIndex == 4) mysort((model) => model.mvnoNm.toLowerCase());
                                      if (columnIndex == 5) mysort((model) => model.agentNm.toLowerCase());
                                      if (columnIndex == 6) mysort((model) => model.carrierTypeNm ?? "".toLowerCase());
                                      if (columnIndex == 7) mysort((model) => model.carrierPlanTypeNm ?? "".toLowerCase());
                                      if (columnIndex == 8) mysort((model) => model.basicFee);
                                      if (columnIndex == 9) mysort((model) => model.salesFee);
                                      if (columnIndex == 10) mysort((model) => model.message ?? "".toLowerCase());
                                      if (columnIndex == 12) mysort((model) => model.cellData ?? "".toLowerCase());
                                      if (columnIndex == 13) mysort((model) => model.videoEtc ?? "".toLowerCase());
                                      if (columnIndex == 14) mysort((model) => model.qos ?? "".toLowerCase());

                                      setState(() {});
                                    },
                                    label: Text(_columns[index]),
                                  );
                                },
                              ),
                              rows: List.generate(
                                _plansList.length,
                                (rowIndex) => DataRow(
                                  // onSelectChanged: (value) {},

                                  cells: List.generate(
                                    _columns.length,
                                    (columnIndex) {
                                      if (columnIndex == 0) {
                                        return DataCell(
                                          Text(_plansList[rowIndex].id.toString()),
                                          onTap: () async {},
                                        );
                                      }

                                      if (columnIndex == 1) {
                                        Color containerColor = Colors.black38;
                                        if (_plansList[rowIndex].status == 'Y') containerColor = Colors.green;
                                        if (_plansList[rowIndex].status == 'N') containerColor = Colors.redAccent;

                                        return DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
                                            decoration: BoxDecoration(
                                              color: containerColor,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              _plansList[rowIndex].statusNm ?? "",
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 2) {
                                        return DataCell(
                                          Text(_plansList[rowIndex].usimPlanNm),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 3) {
                                        return DataCell(
                                          Text(_plansList[rowIndex].carrierNm),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 4) {
                                        return DataCell(
                                          Text(_plansList[rowIndex].mvnoNm),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 5) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].agentNm),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 6) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].carrierTypeNm ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 7) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].carrierPlanTypeNm ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 8) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(CustomFormat().wonify(_plansList[rowIndex].basicFee)),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 9) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(CustomFormat().wonify(_plansList[rowIndex].salesFee)),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 10) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].voice ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 11) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].message ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 12) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].cellData ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 13) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].videoEtc ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 14) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_plansList[rowIndex].qos ?? "-"),
                                          onTap: () {},
                                        );
                                      }

                                      if (columnIndex == 15) {
                                        return DataCell(
                                          const Icon(Icons.edit_outlined, color: MainUi.mainColor),
                                          onTap: () {
                                            //updating plan
                                            showCustomDialog(
                                              content: AddOrUpdatePlanContent(
                                                info: _plansInfo,
                                                selectedPlan: _plansList[rowIndex],
                                                callback: _fetchPlansData,
                                              ),
                                              context: context,
                                            );
                                          },
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

  Future<void> _fetchPlansData() async {
    _plansList.clear();

    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchPlansInfo(
        context: context,
        requestModel: _requestModel.copyWith(
          rowLimit: _perPage,
          page: _currentPage,
          usimPlanNm: _searchTextController.text,
        ),
      );

      _plansList.addAll(result.planList);
      _plansInfo = result;
      _totalCount = result.totalNum;
      _dataLoading = false;

      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
