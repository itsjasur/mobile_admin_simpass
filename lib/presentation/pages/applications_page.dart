import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/globals/controller_handler.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/application_details_content.dart';
import 'package:admin_simpass/presentation/components/application_status_update_content.dart';
import 'package:admin_simpass/presentation/components/applications_filter_content.dart';
import 'package:admin_simpass/presentation/components/scroll_image_viewer.dart';
import 'package:admin_simpass/presentation/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => ApplicationsPageState();
}

class ApplicationsPageState extends State<ApplicationsPage> {
  final List<ApplicationModel> _infoList = [];

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
    return Scaffold(
      appBar: AppBar(title: const Text("신청서 접수현황")),
      drawer: const SideMenu(),
      body: _dataLoading
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
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
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
                    bool editable = true;
                    Color statusColor = Colors.grey;
                    if (_infoList[rowIndex].usimActStatus == 'A') statusColor = Colors.blue;
                    if (_infoList[rowIndex].usimActStatus == 'B') statusColor = Colors.green;
                    if (_infoList[rowIndex].usimActStatus == 'P') statusColor = Colors.green;
                    if (_infoList[rowIndex].usimActStatus == 'D') statusColor = Colors.red;
                    if (_infoList[rowIndex].usimActStatus == 'W') statusColor = Colors.orange;
                    if (_infoList[rowIndex].usimActStatus == 'C') statusColor = Colors.red;
                    if (_infoList[rowIndex].usimActStatus == 'Y') {
                      statusColor = Colors.grey;
                      editable = false;
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
                                "판매점영: ",
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
                                "상태: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              GestureDetector(
                                onTap: !editable
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ApplicationStatusUpdateContent(
                                            items: _statusesList,
                                            applicationID: _infoList[rowIndex].actNo ?? "",
                                          ),
                                        );
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.right,
                                        _infoList[rowIndex].usimActStatusNm ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (editable) const SizedBox(width: 5),
                                      if (editable)
                                        const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                    ],
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
                                "접수번호: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].num.toString(),
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
                                "고객명: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].name ?? "",
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
                                "후대펀: ",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "가입정보: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    foregroundColor: Colors.blueAccent,
                                    side: const BorderSide(color: Colors.blueAccent),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ApplicationDetailsContent(applicationId: _infoList[rowIndex].actNo ?? ""),
                                    );
                                  },
                                  child: const Text('가입정보'),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "가입신청서: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    foregroundColor: MainUi.mainColor,
                                    side: const BorderSide(color: MainUi.mainColor),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    showDialog(
                                      context: context,
                                      builder: (context) => ScrollFormImageViewer(applicationId: _infoList[rowIndex].actNo ?? ""),
                                    );
                                  },
                                  child: const Text('가입신청서'),
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
            ),
    );
  }

  Future<void> _fetchData() async {
    if (_currentPage == 1) _infoList.clear();
    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchApplications(
        context: context,
        requestModel: _requestModel.copyWith(
          page: _currentPage,
          rowLimit: 10,
        ),
      );

      _totalCount = result.totalNum;
      _infoList.addAll(result.applicationsList);
      _statusesList = result.usimActStatusCodes;
      _newDataLoading = false;

      _dataLoading = false;
      setState(() {});
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
