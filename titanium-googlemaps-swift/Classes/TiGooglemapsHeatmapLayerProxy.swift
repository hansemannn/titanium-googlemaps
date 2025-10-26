/**
 * Axway Titanium
 * Copyright (c) 2018-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

import UIKit
import TitaniumKit
import GoogleMapsUtils
import CoreLocation

@objc(TiGooglemapsHeatmapLayerProxy)
public class TiGooglemapsHeatmapLayerProxy: TiProxy {
  private var layer: GMUHeatmapTileLayer!
  
  public override func _init(withPageContext context: TiEvaluator!) -> Self? {
    let proxy = super._init(withPageContext: context)
    layer = GMUHeatmapTileLayer()
    return proxy
  }
  
  @objc public func heatmapLayer() -> GMUHeatmapTileLayer {
    return layer
  }
  
  @objc public func setGradient(_ value: [String: Any]) {
    let colorValues = value["colors"] as? [Any] ?? []
    let colors = colorValues.compactMap { TiUtils.colorValue($0)?.color }
    let startPoints = value["startPoints"] as? [NSNumber] ?? []
    let colorMapSize = UInt(TiUtils.intValue("colorMapSize", properties: value, def: 256))
    
    let gradientColors = colors.isEmpty ? [UIColor.green, UIColor.red] : colors
    let gradient = GMUGradient(colors: gradientColors, startPoints: startPoints, colorMapSize: colorMapSize)
    layer.gradient = gradient
  }
  
  @objc public func setRadius(_ value: NSNumber?) {
    layer.radius = UInt(TiUtils.intValue(value))
  }
  
  @objc public func setOpacity(_ value: NSNumber?) {
    layer.opacity = Float(TiUtils.floatValue(value))
  }
  
  @objc public func setWeightedData(_ value: [[String: Any]]) {
    let weightedData: [GMUWeightedLatLng] = value.compactMap { entry in
      let latitude = TiUtils.doubleValue("latitude", properties: entry)
      let longitude = TiUtils.doubleValue("longitude", properties: entry)
      let intensity = TiUtils.floatValue("intensity", properties: entry)
      let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      return GMUWeightedLatLng(coordinate: coordinate, intensity: intensity)
    }
    
    layer.weightedData = weightedData
  }
}
