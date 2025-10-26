/**
 * Axway Titanium
 * Copyright (c) 2018-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

import UIKit
import TitaniumKit
import CoreLocation

@objc(TiGooglemapsClusterItemProxy)
public class TiGooglemapsClusterItemProxy: TiProxy {
  private var clusterItemInternal: TiPOIItem?
  
  @objc(_initWithPageContext:andPosition:title:subtitle:icon:userData:)
  func _init(withPageContext context: TiEvaluator?,
             andPosition position: CLLocationCoordinate2D,
             title: String?,
             subtitle: String?,
             icon: Any?,
             userData: [AnyHashable: Any]?) -> Self? {
    guard let proxy = super._init(withPageContext: context) else {
      return nil
    }
    
    let nativeIcon = resolveIcon(icon)
    clusterItemInternal = TiPOIItem(
      position: position,
      andTitle: title,
      subtitle: subtitle,
      icon: nativeIcon,
      userData: userData
    )
    
    return proxy
  }
  
  @objc(clusterItem)
  func clusterItem() -> TiPOIItem? {
    return clusterItemInternal
  }
  
  private func resolveIcon(_ icon: Any?) -> UIImage? {
    if let image = icon as? UIImage {
      return image
    }
    
    return TiUtils.toImage(icon, proxy: self)
  }
}
