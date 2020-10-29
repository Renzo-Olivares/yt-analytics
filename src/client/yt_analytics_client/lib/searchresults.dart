import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/insertform.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

class SearchResults extends StatefulWidget {
  SearchResults({this.mockModel});

  final Future<List<Entity>> mockModel;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.widget.mockModel,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _TrendingVideoDataSource ytData =
                  _TrendingVideoDataSource(entities: snapshot.data);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PaginatedDataTable(
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return InsertForm();
                          },
                        );
                      },
                      tooltip: 'Insert',
                      icon: Icon(Icons.add_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: 'Edit',
                      icon: Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      onPressed: () {
                        Provider.of<EntityManager>(context, listen: false)
                            .deleteSelected();
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: 'Backup',
                      icon: Icon(Icons.backup_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: 'Restore',
                      icon: Icon(Icons.restore_outlined),
                    ),
                  ],
                  header: const Text('Trending Videos'),
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: (value) {
                    setState(() {
                      _rowsPerPage = value;
                    });
                  },
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  onSelectAll: ytData.selectAll,
                  columns: const [
                    DataColumn(
                      label: Text('Video ID'),
                    ),
                    DataColumn(
                      label: Text('Trending Date'),
                    ),
                    DataColumn(
                      label: Text('Video Title'),
                    ),
                    DataColumn(
                      label: Text('Channel Name'),
                    ),
                    DataColumn(
                      label: Text('Category'),
                    ),
                    DataColumn(
                      label: Text('Publish Time'),
                    ),
                    // DataColumn(
                    //   label: Text('Tags'),
                    // ),
                    DataColumn(
                      label: Text('Views'),
                    ),
                    DataColumn(
                      label: Text('Likes'),
                    ),
                    DataColumn(
                      label: Text('Dislikes'),
                    ),
                    DataColumn(
                      label: Text('Comment Count'),
                    ),
                    DataColumn(
                      label: Text('Thumbnail Link'),
                    ),
                    DataColumn(
                      label: Text('Comments Disabled'),
                    ),
                    DataColumn(
                      label: Text('Ratings Disabled'),
                    ),
                    DataColumn(
                      label: Text('Video Conflict'),
                    ),
                    DataColumn(
                      label: Text('Description'),
                    ),
                  ],
                  source: ytData,
                ),
              );
            }
        }
      },
    );
  }
}

class _TrendingVideoDataSource extends DataTableSource {
  _TrendingVideoDataSource({this.entities});
  List<Entity> entities;
  int selectedCount = 0;

  @override
  DataRow getRow(int index) {
    final trendingEntry = entities[index];

    assert(index >= 0);
    if (index >= entities.length) return null;

    return DataRow.byIndex(
      index: index,
      selected: trendingEntry.selected,
      onSelectChanged: (value) {
        if (trendingEntry.selected != value) {
          selectedCount += value ? 1 : -1;
          assert(selectedCount >= 0);
          trendingEntry.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(trendingEntry.videoID)),
        DataCell(Text(trendingEntry.trendingDate)),
        DataCell(Text(trendingEntry.title.replaceAll('\"', ''))),
        DataCell(Text(trendingEntry.channelTitle.replaceAll('\"', ''))),
        DataCell(Text(trendingEntry.category)),
        DataCell(Text(trendingEntry.publishTime)),
        // DataCell(Text(trendingEntry.tags)),
        DataCell(Text(trendingEntry.views.toString())),
        DataCell(Text(trendingEntry.likes.toString())),
        DataCell(Text(trendingEntry.dislikes.toString())),
        DataCell(Text(trendingEntry.commentCount.toString())),
        DataCell(Text(trendingEntry.thumbnailLink)),
        DataCell(Text(trendingEntry.commentsDisabled.toString())),
        DataCell(Text(trendingEntry.ratingsDisabled.toString())),
        DataCell(Text(trendingEntry.videoErrorOrRemoved.toString())),
        DataCell(Text(trendingEntry.description.replaceAll('\"', ''))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => entities.length;

  @override
  int get selectedRowCount => selectedCount;

  void selectAll(bool checked) {
    for (final trendingEntry in entities) {
      trendingEntry.selected = checked;
    }
    selectedCount = checked ? entities.length : 0;
    notifyListeners();
  }
}