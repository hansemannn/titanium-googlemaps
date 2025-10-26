/**
 * Axway Titanium
 */

import Foundation
import TitaniumKit
import GoogleMaps
import GoogleMapsUtils

@objc(TiGooglemapsRendererProxy)
public class TiGooglemapsRendererProxy: TiProxy {
  private var geometryRenderer: GMUGeometryRenderer?
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  private func rendererInstance() -> GMUGeometryRenderer? {
    if let renderer = geometryRenderer {
      return renderer
    }
    
    guard let mapViewProxy = value(forKey: "mapView") as? TiGooglemapsViewProxy,
          let tiView = mapViewProxy.mapView(),
          let file = value(forKey: "file") as? String,
          let url = TiUtils.toURL(file, proxy: self) else {
      return nil
    }
    
    let parser = GMUKMLParser(url: url)
    parser.parse()
    
    let renderer = GMUGeometryRenderer(map: tiView.mapView,
                                       geometries: parser.placemarks,
                                       styles: parser.styles)
    geometryRenderer = renderer
    return renderer
  }
  
  @objc public func setMapView(_ value: Any?) {
    replaceValue(value ?? NSNull(), forKey: "mapView", notification: false)
    geometryRenderer = nil
  }
  
  @objc public func setFile(_ value: Any?) {
    replaceValue(value ?? NSNull(), forKey: "file", notification: false)
    geometryRenderer = nil
  }
  
  @objc public func render(_ unused: Any?) {
    runOnMainThread {
      self.rendererInstance()?.render()
    }
  }
  
  @objc public func clear(_ unused: Any?) {
    runOnMainThread {
      self.rendererInstance()?.clear()
    }
  }
}
