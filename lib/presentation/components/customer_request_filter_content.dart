import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/data/models/customer_requests_model.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CustomerRequestFilterContent extends StatefulWidget {
  final List<CodeValue>? statuses;
  final List<CodeValue>? countries;
  final CustomerRequestFetchModel? requestModel;
  final Function(CustomerRequestFetchModel)? onApply;

  const CustomerRequestFilterContent({super.key, this.onApply, this.requestModel, required this.statuses, this.countries});

  @override
  State<CustomerRequestFilterContent> createState() => _CustomerRequestFilterContentState();
}

class _CustomerRequestFilterContentState extends State<CustomerRequestFilterContent> {
  String _selectedStatusCode = "";
  String _selectedCountryCode = "";
  final List<CodeValue> _statusesList = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _countriesList = [CodeValue(cd: '', value: '전체')];
  final TextEditingController _nameCntr = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.statuses != null) {
      _statusesList.addAll(widget.statuses!);
    }

    if (widget.countries != null) {
      _countriesList.addAll(widget.countries!);
    }

    if (widget.requestModel != null) {
      _nameCntr.text = widget.requestModel!.name;
      _selectedStatusCode = widget.requestModel!.status;
      _selectedCountryCode = widget.requestModel!.countryCode;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameCntr.dispose();
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
                    enableSearch: true,
                    label: const Text("상태"),
                    items: _statusesList.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                    selectedItem: _selectedStatusCode,
                    onSelected: (selectedItem) {
                      _selectedStatusCode = selectedItem;
                    },
                  ),
                  const Gap(30),
                  CustomDropDownMenu(
                    enableSearch: true,
                    label: const Text("국가"),
                    items: _countriesList.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                    selectedItem: _selectedCountryCode,
                    onSelected: (selectedItem) {
                      _selectedCountryCode = selectedItem;
                    },
                  ),
                  const Gap(30),
                  CustomTextInput(
                    controller: _nameCntr,
                    title: '이름',
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
                                  CustomerRequestFetchModel(
                                    countryCode: "",
                                    name: "",
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
                                  CustomerRequestFetchModel(
                                    countryCode: _selectedCountryCode,
                                    name: _nameCntr.text,
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
