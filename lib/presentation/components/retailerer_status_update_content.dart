import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RetailerStatusUpdateContent extends StatefulWidget {
  final List<DropdownMenuEntry> items;
  final String reetailerCd;
  final Function? callBack;
  final String selectedItem;

  const RetailerStatusUpdateContent({super.key, required this.items, required this.reetailerCd, this.callBack, required this.selectedItem});

  @override
  State<RetailerStatusUpdateContent> createState() => _RetailerStatusUpdateContentState();
}

class _RetailerStatusUpdateContentState extends State<RetailerStatusUpdateContent> {
  String _selectedStatusCode = "";
  final _formKey = GlobalKey<FormState>();
  bool _updating = false;

  String? _statusErrorCode;

  @override
  void initState() {
    super.initState();
    _selectedStatusCode = widget.selectedItem;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                LayoutBuilder(
                  builder: (context, constraints) => CustomDropDownMenu(
                    label: const Text("상태"),
                    items: widget.items,
                    width: constraints.maxWidth,
                    errorText: _statusErrorCode,
                    selectedItem: _selectedStatusCode,
                    onSelected: (selectedItem) {
                      _selectedStatusCode = selectedItem;
                      _statusErrorCode = null;
                      setState(() {});
                    },
                  ),
                ),
                const Gap(20),
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
    );
  }

  Future<void> _updateApplicationStatus() async {
    _updating = true;
    if (_selectedStatusCode.isEmpty) _statusErrorCode = "상태를 선택하세요.";

    setState(() {});

    if (_formKey.currentState!.validate() && _selectedStatusCode.isNotEmpty) {
      final APIService apiService = APIService();
      var result = await apiService.updateRetailerStatus(
        context: context,
        requestModel: {
          "partner_cd": widget.reetailerCd,
          "status": _selectedStatusCode,
        },
      );

      if (result) {
        if (widget.callBack != null) widget.callBack!();
        if (mounted) context.pop();
      }
    }

    _updating = false;
    setState(() {});
  }
}
