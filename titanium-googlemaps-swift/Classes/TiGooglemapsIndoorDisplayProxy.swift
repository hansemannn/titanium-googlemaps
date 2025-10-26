/**
 * Axway Titanium
 */

import Foundation
import TitaniumKit
import GoogleMaps

@objc(TiGooglemapsIndoorDisplayProxy)
public class TiGooglemapsIndoorDisplayProxy: TiProxy, GMSIndoorDisplayDelegate {
  private var indoorDisplay: GMSIndoorDisplay?
  
  @objc(_initWithPageContext:andIndoorDisplay:)
  public func _init(withPageContext context: TiEvaluator?, andIndoorDisplay display: GMSIndoorDisplay) -> Self? {
    guard let proxy = super._init(withPageContext: context) else { return nil }
    indoorDisplay = display
    indoorDisplay?.delegate = self
    return proxy
  }
  
  @objc public func activeBuilding() -> [String: Any]? {
    guard let building = indoorDisplay?.activeBuilding else { return nil }
    return dictionary(from: building)
  }
  
  @objc public func activeLevel() -> TiGooglemapsIndoorLevelProxy? {
    guard let level = indoorDisplay?.activeLevel else { return nil }

    return TiGooglemapsIndoorLevelProxy()._init(withPageContext: pageContext, andIndoorLevel: level)
  }
  
  @objc public func setActiveLevel(_ value: TiGooglemapsIndoorLevelProxy?) {
    guard let level = value?.indoorLevel() else { return }
    indoorDisplay?.activeLevel = level
  }
  
  // MARK: - GMSIndoorDisplayDelegate
  
  public func didChangeActiveLevel(_ indoorLevel: GMSIndoorLevel?)
  {
    guard _hasListeners("didChangeActiveLevel"), let indoorLevel else { return }
    
    let levelProxy = TiGooglemapsIndoorLevelProxy()._init(withPageContext: pageContext, andIndoorLevel: indoorLevel)
    fireEvent("didChangeActiveLevel", with: ["level": levelProxy as Any])
  }
  
  public func didChangeActiveBuilding(_ building: GMSIndoorBuilding?) {
    guard _hasListeners("didChangeActiveBuilding"), let building else { return }
    fireEvent("didChangeActiveBuilding", with: dictionary(from: building))
  }
  
  // MARK: - Utilities
  
  private func dictionary(from building: GMSIndoorBuilding) -> [String: Any] {
    let levels: [Any] = building.levels.compactMap { level in
      return TiGooglemapsIndoorLevelProxy()._init(withPageContext: pageContext, andIndoorLevel: level)
    }
    
    return [
      "defaultLevelIndex": building.defaultLevelIndex,
      "isUnderground": building.isUnderground,
      "levels": levels
    ]
  }
}
