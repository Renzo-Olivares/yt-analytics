import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

enum DialogType { backup, restore }

class BackupRestoreDialog extends StatelessWidget {
  BackupRestoreDialog({@required this.type}) : assert(type != null);
  final DialogType type;
  final filePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${type == DialogType.backup ? 'Backup' : 'Restore'} file path',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: filePathController,
            decoration: InputDecoration(
              filled: true,
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              labelText:
                  '${type == DialogType.backup ? 'Backup' : 'Restore'} file path',
            ),
          ),
          const SizedBox(height: 16),
          ButtonBar(
            children: [
              OutlinedButton(
                onPressed: () {
                  if (type == DialogType.backup) {
                    Provider.of<EntityManager>(context, listen: false)
                        .backupData(
                      filePathController.text.replaceAll(RegExp(r'/'), '%2F'),
                    );
                  } else {
                    Provider.of<EntityManager>(context, listen: false)
                        .restoreData(
                      filePathController.text.replaceAll(RegExp(r'/'), '%2F'),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Initiate ${type == DialogType.backup ? 'Backup' : 'Restore'}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
