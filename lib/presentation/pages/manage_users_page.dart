import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/user_model.dart';
import 'package:admin_simpass/globals/controller_handler.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/side_menu.dart';
import 'package:admin_simpass/presentation/components/update_add_user_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final List<UserModel> _infoList = [];
  int _totalCount = 0;
  int _currentPage = 1;
  bool _dataLoading = true;
  bool _newDataLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (_infoList.length < _totalCount && !_newDataLoading) {
          _currentPage++;
          _newDataLoading = true;
          setState(() {});
          await _fetchData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ////checking user roles from myinfoprovider
    // final myInfoProvider = Provider.of<MyinfoProvifer>(context, listen: false);
    // List<String> myRoles = myInfoProvider.myRoles;

    return Scaffold(
      appBar: AppBar(title: const Text("사용자 관리")),
      drawer: const SideMenu(),
      body: _dataLoading
          ? const Material(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _infoList.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "총 사용자: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  _totalCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    if (index == _infoList.length + 1) {
                      return _newDataLoading
                          ? Align(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 50),
                                height: 30,
                                width: 30,
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }

                    // cards
                    int rowIndex = index - 1;
                    Color statusColor = Colors.grey;
                    if (_infoList[rowIndex].status == 'Y') statusColor = Colors.green;
                    if (_infoList[rowIndex].status == 'W') statusColor = Colors.redAccent;

                    return Container(
                      color: Colors.grey.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "아이디: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].username.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "상태: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].statusNm,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "이름: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].username.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "휴대전화: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].phoneNumber.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "국가: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].countryNm.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "이매일: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  _infoList[rowIndex].email.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 30,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: MainUi.mainColor,
                                  side: const BorderSide(color: MainUi.mainColor),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => UpdateAddUserContent(
                                      userId: _infoList[rowIndex].id,
                                      userName: _infoList[rowIndex].username,
                                      callback: _fetchData,
                                      isNew: false,
                                    ),
                                  );
                                },
                                child: const Text('업데이트'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    children: [
                      InkWell(
                        hoverColor: Colors.white54,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          // context.pop();
                          scrollToBegin(_scrollController);
                        },
                        onHover: (value) {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black38,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        hoverColor: Colors.white54,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          scrollToEnd(_scrollController);
                        },
                        onHover: (value) {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black38,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _fetchData() async {
    if (_currentPage == 1) _infoList.clear();

    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchUsers(context: context, page: _currentPage, rowLimit: 10);

      if (result['data'] != null && result['data']['result'] == 'SUCCESS') {
        Map data = result['data'];
        List rows = data['rows'];
        _totalCount = data['totalNum'];

        List<UserModel> newList = rows.map((json) => UserModel.fromJson(json)).toList();
        _infoList.addAll(newList);
      }

      // await Future.delayed(const Duration(seconds: 2));
      _dataLoading = false;
      _newDataLoading = false;
      setState(() {});
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
