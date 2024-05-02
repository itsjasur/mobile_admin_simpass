import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddOrUpdatePlanContent extends StatefulWidget {
  final ManagePlansModel info;
  final PlanModel? selectedPlan;
  final Function() callback;
  const AddOrUpdatePlanContent({super.key, required this.info, this.selectedPlan, required this.callback});

  @override
  State<AddOrUpdatePlanContent> createState() => _AddOrUpdatePlanContentState();
}

class _AddOrUpdatePlanContentState extends State<AddOrUpdatePlanContent> {
  String _selectedCarrierCode = "";
  String _selectedMvnoCode = "";
  String _selectedAgentCode = "";
  String _selectedPlanTypeCode = "";
  String _selectedSubscriberTargetCode = "";
  String _selectedStatusCode = "";

  String? _selectedCarrierCodeErr;
  String? _selectedMvnoCodeErr;
  String? _selectedAgentCodeErr;
  String? _selectedPlanTypeCodeErr;
  String? _selectedSubscriberTargetCodeErr;
  String? _selectedStatusCodeErr;

  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _baseAmountController = TextEditingController();
  final TextEditingController _saleAmountController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _voiceController = TextEditingController();
  final TextEditingController _videoEtcController = TextEditingController();
  final TextEditingController _qosController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  List<DropdownMenuEntry> _carriers = [];
  List<DropdownMenuEntry> _mvnos = [];
  List<DropdownMenuEntry> _agents = [];
  List<DropdownMenuEntry> _planTypes = [];
  List<DropdownMenuEntry> _subscriberTarget = [];
  List<DropdownMenuEntry> _statuses = [];

  final _formKey = GlobalKey<FormState>();

  bool _dataUpdating = false;

  @override
  void initState() {
    super.initState();

    _carriers = widget.info.carrierCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _mvnos = widget.info.mvnoCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _agents = widget.info.agentCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _planTypes = widget.info.carrierType.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _subscriberTarget = widget.info.carrierPlanType.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _statuses = widget.info.statusCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();

    if (widget.selectedPlan != null) {
      PlanModel model = widget.selectedPlan!;

      _selectedCarrierCode = model.carrierCd;
      _selectedMvnoCode = model.mvnoCd;
      _selectedAgentCode = model.agentCd;
      _selectedPlanTypeCode = model.carrierType;
      _selectedSubscriberTargetCode = model.carrierPlanType;
      _selectedStatusCode = model.status;

      // print(model.status);

      _planNameController.text = model.usimPlanNm;
      _baseAmountController.text = CustomFormat().commafy(model.basicFee);
      _saleAmountController.text = CustomFormat().commafy(model.salesFee).toString();
      _smsController.text = model.message ?? "";
      _dataController.text = model.cellData ?? "";
      _voiceController.text = model.voice ?? "";
      _videoEtcController.text = model.videoEtc ?? "";
      _qosController.text = model.qos ?? "";
      _priorityController.text = CustomFormat().commafy(model.priority);
    }
  }

  @override
  void dispose() {
    _planNameController.dispose();
    _baseAmountController.dispose();
    _saleAmountController.dispose();
    _smsController.dispose();
    _dataController.dispose();
    _voiceController.dispose();
    _videoEtcController.dispose();
    _qosController.dispose();
    _priorityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Text(
                  widget.selectedPlan == null ? "신규 요금제 등록" : "요금제 업테이트",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(30),
                Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) => CustomDropDownMenu(
                          label: const Text("통신사"),
                          enableSearch: true,
                          enabled: widget.selectedPlan == null,
                          errorText: _selectedCarrierCodeErr,
                          items: _carriers,
                          onSelected: (selectedItem) {
                            _selectedCarrierCode = selectedItem;
                            _selectedCarrierCodeErr = null;

                            setState(() {});
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
                          enableSearch: true,
                          label: const Text("브랜드"),
                          errorText: _selectedMvnoCodeErr,
                          onSelected: (selectedItem) {
                            _selectedMvnoCodeErr = null;
                            _selectedMvnoCode = selectedItem;

                            if (mounted) setState(() {});
                          },
                          items: _mvnos,
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
                          errorText: _selectedAgentCodeErr,
                          enableSearch: true,
                          label: const Text("대리점"),
                          onSelected: (selectedItem) {
                            _selectedAgentCodeErr = null;
                            _selectedAgentCode = selectedItem;
                            setState(() {});
                          },
                          items: _agents,
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
                          errorText: _selectedPlanTypeCodeErr,
                          label: const Text("서비스 유형"),
                          enableSearch: true,
                          onSelected: (selectedItem) {
                            _selectedPlanTypeCodeErr = null;
                            _selectedPlanTypeCode = selectedItem;
                            setState(() {});
                          },
                          items: _planTypes,
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
                          label: const Text("요금제 가입구분"),
                          enableSearch: true,
                          errorText: _selectedSubscriberTargetCodeErr,
                          onSelected: (selectedItem) {
                            _selectedSubscriberTargetCodeErr = null;
                            _selectedSubscriberTargetCode = selectedItem;
                            setState(() {});
                          },
                          items: _subscriberTarget,
                          width: constraints.maxWidth,
                          selectedItem: _selectedSubscriberTargetCode,
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: CustomTextInput(
                        controller: _planNameController,
                        enabled: widget.selectedPlan == null,
                        title: '요금제명',
                        validator: (value) => InputValidator().validateForNoneEmpty(value, '요금제명'),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) => CustomDropDownMenu(
                          errorText: _selectedStatusCodeErr,
                          label: const Text("상태"),
                          enableSearch: true,
                          onSelected: (selectedItem) {
                            _selectedStatusCode = selectedItem;
                            _selectedStatusCodeErr = null;
                            setState(() {});
                          },
                          items: _statuses,
                          width: constraints.maxWidth,
                          selectedItem: _selectedStatusCode,
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _baseAmountController,
                        title: '기본료',
                        validator: (value) => InputValidator().validateForNoneEmpty(value, '기본료'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _saleAmountController,
                        title: '판매금액',
                        validator: (value) => InputValidator().validateForNoneEmpty(value, '판매금액'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _smsController,
                        title: '문자',
                        validator: (value) => InputValidator().validateForNoneEmpty(value, '문자'),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _dataController,
                        title: '데이터',
                        validator: (value) => InputValidator().validateForNoneEmpty(value, '데이터'),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _voiceController,
                        title: '음성',
                        validator: (value) => InputValidator().validateForNoneEmpty(value, '음성'),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _videoEtcController,
                        title: '영상/기타',
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _qosController,
                        title: 'QOS',
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      child: CustomTextInput(
                        controller: _priorityController,
                        title: '우선순위',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
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
                          onPressed: _dataUpdating
                              ? null
                              : () {
                                  _updateOrAddPlan();
                                },
                          child: _dataUpdating ? const ButtonCircularProgressIndicator() : const Text("저장"),
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
    );
  }

  bool _checkDropDownValues() {
    _selectedCarrierCodeErr = _selectedCarrierCode.isEmpty ? "통신사 선택하세요." : null;
    _selectedMvnoCodeErr = _selectedMvnoCode.isEmpty ? "브랜드 선택하세요." : null;
    _selectedAgentCodeErr = _selectedAgentCode.isEmpty ? "대리점 선택하세요." : null;
    _selectedPlanTypeCodeErr = _selectedPlanTypeCode.isEmpty ? "서비스 유형 선택하세요." : null;
    _selectedSubscriberTargetCodeErr = _selectedSubscriberTargetCode.isEmpty ? "요금제 가입구분 선택하세요." : null;
    _selectedStatusCodeErr = _selectedStatusCode.isEmpty ? "상태 입력하세요." : null;

    List errs = [
      _selectedCarrierCodeErr,
      _selectedMvnoCodeErr,
      _selectedAgentCodeErr,
      _selectedPlanTypeCodeErr,
      _selectedSubscriberTargetCodeErr,
      _selectedStatusCodeErr,
    ];

    return errs.every((err) => err == null);
  }

  Future<void> _updateOrAddPlan() async {
    _dataUpdating = true;
    setState(() {});

    bool errs = _checkDropDownValues();
    bool form = _formKey.currentState!.validate();

    if (errs && form) {
      final APIService apiService = APIService();
      bool result = await apiService.updateOrAddPlan(
          context: context,
          requestModel: PlanAddUpdateModel(
            id: widget.selectedPlan?.id,
            usimPlanNm: _planNameController.text,
            carrierCd: _selectedCarrierCode,
            mvnoCd: _selectedMvnoCode,
            agentCd: _selectedAgentCode,
            basicFee: CustomFormat().deCommafy(_baseAmountController.text),
            salesFee: CustomFormat().deCommafy(_saleAmountController.text),
            voice: _voiceController.text,
            message: _smsController.text,
            cellData: _dataController.text,
            carrierPlanType: _selectedSubscriberTargetCode,
            carrierType: _selectedPlanTypeCode,
            priority: int.tryParse(_priorityController.text),
            status: _selectedStatusCode,
            qos: _qosController.text,
            videoEtc: _videoEtcController.text,
          ));

      if (result) {
        await widget.callback();
        if (mounted) context.pop();
      }
    }

    _dataUpdating = false;
    setState(() {});
  }
}
