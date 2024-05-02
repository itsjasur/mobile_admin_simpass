import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/user_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/custom_alert_dialog.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/update_add_user_content.dart';
import 'package:admin_simpass/presentation/components/pagination.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final List<UserModel> _usersList = [];

  int _totalCount = 0;

  int _currentPage = 1;
  int _perPage = perPageCounts[0];

  bool _dataLoading = true;

  final List _columns = manageMembersColumns;
  final ScrollController _horizontalScrolCntr = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    //checking user roles from myinfoprovider
    final myInfoProvider = Provider.of<MyinfoProvifer>(context, listen: false);
    List<String> myRoles = myInfoProvider.myRoles;

    return _dataLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SelectionArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(title: "사용자 관리"),
                const Gap(5),
                if (myRoles.contains('ROLE_SUPER'))
                  Container(
                    height: 47,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    constraints: const BoxConstraints(minWidth: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        showCustomDialog(
                          content: UpdateAddUserContent(
                            isNew: true,
                            callback: _fetchUsers,
                          ),
                          context: context,
                        );
                      },
                      child: const Text("신규등록 +"),
                    ),
                  ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Pagination(
                    totalCount: _totalCount,
                    onUpdated: (currentPage, perPage) async {
                      if (currentPage != _currentPage || perPage != _perPage) {
                        _currentPage = currentPage;
                        _perPage = perPage;
                        _usersList.clear();
                        await _fetchUsers();
                      }
                    },
                  ),
                ),
                const Gap(5),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Scrollbar(
                      controller: _horizontalScrolCntr,
                      scrollbarOrientation: ScrollbarOrientation.top,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalScrolCntr,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 50, left: 20, right: 20),
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 50,
                            ),
                            child: DataTable(
                              sortColumnIndex: _sortColumnIndex,
                              sortAscending: _sortAscending,
                              showCheckboxColumn: false,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              border: TableBorder.all(
                                color: Colors.transparent, // Make border color transparent
                                width: 0,
                              ),
                              dataRowMinHeight: 40,
                              columnSpacing: 40,
                              headingRowHeight: 50,
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              columns: List.generate(
                                _columns.length,
                                (index) {
                                  return DataColumn(
                                    onSort: (columnIndex, ascending) {
                                      _sortAscending = ascending;
                                      _sortColumnIndex = columnIndex;

                                      void mysort<T>(Comparable<T> Function(UserModel model) getField) {
                                        _usersList.sort((a, b) {
                                          final aValue = getField(a);
                                          final bValue = getField(b);

                                          return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
                                        });
                                      }

                                      if (columnIndex == 0) mysort((model) => model.id);
                                      if (columnIndex == 1) mysort((model) => model.username.toLowerCase());
                                      if (columnIndex == 2) mysort((model) => model.name.toLowerCase());
                                      if (columnIndex == 3) _usersList.sort((a, b) => _sortAscending ? a.countryNm.compareTo(b.countryNm) : b.countryNm.compareTo(a.countryNm));
                                      if (columnIndex == 6) _usersList.sort((a, b) => _sortAscending ? a.statusNm.compareTo(b.status) : b.statusNm.compareTo(a.statusNm));
                                      if (columnIndex == 7) _usersList.sort((a, b) => _sortAscending ? a.fromDate.compareTo(b.fromDate) : b.fromDate.compareTo(a.fromDate));

                                      setState(() {});
                                    },
                                    label: Text(_columns[index]),
                                  );
                                },
                              ),
                              rows: List.generate(
                                _usersList.length,
                                (rowIndex) => DataRow(
                                  // onSelectChanged: (value) {},

                                  cells: List.generate(
                                    _columns.length,
                                    (columnIndex) {
                                      if (columnIndex == 0) {
                                        return DataCell(
                                          Text(_usersList[rowIndex].id.toString()),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 1) {
                                        return DataCell(
                                          Text(_usersList[rowIndex].username),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 2) {
                                        return DataCell(
                                          Text(_usersList[rowIndex].name),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 3) {
                                        return DataCell(
                                          Text(_usersList[rowIndex].countryNm),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 4) {
                                        return DataCell(
                                          Text(_usersList[rowIndex].phoneNumber),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 5) {
                                        return DataCell(
                                          placeholder: false,
                                          Text(_usersList[rowIndex].email),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 6) {
                                        Color containerColor = Colors.black38;
                                        if (_usersList[rowIndex].status == 'Y') containerColor = Colors.green;
                                        if (_usersList[rowIndex].status == 'W') containerColor = Colors.redAccent;

                                        return DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
                                            decoration: BoxDecoration(
                                              color: containerColor,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              _usersList[rowIndex].statusNm,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 7) {
                                        return DataCell(
                                          Text(CustomFormat().formatDateTime(_usersList[rowIndex].fromDate) ?? ""),
                                          onTap: () {},
                                        );
                                      }
                                      if (columnIndex == 8) {
                                        return DataCell(
                                          const Icon(Icons.edit_outlined, color: MainUi.mainColor),
                                          onTap: () {
                                            showCustomDialog(
                                              content: UpdateAddUserContent(
                                                userId: _usersList[rowIndex].id,
                                                userName: _usersList[rowIndex].username,
                                                callback: _fetchUsers,
                                              ),
                                              context: context,
                                            );
                                          },
                                        );
                                      }

                                      return DataCell(onTap: () {}, const SizedBox());
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> _fetchUsers() async {
    if (_currentPage == 1) _usersList.clear();

    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchUsers(context: context, page: _currentPage, rowLimit: _perPage);

      if (result['data'] != null && result['data']['result'] == 'SUCCESS') {
        Map data = result['data'];
        List rows = data['rows'];
        _totalCount = data['totalNum'];

        List<UserModel> newList = rows.map((json) => UserModel.fromJson(json)).toList();
        _usersList.addAll(newList);
      }

      await Future.delayed(const Duration(seconds: 1));
      _dataLoading = false;
      setState(() {});
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
