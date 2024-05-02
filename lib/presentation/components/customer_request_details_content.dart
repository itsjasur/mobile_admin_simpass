import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/data/models/customer_requests_model.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CustomerRequestDetailsContent extends StatefulWidget {
  final int id;
  final List<CodeValue> statuses;
  final Function? callBack;
  const CustomerRequestDetailsContent({super.key, required this.id, required this.statuses, this.callBack});

  @override
  State<CustomerRequestDetailsContent> createState() => _CustomerRequestDetailsContentState();
}

class _CustomerRequestDetailsContentState extends State<CustomerRequestDetailsContent> {
  CustomerRequestModel? _details;
  bool _loading = true;
  String _selectedStatusCode = "";

  String? _statusErrorCode;

  bool _updating = false;

  bool _statusEditable = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomerRequestDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: _details == null
                  ? const Center(
                      child: Text('Data fetching error'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '요청 세부정보',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Gap(20),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 500),
                                child: CustomTextInput(
                                  title: '이름',
                                  initialValue: _details?.name ?? "",
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: CustomTextInput(
                                  title: '연락처',
                                  initialValue: _details?.contact ?? "",
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: CustomTextInput(
                                  title: '국가',
                                  initialValue: _details?.countryNm ?? "",
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 300),
                                child: CustomTextInput(
                                  title: '요금제',
                                  initialValue: _details?.planNm ?? "",
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: CustomTextInput(
                                  title: '요금제코드',
                                  initialValue: _details?.planId ?? "",
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: CustomTextInput(
                                  title: '가입구분명',
                                  initialValue: _details?.usimActNm,
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: CustomTextInput(
                                  title: '요청 날짜',
                                  initialValue: CustomFormat().formatDateTime(_details?.regTime) ?? "",
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: LayoutBuilder(
                                  builder: (context, constraints) => CustomDropDownMenu(
                                    label: const Text("상태"),
                                    enableSearch: true,
                                    items: widget.statuses.where((i) => i.cd.isNotEmpty).map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                                    width: constraints.maxWidth,
                                    enabled: _statusEditable,
                                    errorText: _statusErrorCode,
                                    selectedItem: _selectedStatusCode,
                                    onSelected: (selectedItem) {
                                      _selectedStatusCode = selectedItem;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(40),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              runSpacing: 20,
                              spacing: 20,
                              children: [
                                Container(
                                  height: 47,
                                  constraints: const BoxConstraints(minWidth: 100),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text("취소"),
                                  ),
                                ),
                                Container(
                                  height: 47,
                                  constraints: const BoxConstraints(minWidth: 100),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(),
                                    onPressed: () {
                                      _updateCustomerRequestStatus();
                                    },
                                    child: _updating ? const ButtonCircularProgressIndicator() : const Text("저장"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }

  Future<void> _fetchCustomerRequestDetails() async {
    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchCustomerRequestDetails(
        context: context,
        id: widget.id,
      );
      _details = result;
      _selectedStatusCode = _details?.status ?? "";
      setState(() {});

      if (_selectedStatusCode == 'A' || _selectedStatusCode == 'P' || _selectedStatusCode.isEmpty) _statusEditable = true;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _loading = false;
    setState(() {});
  }

  Future<void> _updateCustomerRequestStatus() async {
    _updating = true;
    if (_selectedStatusCode.isEmpty) _statusErrorCode = "상태를 선택하세요.";

    setState(() {});

    if (_selectedStatusCode.isNotEmpty) {
      final APIService apiService = APIService();
      bool result = await apiService.updateCustomerRequestStatus(
        context: context,
        requestModel: {
          "id": widget.id,
          "status": _selectedStatusCode,
        },
      );
      if (result) {
        if (mounted) context.pop();
        if (widget.callBack != null) widget.callBack!();
      }
    }

    _updating = false;
    setState(() {});
  }
}
