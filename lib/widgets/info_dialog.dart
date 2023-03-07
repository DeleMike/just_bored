import 'package:flutter/material.dart';

import '../configs/constants.dart';

/// shows dialog to prompt user's about logout event
Future<bool> closeDialog(BuildContext context, {required String title, required String details}) async {
  var closePage = false;
  await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            details,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: Text(
                'NO',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: kWhite, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                closePage = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              //style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
              onPressed: () {
                closePage = true;
                Navigator.of(context).pop();
              },
              child: Text(
                'YES',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      });

  return closePage;
}
