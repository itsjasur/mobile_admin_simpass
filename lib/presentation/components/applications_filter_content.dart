import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ApplicationsFilterContent extends StatefulWidget {
  final List<CodeValue>? statuses;
  final ApplicationsRequestModel? requestModel;
  final Function(ApplicationsRequestModel)? onApply;
  const ApplicationsFilterContent({super.key, this.onApply, this.requestModel, required this.statuses});

  @override
  State<ApplicationsFilterContent> createState() => _ApplicationsFilterContentState();
}

class _ApplicationsFilterContentState extends State<ApplicationsFilterContent> {
  String _selectedSearchType = applicationsSearchTypeList[2]['code'];

  String _selectedStatusCode = "";
  final List<CodeValue> _statusesList = [CodeValue(cd: '', value: '전체')];

  final TextEditingController _fromDateCntr = TextEditingController(text: CustomFormat().formatDate(DateTime.now().subtract(const Duration(days: 30)).toString()));
  final TextEditingController _toDateCntr = TextEditingController(text: CustomFormat().formatDate(DateTime.now().toString()));

  @override
  void initState() {
    super.initState();

    if (widget.statuses != null) {
      _statusesList.addAll(widget.statuses!);
    }

    if (widget.requestModel != null) {
      ApplicationsRequestModel model = widget.requestModel!;

      if (model.usimActStatus.isNotEmpty) {
        _selectedSearchType = "status";
        _selectedStatusCode = model.usimActStatus;
      }
      if (model.applyFrDate.isNotEmpty || model.applyToDate.isNotEmpty) {
        _selectedSearchType = "applyDate";
        _fromDateCntr.text = model.applyFrDate;
        _toDateCntr.text = model.applyToDate;
      }

      if (model.actToDate.isNotEmpty || model.actFrDate.isNotEmpty) {
        _selectedSearchType = "regisDate";
        _fromDateCntr.text = model.actFrDate;
        _toDateCntr.text = model.actToDate;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  const Text(
                    "데이터 필터링",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(30),
                  CustomDropDownMenu(
                    label: const Text("검색 선택"),
                    enableSearch: true,
                    items: applicationsSearchTypeList.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList(),
                    onSelected: (selectedItem) {
                      _selectedSearchType = selectedItem;
                      if (selectedItem == "status") {
                        _fromDateCntr.text = "";
                        _toDateCntr.text = "";
                      } else {
                        _selectedStatusCode = "";
                      }
                      setState(() {});
                    },
                    selectedItem: _selectedSearchType,
                  ),
                  if (_selectedSearchType == 'applyDate' || _selectedSearchType == 'regisDate')
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomTextInput(
                        title: _selectedSearchType == 'applyDate' ? '접수일자 (From)' : "개통일자 (From)",
                        controller: _fromDateCntr,
                        maxlength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                          DateFormatter(),
                        ],
                        validator: InputValidator().validateDate,
                      ),
                    ),
                  if (_selectedSearchType == 'applyDate' || _selectedSearchType == 'regisDate')
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomTextInput(
                        title: _selectedSearchType == 'applyDate' ? '접수일자 (To)' : "개통일자 (To)",
                        controller: _toDateCntr,
                        maxlength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                          DateFormatter(),
                        ],
                        validator: InputValidator().validateDate,
                      ),
                    ),
                  const Gap(30),
                  if (_selectedSearchType == 'status')
                    CustomDropDownMenu(
                      enableSearch: true,
                      label: const Text("상태"),
                      items: _statusesList.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                      selectedItem: _selectedStatusCode,
                      onSelected: (selectedItem) {
                        _selectedStatusCode = selectedItem;
                      },
                    ),
                  const Gap(30),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 100),
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {
                              if (widget.onApply != null) {
                                widget.onApply!(
                                  ApplicationsRequestModel(
                                    usimActStatus: "",
                                    applyFrDate: "",
                                    applyToDate: "",
                                    actFrDate: "",
                                    actToDate: "",
                                    page: 1,
                                    rowLimit: 10,
                                  ),
                                );
                              }

                              context.pop();
                            },
                            child: const Text("초기화"),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 100),
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.onApply != null) {
                                widget.onApply!(
                                  ApplicationsRequestModel(
                                    actNo: "",
                                    partnerCd: "",
                                    usimActStatus: _selectedStatusCode,
                                    applyFrDate: _selectedSearchType == 'applyDate' ? _fromDateCntr.text : "",
                                    applyToDate: _selectedSearchType == 'applyDate' ? _toDateCntr.text : "",
                                    actFrDate: _selectedSearchType == 'regisDate' ? _fromDateCntr.text : "",
                                    actToDate: _selectedSearchType == 'regisDate' ? _toDateCntr.text : "",
                                    page: 1,
                                    rowLimit: 10,
                                  ),
                                );
                              }

                              context.pop();
                            },
                            child: const Text("검색"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              hoverColor: Colors.white54,
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                context.pop();
              },
              onHover: (value) {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
