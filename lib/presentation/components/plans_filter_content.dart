import 'package:admin_simpass/data/models/code_value_model.dart';
import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ManagePlansFilterContent extends StatefulWidget {
  final ManagePlansModel info;
  final ManagePlanSearchModel? requestModel;

  final Function(ManagePlanSearchModel)? onApply;
  const ManagePlansFilterContent({super.key, this.onApply, this.requestModel, required this.info});

  @override
  State<ManagePlansFilterContent> createState() => _ManagePlansFilterContentState();
}

class _ManagePlansFilterContentState extends State<ManagePlansFilterContent> {
  String _selectedCarrierCode = "";
  String _selectedMvnoCode = "";
  String _selectedAgentCode = "";
  String _selectedPlanTypeCode = "";
  String _selectedSubscriberTargetCode = "";
  String _selectedStatusCode = "";

  final List<CodeValue> _carriers = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _mvnos = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _agents = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _planTypes = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _subscriberTarget = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _statuses = [CodeValue(cd: '', value: '전체')];

  @override
  void initState() {
    super.initState();
    _carriers.addAll(widget.info.carrierCd);
    _mvnos.addAll(widget.info.mvnoCd);
    _agents.addAll(widget.info.agentCd);
    _planTypes.addAll(widget.info.carrierType);
    _subscriberTarget.addAll(widget.info.carrierPlanType);
    _statuses.addAll(widget.info.statusCd);

    if (widget.requestModel != null) {
      ManagePlanSearchModel model = widget.requestModel!;
      _selectedCarrierCode = model.carrierCd;
      _selectedMvnoCode = model.mvnoCd;
      _selectedAgentCode = model.agentCd;
      _selectedPlanTypeCode = model.carrierType;
      _selectedSubscriberTargetCode = model.carrierPlanType;
      _selectedStatusCode = model.status;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "데이터 필터링",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(20),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 15,
                runSpacing: 15,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("통신사"),
                        enableSearch: true,
                        items: _carriers.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                        onSelected: (selectedItem) {
                          _selectedCarrierCode = selectedItem;
                        },
                        width: constraints.maxWidth,
                        selectedItem: _selectedCarrierCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("브랜드"),
                        enableSearch: true,
                        onSelected: (selectedItem) {
                          _selectedMvnoCode = selectedItem;
                        },
                        items: _mvnos.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                        width: constraints.maxWidth,
                        selectedItem: _selectedMvnoCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("대리점"),
                        enableSearch: true,
                        onSelected: (selectedItem) {
                          _selectedAgentCode = selectedItem;
                        },
                        items: _agents.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                        width: constraints.maxWidth,
                        selectedItem: _selectedAgentCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("서비스 유형"),
                        enableSearch: true,
                        onSelected: (selectedItem) {
                          _selectedPlanTypeCode = selectedItem;
                        },
                        items: _planTypes.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                        width: constraints.maxWidth,
                        selectedItem: _selectedPlanTypeCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("가입대상"),
                        enableSearch: true,
                        onSelected: (selectedItem) {
                          _selectedSubscriberTargetCode = selectedItem;
                        },
                        items: _subscriberTarget.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                        width: constraints.maxWidth,
                        selectedItem: _selectedSubscriberTargetCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("상태"),
                        enableSearch: true,
                        onSelected: (selectedItem) {
                          _selectedStatusCode = selectedItem;
                        },
                        items: _statuses.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                        width: constraints.maxWidth,
                        selectedItem: _selectedStatusCode,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 15,
                runSpacing: 15,
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    height: 47,
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
                    constraints: const BoxConstraints(minWidth: 100),
                    height: 47,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {
                        if (widget.onApply != null) {
                          widget.onApply!(
                            ManagePlanSearchModel(
                              usimPlanNm: '',
                              carrierCd: "",
                              mvnoCd: "",
                              agentCd: "",
                              carrierPlanType: "",
                              carrierType: "",
                              status: "",
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
                  Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onApply != null) {
                          widget.onApply!(
                            ManagePlanSearchModel(
                              usimPlanNm: '',
                              carrierCd: _selectedCarrierCode,
                              mvnoCd: _selectedMvnoCode,
                              agentCd: _selectedAgentCode,
                              carrierPlanType: _selectedSubscriberTargetCode,
                              carrierType: _selectedPlanTypeCode,
                              status: _selectedStatusCode,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
