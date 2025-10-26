//
//  TiGooglemapsView.swift
//  titanium-googlemaps
//
//  Created by Your Name
//

import UIKit
import TitaniumKit
import GoogleMaps
import GoogleMapsUtils

private let kGMUMyLocationKeyPath = "myLocation"

@objc(TiGooglemapsView)
class TiGooglemapsView: TiUIView, GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
  private var centerAnnotationOnTap = true
  
  private var mapViewStorage: GMSMapView?
  private var clusterManagerStorage: GMUClusterManager?
  private var clusterRendererStorage: TiClusterRenderer?
  
  @objc var mapView: GMSMapView {
    if let mapView = mapViewStorage {
      return mapView
    }
    
    let options = GMSMapViewOptions()
    options.frame = frame
    options.backgroundColor = .systemBackground
    
    let mapView = GMSMapView(options: options)
    mapView.mapType = GMSMapViewType.normal
    mapView.delegate = self
    mapView.autoresizingMask = []
    mapView.addObserver(self, forKeyPath: kGMUMyLocationKeyPath, options: .new, context: nil)
    
    addSubview(mapView)
    mapViewStorage = mapView
    centerAnnotationOnTap = true

    return mapView
  }
  
  @objc var clusterRenderer: TiClusterRenderer {
    if let renderer = clusterRendererStorage {
      return renderer
    }
    
    let iconGenerator = createIconGenerator()
    let renderer = TiClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    renderer.delegate = self
    clusterRendererStorage = renderer
    return renderer
  }
  
  @objc var clusterManager: GMUClusterManager {
    if let clusterManager = clusterManagerStorage {
      return clusterManager
    }
    
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let manager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: clusterRenderer)
    manager.setDelegate(self, mapDelegate: self)
    clusterManagerStorage = manager
    return manager
  }
  
  deinit {
    if let mapView = mapViewStorage {
      mapView.removeObserver(self, forKeyPath: kGMUMyLocationKeyPath)
      mapView.delegate = nil
    }
    
    clusterRendererStorage?.delegate = nil
  }
  
  private func createIconGenerator() -> TiClusterIconGenerator {
    guard let proxy = proxy else { return TiClusterIconGenerator() }
    
    let clusterRanges = proxy.value(forKey: "clusterRanges") as? [NSNumber]
    let clusterBackgrounds = proxy.value(forKey: "clusterBackgrounds") as? [Any]
    
    if let ranges = clusterRanges, let backgrounds = clusterBackgrounds {
      var images: [UIImage] = []
      for background in backgrounds {
        guard let image = TiUtils.image(background, proxy: proxy) else {
          NSLog("[ERROR] Cluster background-file (%@) cannot be found, skipping ...", "\(background)")
          continue
        }
        
        images.append(image)
      }
      
      return TiClusterIconGenerator(buckets: ranges, backgroundImages: images)
    } else if let ranges = clusterRanges {
      return TiClusterIconGenerator(buckets: ranges)
    }
    
    return TiClusterIconGenerator()
  }
  
  private var mapViewProxy: TiGooglemapsViewProxy? {
    return proxy as? TiGooglemapsViewProxy
  }
  
  override func frameSizeChanged(_ frame: CGRect, bounds: CGRect) {
    if let mapView = mapViewStorage {
      TiUtils.setView(mapView, positionRect: bounds)
    }
    
    super.frameSizeChanged(frame, bounds: bounds)
  }
  
  // MARK: - Cluster Delegates
  
  func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
    guard let item = marker.userData as? TiPOIItem else { return }
    
    marker.title = item.title
    marker.snippet = item.subtitle
    marker.icon = item.icon
  }
  
  func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
    guard let proxy = proxy else { return false }
    
    if proxy._hasListeners("clusterclick") {
      proxy.fireEvent("clusterclick", with: [
        "latitude": cluster.position.latitude,
        "longitude": cluster.position.longitude,
        "count": cluster.count,
        "clusterItems": arrayFromClusterItems(cluster.items)
      ])
    }
    
    let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
    mapView.moveCamera(GMSCameraUpdate.setCamera(newCamera))
    
    return true
  }
  
  func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
    guard let proxy = proxy else { return false }
    guard let poiItem = clusterItem as? TiPOIItem else { return false }
    
    if proxy._hasListeners("clusteritemclick") {
      proxy.fireEvent("clusteritemclick", with: [
        "latitude": clusterItem.position.latitude,
        "longitude": clusterItem.position.longitude,
        "title": poiItem.title ?? NSNull(),
        "subtitle": poiItem.subtitle ?? NSNull(),
        "userData": poiItem.userData ?? NSNull()
      ] as [String: Any])
    }
    
    return true
  }
  
  // MARK: - Map View Delegates
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    guard let proxy = proxy, proxy._hasListeners("regionwillchange") else { return }
    
    proxy.fireEvent("regionwillchange", with: [
      "map": proxy,
      "latitude": mapView.camera.target.latitude,
      "longitude": mapView.camera.target.longitude,
      "gesture": gesture
    ])
  }
  
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    guard let proxy = proxy, proxy._hasListeners("regionchanged") else { return }
    
    var updatedRegion: [String: Any] = [
      "latitude": position.target.latitude,
      "longitude": position.target.longitude,
      "zoom": position.zoom,
      "bearing": position.bearing,
      "viewingAngle": position.viewingAngle
    ]
    
    (proxy as? TiGooglemapsViewProxy)?.replaceValue(updatedRegion, forKey: "region", notification: false)
    updatedRegion["map"] = proxy
    
    proxy.fireEvent("regionchanged", with: updatedRegion)
  }
  
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    guard let proxy = proxy, proxy._hasListeners("idle") else { return }
    proxy.fireEvent("idle", with: dictionaryFromCameraPosition(position))
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    guard let proxy = proxy, proxy._hasListeners("mapclick") else { return }
    proxy.fireEvent("mapclick", with: [
      "map": proxy,
      "latitude": coordinate.latitude,
      "longitude": coordinate.longitude
    ])
  }
  
  func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    guard let proxy = proxy, proxy._hasListeners("longclick") else { return }
    proxy.fireEvent("longclick", with: [
      "map": proxy,
      "latitude": coordinate.latitude,
      "longitude": coordinate.longitude
    ])
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let proxy = proxy else { return centerAnnotationOnTap }
    
    if proxy._hasListeners("click") {
      proxy.fireEvent("click", with: [
        "clicksource": "pin",
        "annotation": dictionaryFromMarker(marker),
        "map": proxy,
        "latitude": marker.position.latitude,
        "longitude": marker.position.longitude
      ])
    }
    
    return centerAnnotationOnTap
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    guard let proxy = proxy, proxy._hasListeners("click") else { return }
    proxy.fireEvent("click", with: [
      "clicksource": "infoWindow",
      "annotation": dictionaryFromMarker(marker),
      "map": proxy,
      "latitude": marker.position.latitude,
      "longitude": marker.position.longitude
    ])
  }
  
  func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
    guard let proxy = proxy else { return }
    
    if proxy._hasListeners("overlayclick") {
      proxy.fireEvent("overlayclick", with: [
        "overlay": overlayProxyFromOverlay(overlay)
      ])
    }
    
    if proxy._hasListeners("click") {
      proxy.fireEvent("click", with: [
        "clicksource": overlayTypeFromOverlay(overlay),
        "map": proxy,
        "overlay": overlayProxyFromOverlay(overlay)
      ])
    }
  }
  
  func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
    guard let proxy = proxy, proxy._hasListeners("poiclick") else { return }
    
    proxy.fireEvent("poiclick", with: [
      "placeID": placeID,
      "name": name,
      "latitude": location.latitude,
      "longitude": location.longitude
    ])
  }
  
  func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
    guard let proxy = proxy, proxy._hasListeners("dragstart") else { return }
    proxy.fireEvent("dragstart", with: ["annotation": dictionaryFromMarker(marker)])
  }
  
  func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
    guard let proxy = proxy, proxy._hasListeners("dragend") else { return }
    proxy.fireEvent("dragend", with: ["annotation": dictionaryFromMarker(marker)])
  }
  
  func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
    guard let proxy = proxy, proxy._hasListeners("dragmove") else { return }
    proxy.fireEvent("dragmove", with: ["annotation": dictionaryFromMarker(marker)])
  }
  
  func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    guard let annotationProxies = mapViewProxy?.markersCopy else { return nil }
    let markerUUID = (marker.userData as? [String: Any])?["uuid"] as? String
    
    let annotation = annotationProxies.first { proxy in
      guard let proxyUUID = (proxy.marker.userData as? [String: Any])?["uuid"] as? String else { return false }
      return proxyUUID == markerUUID
    }
    
    guard let infoAnnotation = annotation, let infoWindowProxy = infoAnnotation.infoWindow() else {
      return nil
    }
    
    infoAnnotation.rememberSelf()
    return infoWindowProxy.view
  }
  
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    guard let proxy = proxy else { return false }
    
    if proxy._hasListeners("locationclick") {
      proxy.fireEvent("locationclick", with: ["map": proxy])
    }
    
    return false
  }
  
  func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    guard let proxy = proxy else { return }
    
    if proxy._hasListeners("complete") {
      proxy.fireEvent("complete")
    }
    
    if proxy._hasListeners("ready") {
      proxy.fireEvent("ready")
    }
  }
  
  // MARK: - Helpers
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    guard keyPath == kGMUMyLocationKeyPath else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }
    
    guard let location = mapView.myLocation else { return }
    proxy?.fireEvent("myLocationUpdate", with: [
      "latitude": location.coordinate.latitude,
      "longitude": location.coordinate.longitude
    ])
  }
  
  private func dictionaryFromCameraPosition(_ position: GMSCameraPosition?) -> [String: Any] {
    guard let position = position else { return [:] }
    
    return [
      "latitude": position.target.latitude,
      "longitude": position.target.longitude,
      "zoom": position.zoom,
      "viewingAngle": position.viewingAngle,
      "bearing": position.bearing
    ]
  }
  
  private func dictionaryFromMarker(_ marker: GMSMarker?) -> [String: Any] {
    guard let marker = marker else { return [:] }
    
    return [
      "latitude": marker.position.latitude,
      "longitude": marker.position.longitude,
      "userData": marker.userData ?? NSNull(),
      "title": marker.title ?? NSNull(),
      "subtitle": marker.snippet ?? NSNull()
    ]
  }
  
  private func overlayTypeFromOverlay(_ overlay: GMSOverlay?) -> NSNumber {
    guard let overlay = overlay else {
      return NSNumber(value: TiGooglemapsOverlayType.unknown.rawValue)
    }
    
    if overlay is GMSPolygon {
      return NSNumber(value: TiGooglemapsOverlayType.polygon.rawValue)
    } else if overlay is GMSPolyline {
      return NSNumber(value: TiGooglemapsOverlayType.polyline.rawValue)
    } else if overlay is GMSCircle {
      return NSNumber(value: TiGooglemapsOverlayType.circle.rawValue)
    }
    
    NSLog("[ERROR] Unknown overlay provided: %@", "\(type(of: overlay))")
    return NSNumber(value: TiGooglemapsOverlayType.unknown.rawValue)
  }
  
  private func overlayProxyFromOverlay(_ overlay: GMSOverlay) -> Any {
    guard let overlayProxies = mapViewProxy?.overlaysCopy else { return NSNull() }
    
    for proxy in overlayProxies {
      if let polygonProxy = proxy as? TiGooglemapsPolygonProxy,
         overlay === polygonProxy.polygon() {
        return polygonProxy
      } else if let polylineProxy = proxy as? TiGooglemapsPolylineProxy,
                overlay === polylineProxy.polyline() {
        return polylineProxy
      } else if let circleProxy = proxy as? TiGooglemapsCircleProxy,
                overlay === circleProxy.circle() {
        return circleProxy
      }
    }
    
    return NSNull()
  }
  
  private func arrayFromClusterItems(_ clusterItems: [GMUClusterItem]) -> [Any] {
    guard let context = proxy?.pageContext else { return [] }
    
    return clusterItems.compactMap { item in
      guard let poiItem = item as? TiPOIItem else { return nil }
     
      return TiGooglemapsClusterItemProxy()._init(
        withPageContext: context,
        andPosition: poiItem.position,
        title: poiItem.title,
        subtitle: poiItem.subtitle,
        icon: poiItem.icon,
        userData: poiItem.userData
      )
    }
  }
  
  @objc func setCenterAnnotationOnTap_(_ value: Any?) {
    centerAnnotationOnTap = TiUtils.boolValue(value)
  }
  
  @objc func OVERLAY_TYPE_POLYGON() -> NSNumber {
    return NSNumber(value: TiGooglemapsOverlayType.polygon.rawValue)
  }
  
  @objc func OVERLAY_TYPE_POLYLINE() -> NSNumber {
    return NSNumber(value: TiGooglemapsOverlayType.polyline.rawValue)
  }
  
  @objc func OVERLAY_TYPE_CIRCLE() -> NSNumber {
    return NSNumber(value: TiGooglemapsOverlayType.circle.rawValue)
  }
}
