// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuzmeIcon extends StatelessWidget {
  const BuzmeIcon(this.iconData, {super.key, this.size = 32.0, this.color});
  final String iconData;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconData,
      color: color,
      width: size,
      fit: BoxFit.fitWidth,
    );
  }
}

class BuzmeIcons {
  static const String root = 'assets/icons';

  static const String home = '$root/home.svg';
  static const String payments = '$root/payments.svg';
  static const String add_link = '$root/add_link.svg';
  static const String policy_alert = '$root/policy_alert.svg';
  static const String whatsApp = '$root/whatsApp.svg';
  static const String heart = '$root/heart.svg';
  static const String heartLiked = '$root/heartLiked.svg';
  static const String polygon_2a = '$root/Polygon_2a.svg';
  static const String polygon_2b = '$root/Polygon_2b.svg';
  static const String company_logo = '$root/company_logo.svg';
  static const String qr_code = '$root/qr-code.svg';
  static const String buzme_logo_dark = '$root/buzme_logo_home.svg';
  static const String buzme_logo_light = '$root/light_logo.svg';
  static const String business_card_demo = '$root/business_card_demo.svg';

  static const String follow = '$root/follow.svg';
  static const String preview = '$root/preview.svg';
  static const String project = '$root/project.svg';
  static const String chat = '$root/chat.svg';
  static const String follow2 = '$root/tab_new_right2.svg';
  static const String chat2 = '$root/chat2.svg';
  static const String share2 = '$root/share2.svg';
  static const String download2 = '$root/download2.svg';
  static const String infoIcon = '$root/info_icon.svg';

  static const String photo_camera = '$root/photo_camera.svg';
  static const String captive_portal = '$root/captive_portal.svg';
  static const String captive_portal2 = '$root/captive_portal2.svg';
  static const String web = '$root/web.svg';
  static const String web_light = '$root/web_light.svg';
  static const String youtube = '$root/youtube.svg';
  static const String youtube2 = '$root/youtube2.svg';
  static const String facebook = '$root/facebook.svg';
  static const String twitter = '$root/twitter.svg';
  static const String instagram = '$root/instagram.svg';
  static const String filter_list = '$root/filter_list.svg';
  static const String check = '$root/check.svg';
  static const String rocket_launch = '$root/rocket_launch.svg';
  static const String pace = '$root/pace.svg';
  static const String left_arrow = '$root/left_arrow.svg';
  static const String notification2 = '$root/notification2.svg';
  static const String stats = '$root/stats.svg';
  static const String bus_chart = '$root/bus_chart.svg';
  static const String location2 = '$root/location2.svg';
  static const String event = '$root/event.svg';
  static const String schedule = '$root/schedule.svg';
  static const String flash = '$root/flash.svg';
  static const String log = '$root/log.svg';
  static const String share = '$root/share.svg';

  static const String map = '$root/map.svg';
  static const String engineering = '$root/engineering.svg';
  static const String sales = '$root/sales.svg';
  static const String delivery = '$root/delivery_alt.svg';
  static const String motorcycle = '$root/motorcycle_alt.svg';

  static const String localShipping = '$root/local_shipping.svg';

  static const String thumb_up = '$root/thumb_up.svg';
  static const String local_fire = '$root/local_fire_department.svg';
  static const String notification = '$root/notification.svg';
  static const String cart = '$root/cart.svg';
  static const String addCart = '$root/add-cart.svg';
  static const String removeCart = '$root/remove_shopping_cart.svg';

  static const String menu = '$root/menu.svg';

  static const String insta = '$root/insta3.svg';
  static const String tiktok = '$root/tiktok.svg';
  static const String fbk = '$root/fb.svg';
  static const String pesron2 = '$root/person2.svg';
  static const String portal2 = '$root/portal2.svg';

  static const String id_num = '$root/id_num.svg';
  static const String start_time_n_date = '$root/start_time_n_date.svg';
  static const String explore = '$root/explore.svg';

  static const String post_status = '$root/post_status.svg';
  static const String post_status_camera = '$root/camera_2.svg';
  static const String post_status_upload = '$root/post_status_upload.svg';
  static const String delete_status = '$root/delete_status.svg';
  static const String promote_card2 = '$root/promote_cards.svg';

  static const String see_business = '$root/see_business.svg';
  static const String follow_business = '$root/follow_business.svg';
  static const String made_in_cameroon = '$root/made_in_cameroon.svg';

  static const String phone = '$root/phone.svg';
  static const String message = '$root/new_message.svg';

  static const String deals = '$root/deals.svg';
  static const String shopping = '$root/shopping.svg';

  // static const String chat = '$root/chat.svg';
  // static const String chat = '$root/chat.svg';
  static const String shopping_basket = 'shopping_basket';
  static const String projectImg = 'project';
  static const String previewImg = 'preview';
  static const String localShippingImg = 'local_shipping';
  static const String ambassadorImg = 'ambassador';
  static const String membershipImg = 'membership';
  static const String promotionsImg = 'promotions';

  static const String orders = 'orders';
  static const String promote_card = 'promote_card';
  static const String setting = 'setting';
  static const String new_wallet = 'new_wallet';
  static const String reservations = 'reservations';
  static const String previews = 'previews';
  static const String new_message = 'new_message';
  static const String memberships = 'memberships';
  static const String new_setting = 'new_setting';

  static const String inquiry = 'inquiry';
  static const String marketing = 'marketing';
  static const String new_follower = 'new_follower';
  static const String new_sub = 'new_sub';
  static const String recommendation = 'recommendation';
  static const String shipping_detail = 'planeshipping_detail';
  static const String delivery_detail = 'delivery_detail';
  static const String pickup_detail = 'storepickup_detail';
}
