import 'package:flutter/material.dart';
import 'package:just_bored/core/dashboard/home/providers/home_controller.dart';
import 'package:provider/provider.dart';

import '../../configs/constants.dart';
import '../core/auth/providers/auth_controller.dart';
import 'logout_dialog.dart';

/// General app bar
class JBAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String headerText;
  final bool needsABackButton;
  final bool? actionCameFromAppBar;
  final void Function()? handleBackButtonPress;
  final Color? color;
  final Color? iconColor;

  /// General app bar
  const JBAppbar({
    Key? key,
    required this.headerText,
    required this.needsABackButton,
    this.actionCameFromAppBar,
    this.handleBackButtonPress,
    this.color,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: color ?? kWhite,
        elevation: 0,
        shadowColor: kPrimaryColor,
        title: Text(
          headerText,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor),
        ),
        leading: needsABackButton
            ? IconButton(
                // perform normal back button press if there is no custom function given
                onPressed: handleBackButtonPress ?? () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: iconColor ?? kBlack,
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
                      // clean resources
                        // ignore: use_build_context_synchronously
                      context.read<HomeController>().reset();
                      // ignore: use_build_context_synchronously
                      await context.read<AuthController>().logout(context);
                    }
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: iconColor ?? kDefaultIconDarkColor,
                  ),
                ),
              ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
