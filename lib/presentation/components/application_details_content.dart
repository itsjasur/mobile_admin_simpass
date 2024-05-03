import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/image_viewer_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ApplicationDetailsContent extends StatefulWidget {
  final String applicationId;
  const ApplicationDetailsContent({super.key, required this.applicationId});

  @override
  State<ApplicationDetailsContent> createState() => _ApplicationDetailsContentState();
}

class _ApplicationDetailsContentState extends State<ApplicationDetailsContent> {
  ApplicationDetailsModel? _details;
  bool _loading = true;

  bool _imageLoading = false;

  List _base64ImagesList = [];

  @override
  void initState() {
    super.initState();
    _fetchApplicationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Align(
                  child: SingleChildScrollView(
                    child: _details == null
                        ? const Center(
                            child: Text('Data fetching error'),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(50),
                                Flexible(
                                  child: Text(
                                    "접수번호: ${_details!.actNo ?? ""}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Gap(10),
                                Flexible(
                                  child: Text(
                                    "접수번호: ${_details!.agentNm ?? ""}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Gap(20),
                                const Text(
                                  '가입신청/고객정보',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '서비스유형',
                                        initialValue: _details!.carrierTypeNm,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '통신사',
                                        initialValue: _details!.carrierNm,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '고객정보',
                                        initialValue: _details!.custTypeNm,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '고객정보',
                                        initialValue: _details!.custNm,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                CustomTextInput(
                                  title: '이름',
                                  initialValue: _details!.name,
                                  readOnly: true,
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '생년월일',
                                        initialValue: _details!.birthday,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '신분증/여권번호',
                                        initialValue: _details!.idNo,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '연락처',
                                        initialValue: _details!.contact,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '국적',
                                        initialValue: _details!.countryCd,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                CustomTextInput(
                                  title: '주소(주소+상세주소)',
                                  initialValue: _details!.address,
                                  readOnly: true,
                                ),
                                const Gap(30),
                                const Text(
                                  '요금제',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(15),
                                CustomTextInput(
                                  title: '요금제 명',
                                  initialValue: _details!.usimPlanNm,
                                  readOnly: true,
                                ),
                                const Gap(20),
                                CustomTextInput(
                                  title: '유심비용청구',
                                  initialValue: _details!.usimFeeNm,
                                  readOnly: true,
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: 'USIM 모델명',
                                        initialValue: _details!.usimModelNo,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '일련번호',
                                        initialValue: _details!.usimNo,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '개통구분',
                                        initialValue: _details!.usimActNm,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '가입/이동 전화번호',
                                        initialValue: _details!.phoneNumber,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '희망번호 1',
                                        initialValue: _details!.requestNo1,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '희망번호 2',
                                        initialValue: _details!.requestNo2,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '희망번호 3',
                                        initialValue: _details!.requestNo3,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(30),
                                const Text(
                                  '자동이체',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(15),
                                CustomTextInput(
                                  title: '결제구분',
                                  initialValue: _details!.paidTransferNm,
                                  readOnly: true,
                                ),
                                const Gap(20),
                                CustomTextInput(
                                  title: '예금주명',
                                  initialValue: _details!.accountName,
                                  readOnly: true,
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '예금주 생년월일',
                                        initialValue: _details!.accountBirthday,
                                        readOnly: true,
                                      ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      child: CustomTextInput(
                                        title: '은행(카드사)명',
                                        initialValue: _details!.accountAgency,
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(40),
                                SizedBox(
                                  height: 47,
                                  width: 100,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      foregroundColor: MainUi.mainColor,
                                      side: const BorderSide(color: MainUi.mainColor),
                                    ),
                                    onPressed: _imageLoading
                                        ? null
                                        : () async {
                                            await _fetchApplicationImages();
                                            if (_base64ImagesList.isNotEmpty && context.mounted) {
                                              showDialog(
                                                barrierColor: Colors.black,
                                                context: context,
                                                builder: (context) => ImageViewerContent(binaryImageList: _base64ImagesList),
                                              );
                                            }
                                          },
                                    child: _imageLoading ? const ButtonCircularProgressIndicator() : const Text('증빙자료'),
                                  ),
                                ),
                                const Gap(40),
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

  Future<void> _fetchApplicationDetails() async {
    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchApplicationDetails(
        context: context,
        applicationId: widget.applicationId,
      );
      _details = result;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    _loading = false;
    setState(() {});
  }

  Future<void> _fetchApplicationImages() async {
    _imageLoading = true;
    setState(() {});
    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchApplicationAttachs(
        context: context,
        applicationId: widget.applicationId,
      );
      _base64ImagesList = result;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    _imageLoading = false;
    setState(() {});
  }
}
