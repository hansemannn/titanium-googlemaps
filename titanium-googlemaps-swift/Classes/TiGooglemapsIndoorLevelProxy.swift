/**
 * Axway Titanium
 */

import Foundation
import TitaniumKit
import GoogleMaps

@objc(TiGooglemapsIndoorLevelProxy)
public class TiGooglemapsIndoorLevelProxy: TiProxy {
  private var level: GMSIndoorLevel?
  
  @objc(_initWithPageContext:andIndoorLevel:)
  public func _init(withPageContext context: TiEvaluator?, andIndoorLevel indoorLevel: GMSIndoorLevel) -> Self? {
    guard let proxy = super._init(withPageContext: context) else { return nil }
    level = indoorLevel
    return proxy
  }
  
  @objc public func indoorLevel() -> GMSIndoorLevel? {
    return level
  }
  
  @objc public func name() -> String? {
    return level?.name
  }
  
  @objc public func shortName() -> String? {
    return level?.shortName
  }
}
