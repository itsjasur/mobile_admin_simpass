import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CustomerRequestStatusUpdateContent extends StatefulWidget {
  final List<DropdownMenuEntry> items;

  final String selectedStatusCode;
  final int id;
  final Function? callBack;

  const CustomerRequestStatusUpdateContent({super.key, required this.items, required this.id, this.callBack, required this.selectedStatusCode});

  @override
  State<CustomerRequestStatusUpdateContent> createState() => _CustomerRequestStatusUpdateContentState();
}

class _CustomerRequestStatusUpdateContentState extends State<CustomerRequestStatusUpdateContent> {
  String _selectedStatusCode = "";
  final _formKey = GlobalKey<FormState>();
  bool _updating = false;

  String? _statusErrorCode;

  @override
  void initState() {
    super.initState();
    _selectedStatusCode = widget.selectedStatusCode;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
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
                  enableSearch: true,
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

  Future<void> _updateCustomerRequestStatus() async {
    _updating = true;
    if (_selectedStatusCode.isEmpty) _statusErrorCode = "상태를 선택하세요.";

    setState(() {});

    if (_selectedStatusCode.isNotEmpty) {
      final APIService apiService = APIService();
      var result = await apiService.updateCustomerRequestStatus(
        context: context,
        requestModel: {
          "id": widget.id,
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
