import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/constants.dart';
import '../core/auth/providers/auth_controller.dart';
import 'logout_dialog.dart';

/// General app bar
class FarmAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String headerText;
  final bool needsABackButton;
  final bool? actionCameFromAppBar;
  final void Function()? handleBackButtonPress;

  /// General app bar
  const FarmAppbar(
      {Key? key,
      required this.headerText,
      required this.needsABackButton,
      this.actionCameFromAppBar,
      this.handleBackButtonPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        shadowColor: kPrimaryColor,
        title: Text(
          headerText,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: needsABackButton
            ? IconButton(
                // perform normal back button press if there is no custom function given
                onPressed: handleBackButtonPress ?? () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: kBlack,
                ))
            : null,
        actions: (actionCameFromAppBar != null && actionCameFromAppBar!)
            ? null
            : [
                IconButton(
                  tooltip: 'Logout',
                  onPressed: () async {
                    final wantsToLogout = await logoutDialog(context);
                    debugPrint('Wants To Logout: $wantsToLogout');
                    if (wantsToLogout) {
                      // ignore: use_build_context_synchronously
                      await context.read<AuthController>().logout(context);
                    }
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: kDefaultIconDarkColor,
                  ),
                ),
              ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
