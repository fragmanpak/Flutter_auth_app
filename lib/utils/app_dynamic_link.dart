import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AppDynamicLink {
  /// Create link
  ///
  Future<String> createLink(String refCode) async {
    final String url = "https://itoneclick?ref=$refCode";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse(url),
      androidParameters: const AndroidParameters(
        //android/app/build.gradle
        packageName: 'com.example.zem_auth',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.zem_auth',
        minimumVersion: '0',
      ),
      uriPrefix: 'https://twoclick.page.link',
    );
    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  /// init dynamic link
  ///
  // void initDynamicLink() async {
  //   final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (instanceLink != null) {
  //     final Uri refLink = instanceLink.link;
  //     if (refLink.queryParameters.containsKey('ref')) {
  //       Share.share('Share this link : ${refLink.queryParameters['ref']}');
  //     }
  //   }
  // }

  Future<void> initDynamicLinks() async {
    /// To Handle pending dynamic links add following lines

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      String? id = deepLink.queryParameters['ref'];
      Share.share('Share this link : $id');
      debugPrint(id);
    }
  }
}
