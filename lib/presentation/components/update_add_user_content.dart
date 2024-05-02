import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/member_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/date_time_picker.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdateAddUserContent extends StatefulWidget {
  final String? userName;
  final int? userId;
  final bool isNew;
  final Function() callback;
  const UpdateAddUserContent({super.key, this.userName, this.userId, this.isNew = false, required this.callback});

  @override
  State<UpdateAddUserContent> createState() => _UpdateAddUserContentState();
}

class _UpdateAddUserContentState extends State<UpdateAddUserContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passReentryController = TextEditingController();

  String? _countryErrorText;

  final TextEditingController _fromDateController = TextEditingController(text: CustomFormat().formatDateTime(DateTime.now().toString()));
  final TextEditingController _expiryDateController = TextEditingController(text: CustomFormat().formatDateTime(DateTime.now().add(const Duration(days: 365)).toString()));

  String _selectedCountryCode = countryNameCodelist[0]['code'];

  String _selectedStatusCode = memberStatuses[0]['code'];

  final List<DropdownMenuEntry> _countries = countryNameCodelist.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();
  final List<DropdownMenuEntry> _statuses = memberStatuses.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();

  final List<Map<String, dynamic>> _userRolesList = userRolesList;
  final _formKey = GlobalKey<FormState>();

  Set _globalLowRoleCodes = {};
  Set _globalHighRoleCodes = {};

  final Set _selectedRoles = {};

  bool _dataUpdating = false;

  @override
  void initState() {
    super.initState();
    _handleCheckboxes();

    if (!widget.isNew) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _expiryDateController.dispose();
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passController.dispose();
    _passReentryController.dispose();
    _selectedRoles.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Text(
                  widget.isNew ? "신규 사용자 등록" : "사용자 수정",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextInput(
                        enabled: widget.isNew,
                        controller: _userNameController,
                        title: '아이디',
                        validator: InputValidator().validateId,
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: CustomTextInput(
                        controller: _fullNameController,
                        title: '이름',
                        validator: InputValidator().validateName,
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextInput(
                        controller: _emailController,
                        title: '이메일',
                        validator: InputValidator().validateEmail,
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: CustomTextInput(
                        controller: _phoneNumberController,
                        inputFormatters: [PhoneNumberFormatter()],
                        maxlength: 13,
                        title: '휴대전화',
                        validator: InputValidator().validatePhoneNumber,
                      ),
                    ),
                  ],
                ),
                if (widget.isNew) const Gap(30),
                if (widget.isNew)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextInput(
                          controller: _passController,
                          title: '비밀번호',
                          validator: InputValidator().validatePass,
                          hidden: true,
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: CustomTextInput(
                          controller: _passReentryController,
                          title: '비밀번호 확인',
                          validator: (p0) => InputValidator().validateRentryPass(_passController.text, p0),
                          hidden: true,
                        ),
                      ),
                    ],
                  ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          //  use constraints.maxWidth as the parent's width here.
                          return CustomDropDownMenu(
                            label: const Text("국가"),
                            errorText: _countryErrorText,
                            enableSearch: true,
                            onSelected: (selectedItem) {
                              if (selectedItem != null) _selectedCountryCode = selectedItem;
                              _countryErrorText = null;
                              setState(() {});
                            },
                            width: constraints.maxWidth,
                            items: _countries,
                            selectedItem: _selectedCountryCode,
                          );
                        },
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          //  use constraints.maxWidth as the parent's width here.
                          return CustomDropDownMenu(
                            label: const Text("상태"),
                            enableSearch: true,
                            onSelected: (selectedItem) {
                              if (selectedItem != null) _selectedStatusCode = selectedItem;
                            },
                            width: constraints.maxWidth,
                            items: _statuses,
                            selectedItem: _selectedStatusCode,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    _userRolesList.length,
                    (index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: _userRolesList[index]['state'] == "hidden"
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();

                                if (_globalHighRoleCodes.contains(_userRolesList[index]["code"])) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("이미 선택권한의 하위권한이 선택 또는 존재합니다.")));
                                } else {
                                  //if checked : unchecked
                                  _userRolesList[index]['checked'] ? _selectedRoles.remove(_userRolesList[index]['code']) : _selectedRoles.add(_userRolesList[index]['code']);
                                  _handleCheckboxes();
                                }
                              },
                        onHover: (value) {},
                        child: IgnorePointer(
                          ignoring: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  value: _userRolesList[index]['checked'],
                                  onChanged: (newValue) {},
                                ),
                                const Gap(5),
                                Flexible(
                                    child: Text(
                                  _userRolesList[index]['label'],
                                  style: TextStyle(color: _userRolesList[index]['state'] == 'hidden' ? Colors.black38 : Colors.black),
                                )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          CustomTextInput(
                            controller: _fromDateController,
                            title: '시작일자',
                            onTap: () async {
                              String? selectedDate = await showDateTimePicker(context);
                              if (selectedDate != null) _fromDateController.text = CustomFormat().formatDateTime(selectedDate) ?? "";
                            },
                            readOnly: true,
                          ),
                          const Positioned(
                            right: 10,
                            child: IgnorePointer(
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          CustomTextInput(
                            controller: _expiryDateController,
                            onTap: () async {
                              String? selectedDate = await showDateTimePicker(context);
                              if (selectedDate != null) _expiryDateController.text = CustomFormat().formatDateTime(selectedDate) ?? "";
                            },
                            readOnly: true,
                            title: '종료일자',
                          ),
                          const Positioned(
                            right: 10,
                            child: IgnorePointer(
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(40),
                Align(
                  alignment: Alignment.topRight,
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
                                  widget.isNew ? _addNewMember() : _updateMemberData();
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

  Future<void> _fetchData() async {
    final APIService apiService = APIService();

    try {
      MemberModel memberInfo = await apiService.fetchMemberInfo(context: context, memberUserName: widget.userName!);
      _userNameController.text = memberInfo.username;
      _fullNameController.text = memberInfo.name ?? '';
      _emailController.text = memberInfo.email ?? "";
      _phoneNumberController.text = memberInfo.phoneNumber ?? "";
      _selectedCountryCode = memberInfo.country ?? "";
      _selectedStatusCode = memberInfo.status ?? memberStatuses[0]['code'];

      _fromDateController.text = CustomFormat().formatDateTime(memberInfo.fromDate) ?? "";
      _expiryDateController.text = CustomFormat().formatDateTime(memberInfo.expireDate) ?? "";

      List<dynamic> rolesList = memberInfo.strRoles ?? [];
      _selectedRoles.addAll(rolesList);
      _handleCheckboxes();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {});
  }

  Future<void> _updateMemberData() async {
    _dataUpdating = true;
    setState(() {});

    if (_selectedCountryCode.isEmpty) {
      _countryErrorText = "국가를 선택하세요.";
      setState(() {});
    }

    if (_formKey.currentState!.validate() && _selectedCountryCode.isNotEmpty) {
      final APIService apiService = APIService();
      await apiService.memberUpdate(
        context: context,
        requestModel: MemberUpdate(
          id: widget.userId,
          username: widget.userName!,
          email: _emailController.text,
          name: _fullNameController.text,
          status: _selectedStatusCode,
          fromDate: CustomFormat().formatDateTime(_fromDateController.text),
          expireDate: CustomFormat().formatDateTime(_expiryDateController.text),
          country: _selectedCountryCode,
          phoneNumber: _phoneNumberController.text,
          roles: _selectedRoles.toList(),
        ),
      );
      widget.callback();
      if (mounted) context.pop();
    }

    _dataUpdating = false;
    setState(() {});
  }

  Future<void> _addNewMember() async {
    _dataUpdating = true;
    setState(() {});

    if (_selectedCountryCode.isEmpty) {
      _countryErrorText = "국가를 선택하세요.";
      setState(() {});
    }

    if (_formKey.currentState!.validate() && _selectedCountryCode.isNotEmpty) {
      final APIService apiService = APIService();
      await apiService.memberRegister(
        context: context,
        requestModel: MemberRegister(
          username: _userNameController.text,
          email: _emailController.text,
          name: _fullNameController.text,
          status: _selectedStatusCode,
          fromDate: CustomFormat().formatDateTime(_fromDateController.text),
          expireDate: CustomFormat().formatDateTime(_expiryDateController.text),
          country: _selectedCountryCode,
          phoneNumber: _phoneNumberController.text,
          roles: _selectedRoles.toList(),
          password: _passController.text,
        ),
      );
      widget.callback();
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) context.pop();
    }

    _dataUpdating = false;
    if (mounted) setState(() {});
  }

  void _handleCheckboxes() {
    //resetting these 2 before checking and adding again
    _globalLowRoleCodes = {};
    _globalHighRoleCodes = {};

    for (int i = 0; i < _userRolesList.length; i++) {
      //if avilable in selected
      if (_selectedRoles.contains(_userRolesList[i]['code'])) {
        _userRolesList[i]['checked'] = true;
        _globalLowRoleCodes.addAll(_userRolesList[i]['low']);
        _globalHighRoleCodes.addAll(_userRolesList[i]['high']);
      }
      //if not available in selected list
      else {
        _userRolesList[i]['checked'] = false;
      }

      if (_globalLowRoleCodes.contains(_userRolesList[i]["code"])) {
        _userRolesList[i]['state'] = "hidden";
      } else {
        _userRolesList[i]['state'] = "active";
      }
    }

    _checkSelfRole();

    setState(() {});
  }

  Future<void> _checkSelfRole() async {
    List<String> myRolesList = await Provider.of<MyinfoProvifer>(context, listen: false).getRolesList();
    if (!myRolesList.contains('ROLE_SUPER')) {
      _userRolesList[0]['state'] = 'hidden';
      _userRolesList[0]['checked'] = false;
      _globalLowRoleCodes.add('ROLE_SUPER');
    }
    setState(() {});
  }
}
