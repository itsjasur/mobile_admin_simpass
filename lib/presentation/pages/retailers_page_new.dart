import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/data/models/retailers_model.dart';
import 'package:admin_simpass/globals/controller_handler.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/applications_filter_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RetailersPageNew extends StatefulWidget {
  const RetailersPageNew({super.key});

  @override
  State<RetailersPageNew> createState() => RetailersPageNewState();
}

class RetailersPageNewState extends State<RetailersPageNew> {
  final List<RetailerModel> _infoList = [];

  int _totalCount = 0;
  int _currentPage = 1;
  bool _dataLoading = true;
  bool _newDataLoading = false;

  final ScrollController _scrollController = ScrollController();

  int? _filterBadgeNumber;

  ApplicationsRequestModel _requestModel = ApplicationsRequestModel(
    applyFrDate: "",
    actFrDate: "",
    actNo: "",
    actToDate: "",
    applyToDate: "",
    partnerCd: "",
    usimActStatus: "",
    page: 1,
    rowLimit: 10,
  );

  List<CodeValue> _statusesList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() async {
      if (_scrollController.hasClients && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (_infoList.length < _totalCount && !_newDataLoading) {
          _currentPage++;
          _newDataLoading = true;
          setState(() {});
          await _fetchData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _dataLoading
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: _infoList.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "총 사용자: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _totalCount.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Badge(
                            alignment: Alignment.topLeft,
                            isLabelVisible: _filterBadgeNumber != null,
                            label: Text(_filterBadgeNumber.toString()),
                            textStyle: const TextStyle(fontSize: 12),
                            backgroundColor: Colors.redAccent,
                            child: SizedBox(
                              height: 30,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: MainUi.mainColor,
                                  side: const BorderSide(color: MainUi.mainColor),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) => ApplicationsFilterContent(
                                      statuses: _statusesList,
                                      requestModel: _requestModel,
                                      onApply: (requestModel) async {
                                        setState(() {
                                          _infoList.clear();
                                          _currentPage = 1;
                                          _requestModel = requestModel;
                                          _filterBadgeNumber = _requestModel.countNonEmptyFields();
                                        });

                                        await Future.delayed(Duration.zero);
                                        await _fetchData();
                                      },
                                    ),
                                  );
                                },
                                child: const Text('필터'),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  if (index == _infoList.length + 1) {
                    return _newDataLoading
                        ? Align(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 50),
                              height: 30,
                              width: 30,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }

                  // cards
                  int rowIndex = index - 1;
                  bool editable = false;

                  Color statusColor = Colors.grey;
                  if (_infoList[rowIndex].status == 'Y') statusColor = Colors.green;
                  if (_infoList[rowIndex].status == 'N') statusColor = Colors.grey;

                  if (_infoList[rowIndex].status == 'W') {
                    statusColor = Colors.orange;
                    editable = true;
                  }

                  return Container(
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "상태: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                textAlign: TextAlign.right,
                                _infoList[rowIndex].statusNm ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "만매점명: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.right,
                                _infoList[rowIndex].partnerNm ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "대표자명: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.right,
                                _infoList[rowIndex].contractor ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "연락처: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.right,
                                _infoList[rowIndex].phoneNumber ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "연락처: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "가입신청서: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "접수일자: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.right,
                                _infoList[rowIndex].applyDate ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  children: [
                    InkWell(
                      hoverColor: Colors.white54,
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        // context.pop();
                        scrollToBegin(_scrollController);
                      },
                      onHover: (value) {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black38,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Gap(10),
                    InkWell(
                      hoverColor: Colors.white54,
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        scrollToEnd(_scrollController);
                      },
                      onHover: (value) {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black38,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Future<void> _fetchData() async {
    if (_currentPage == 1) _infoList.clear();
    try {
      final APIService apiService = APIService();

      var result = await apiService.fetchRetailers(
        context: context,
        requestModel: {
          "partner_nm": "",
          "status": "",
          "currentPage": _currentPage,
          "rowLimit": 10,
        },
      );

      _totalCount = result.totalNum ?? 0;
      _infoList.addAll(result.partnerList);
      _statusesList = result.statusList;
      _newDataLoading = false;

      _dataLoading = false;
      setState(() {});
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
