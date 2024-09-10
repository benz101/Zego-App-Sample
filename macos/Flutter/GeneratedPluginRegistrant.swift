//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import flutter_inappwebview_macos
import package_info_plus
import path_provider_foundation
import sqflite
import wakelock_plus
import zego_express_engine
import zego_zim

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  InAppWebViewFlutterPlugin.register(with: registry.registrar(forPlugin: "InAppWebViewFlutterPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  WakelockPlusMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockPlusMacosPlugin"))
  ZegoExpressEnginePlugin.register(with: registry.registrar(forPlugin: "ZegoExpressEnginePlugin"))
  ZegoZimPlugin.register(with: registry.registrar(forPlugin: "ZegoZimPlugin"))
}
