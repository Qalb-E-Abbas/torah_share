import 'package:easy_localization/easy_localization.dart';
import 'package:torah_share/translations/locale_keys.g.dart';

import '../../../screens/routes/app_routes.dart';
import '../../util_exporter.dart';

class VideoPopupMenuItem {
  String text, icon, route;

  VideoPopupMenuItem(
    this.text,
    this.icon,
    this.route,
  );
}

final List<VideoPopupMenuItem> currentUserVideoPopupMenuItemList = [
  VideoPopupMenuItem(
    tr(LocaleKeys.comment),
    Common.assetsIconsOutlined + "comment.png",
    AppRoutes.comment,
  ),
  VideoPopupMenuItem(
    tr(LocaleKeys.share),
    Common.assetsIconsOutlined + "share.png",
    Common.SHARE_VIDEO,
  ),
];

final List<VideoPopupMenuItem> otherUserAndFollowingVideoPopupMenuItemList = [
  VideoPopupMenuItem(
    tr(LocaleKeys.report),
    Common.assetsIconsOutlined + "flag.png",
    Common.REPORT_VIDEO,
  ),
  VideoPopupMenuItem(
    tr(LocaleKeys.comment),
    Common.assetsIconsOutlined + "comment.png",
    AppRoutes.comment,
  ),
  VideoPopupMenuItem(
    tr(LocaleKeys.share),
    Common.assetsIconsOutlined + "share.png",
    Common.SHARE_VIDEO,
  ),
  VideoPopupMenuItem(
    tr(LocaleKeys.un_follow),
    Common.assetsIconsOutlined + "user_follow_plus.png",
    Common.UNFOLLOW_USER_FROM_VIDEO,
  ),
];

final List<VideoPopupMenuItem> otherUserVideoPopupMenuItemList = [
  VideoPopupMenuItem(
    tr(LocaleKeys.report),
    Common.assetsIconsOutlined + "flag.png",
    Common.REPORT_VIDEO,
  ),
  VideoPopupMenuItem(
    tr(LocaleKeys.comment),
    Common.assetsIconsOutlined + "comment.png",
    AppRoutes.comment,
  ),
  VideoPopupMenuItem(
    tr(LocaleKeys.share),
    Common.assetsIconsOutlined + "share.png",
    Common.SHARE_VIDEO,
  ),
];

final List<VideoPopupMenuItem> currentUserProfileVideoPopupMenuItemList = [
  VideoPopupMenuItem(
    tr(LocaleKeys.delete),
    "${Common.assetsIconsOutlined}delete.png",
    AppRoutes.deleteVideoRoute,
  ),
];
