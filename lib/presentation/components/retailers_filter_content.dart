import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/data/models/retailers_model.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RetailersFilterContent extends StatefulWidget {
  final List<CodeValue>? statuses;
  final RetailersRequestModel? requestModel;
  final Function(RetailersRequestModel)? onApply;

  const RetailersFilterContent({super.key, this.onApply, this.requestModel, required this.statuses});

  @override
  State<RetailersFilterContent> createState() => _RetailersFilterContentState();
}

class _RetailersFilterContentState extends State<RetailersFilterContent> {
  String _selectedStatusCode = "";
  final List<CodeValue> _statusesList = [CodeValue(cd: '', value: '전체')];
  final TextEditingController _retailerNameCntr = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.statuses != null) {
      _statusesList.addAll(widget.statuses!);
    }

    if (widget.requestModel != null) {
      _retailerNameCntr.text = widget.requestModel!.partnerName;
      _selectedStatusCode = widget.requestModel!.status;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _retailerNameCntr.dispose();
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
                  CustomTextInput(
                    controller: _retailerNameCntr,
                    title: '판매점명',
                  ),
                  const Gap(30),
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
                                  RetailersRequestModel(
                                    partnerName: "",
                                    status: "",
                                    rowLimit: 10,
                                    currentPage: 1,
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
                                  RetailersRequestModel(
                                    partnerName: _retailerNameCntr.text,
                                    status: _selectedStatusCode,
                                    rowLimit: 10,
                                    currentPage: 1,
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
