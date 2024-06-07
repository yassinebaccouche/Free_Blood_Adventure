import 'package:flutter/material.dart';

import 'model/user.dart';

class FixedHeaderDataTable extends StatelessWidget {
  final List<User> users;

  FixedHeaderDataTable({required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Row
        Container(
          color: const Color(0xffE2037A),
          child: const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderCell('Nom & prénom'),
                HeaderCell('Tél'),
                HeaderCell('Nb de challenge'),
                HeaderCell('Temps estimé'),
                HeaderCell('Nb de challenge réalisé'),
                HeaderCell('Temps réalisé'),
                HeaderCell('Score'),
              ],
            ),
          ),
        ),
        // Data Rows
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 30.0,
                headingRowHeight: 0,
                dataRowHeight: 32,
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(
                      user.fullName!,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Text(
                      user.phoneNumber!,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Text(
                      user.nbChallenge!.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Text(
                      user.estimatedTime!.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Text(
                      user.nbChallengeDone!.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Text(
                      user.actualTime!.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Text(
                      user.score!.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )),
                    DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => _showUpdateDialog(context, user),
                          child: const Text(
                            "Modifier",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 8,
                                color: Color(0xff9C187B)),
                          ),
                        ),
                        InkWell(
                          onTap: () => _showDeleteDialog(context, user.id!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xffEDEDED),
                              border: Border.all(color: const Color(0xffC7C6CB)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Supprimer',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffC7C6CB)),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateDialog(BuildContext context, User user) {
    // Implementation for update dialog
  }

  void _showDeleteDialog(BuildContext context, int userId) {
    // Implementation for delete dialog
  }
}

class HeaderCell extends StatelessWidget {
  final String text;

  const HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}