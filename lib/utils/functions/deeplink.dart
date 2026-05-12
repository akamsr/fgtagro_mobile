import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class DeepLinker {
  static Future<String> createDeepLink({
    required String title,
    String channel = '',
    String? imageUrl,
    String? cannonicalUrl,
    required String messageText,
    List<String> tags = const [],
    Map<String, dynamic> extradata = const {},
    Map<String, dynamic> customParams = const {},
    required String linkType,
    required String route,
  }) async {
    final BranchResponse response =
        await FlutterBranchSdk.getLastAttributedTouchData();
    if (response.success) {
      debugPrint(response.result.toString());
    }

    final BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      // canonicalUrl:
      // cannonicalUrl ??
      // 'https://res.cloudinary.com/dohtech/image/upload/v1706298076/business_banners/VERIFIED_BUSINESS_m9v2xc.png',
      title: title,
      imageUrl:
          'https://res.cloudinary.com/dohtech/image/upload/v1706298076/business_banners/VERIFIED_BUSINESS_m9v2xc.png',
      contentDescription: messageText,
      keywords: tags,
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: _addCustomData(extradata)
        ..addCustomMetadata('link_type', linkType)
        ..addCustomMetadata('route', route),
    );

    final BranchLinkProperties lp = BranchLinkProperties(
      //alias: 'flutterplugin', //define link url,
      channel: channel,
      feature: 'sharing',
      stage: 'new share',
      tags: tags,
    );

    final BranchResponse responseR = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );

    if (response.success) {
      debugPrint('Link generated: ${response.result}');
    } else {
      debugPrint('Error : ${response.errorCode} - ${response.errorMessage}');
    }

    await FlutterBranchSdk.showShareSheet(
      buo: buo,
      linkProperties: lp,
      messageText: messageText,
      androidMessageTitle: messageText,
      androidSharingTitle: title,
    );

    if (response.success) {
      debugPrint('showShareSheet Sucess');
    } else {
      debugPrint('Error : ${response.errorCode} - ${response.errorMessage}');
    }
    return responseR.result;
  }

  static BranchContentMetaData _addCustomData(Map<String, dynamic> data) {
    final metaData = BranchContentMetaData();
    final keys = data.keys.toList();
    final values = data.values.toList();

    for (var i = 0; i < keys.length; i++) {
      if (values[i] != null) metaData..addCustomMetadata(keys[i], values[i]);
    }
    return metaData;
  }
}
