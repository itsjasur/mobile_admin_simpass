import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/code_value_model.dart';

class RetailerStatusUpdateContent extends StatefulWidget {
  final List<CodeValue> items;
  final String retailerCode;
  final Function? callBack;

  const RetailerStatusUpdateContent({super.key, required this.items, required this.retailerCode, this.callBack});

  @override
  State<RetailerStatusUpdateContent> createState() => _RetailerStatusUpdateContentState();
}

class _RetailerStatusUpdateContentState extends State<RetailerStatusUpdateContent> {
  String _selectedStatusCode = "";
  final _formKey = GlobalKey<FormState>();
  bool _updating = false;

  String? _statusErrorCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '상태 수정',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(20),
                    CustomDropDownMenu(
                      label: const Text("상태"),
                      enableSearch: true,
                      items: widget.items.where((i) => i.cd.isNotEmpty).map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                      errorText: _statusErrorCode,
                      selectedItem: _selectedStatusCode,
                      onSelected: (selectedItem) {
                        _selectedStatusCode = selectedItem;
                        _statusErrorCode = null;
                        setState(() {});
                      },
                    ),
                    const Gap(30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        runSpacing: 20,
                        spacing: 20,
                        children: [
                          Container(
                            height: 50,
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
                            height: 50,
                            constraints: const BoxConstraints(minWidth: 100),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {
                                _updateApplicationStatus();
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

  Future<void> _updateApplicationStatus() async {
    _updating = true;
    if (_selectedStatusCode.isEmpty) _statusErrorCode = "상태를 선택하세요.";

    setState(() {});

    if (_formKey.currentState!.validate() && _selectedStatusCode.isNotEmpty) {
      final APIService apiService = APIService();
      await apiService.updateRetailerStatus(
        context: context,
        requestModel: {
          "partner_cd": widget.retailerCode,
          "status": _selectedStatusCode,
        },
      );

      if (mounted) context.pop();

      if (widget.callBack != null) widget.callBack!();
    }

    _updating = false;
    setState(() {});
  }
}
