import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/backuprestoredialog.dart';
import 'package:yt_analytics_client/components/editform.dart';
import 'package:yt_analytics_client/components/insertform.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

class SearchResults extends StatefulWidget {
  SearchResults({@required this.results}) : assert(results != null);

  final Future<List<Entity>> results;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  final bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.results,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final ytData = _TrendingVideoDataSource(
                context: context,
                entities: snapshot.data as List<Entity> ?? <Entity>[],
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: PaginatedDataTable(
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => InsertForm(),
                        );
                      },
                      tooltip: 'Insert',
                      icon: const Icon(Icons.add_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        if (Provider.of<EntityManager>(context, listen: false)
                                .selectedCount ==
                            1) {
                          showDialog<void>(
                            context: context,
                            builder: (context) => EditForm(
                              entity: Provider.of<EntityManager>(
                                context,
                                listen: false,
                              ).currentSelected,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select only one entry to edit',
                              ),
                            ),
                          );
                        }
                      },
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      onPressed: () {
                        Provider.of<EntityManager>(context, listen: false)
                            .deleteSelected();
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) {
                            return BackupRestoreDialog(
                              type: DialogType.backup,
                            );
                          },
                        );
                      },
                      tooltip: 'Backup',
                      icon: const Icon(Icons.backup_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) {
                            return BackupRestoreDialog(
                              type: DialogType.restore,
                            );
                          },
                        );
                      },
                      tooltip: 'Restore',
                      icon: const Icon(Icons.restore_outlined),
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
                    DataColumn(
                      label: Text('Tags'),
                    ),
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
  _TrendingVideoDataSource({@required this.entities, @required this.context})
      : assert(entities != null),
        assert(context != null);
  List<Entity> entities;
  BuildContext context;
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
          Provider.of<EntityManager>(context, listen: false).selectedCount =
              selectedCount;
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
        DataCell(Text(parseTags(trendingEntry.tags))),
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

  String parseTags(String tags) {
    var parsedStrings = tags.split(',');

    for (var i = 0; i < parsedStrings.length; i++) {
      parsedStrings[i] = parsedStrings[i].replaceAll('\"', '');
    }

    return parsedStrings.join(' , ');
  }
}
