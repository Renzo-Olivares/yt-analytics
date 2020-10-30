import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

enum DialogType { BACKUP, RESTORE }

class BackupRestoreDialog extends StatelessWidget {
  BackupRestoreDialog({this.type});
  DialogType type;
  TextEditingController filePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${type == DialogType.BACKUP ? 'Backup' : 'Restore'} file path',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: filePathController,
            decoration: InputDecoration(
              filled: true,
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              labelText:
                  '${type == DialogType.BACKUP ? 'Backup' : 'Restore'} file path',
            ),
          ),
          const SizedBox(height: 16),
          ButtonBar(
            children: [
              OutlinedButton(
                onPressed: () {
                  if (type == DialogType.BACKUP) {
                    Provider.of<EntityManager>(context, listen: false)
                        .backupData(filePathController.text
                            .replaceAll(RegExp(r'/'), '%2F'));
                  } else {
                    Provider.of<EntityManager>(context, listen: false)
                        .restoreData(filePathController.text
                            .replaceAll(RegExp(r'/'), '%2F'));
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Initiate ${type == DialogType.BACKUP ? 'Backup' : 'Restore'}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
