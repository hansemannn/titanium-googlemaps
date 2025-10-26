//
//  TiGooglemapsViewProxy.swift
//  titanium-googlemaps
//
//  Created by Your Name
//

import UIKit
import TitaniumKit
import GoogleMaps
import GoogleMapsUtils
import CoreLocation
import QuartzCore

private let ln2: CGFloat = 0.6931471805599453

@objc(TiGooglemapsViewProxy)
class TiGooglemapsViewProxy: TiViewProxy {
  private var markerStorage: [TiGooglemapsAnnotationProxy] = []
  private var overlayStorage: [TiProxy] = []
  private let markerQueue = DispatchQueue(label: "ti.googlemaps-annotation-queue", attributes: .concurrent)
  private let overlayQueue = DispatchQueue(label: "ti.googlemaps-overlay-queue", attributes: .concurrent)
  
  override func _init(withPageContext context: TiEvaluator!) -> Self? {
    _ = super._init(withPageContext: context)
    return self
  }
  
  private var googlemapsView: TiGooglemapsView? {
    return view as? TiGooglemapsView
  }
  
  @objc(mapView)
  func mapView() -> TiGooglemapsView? {
    return googlemapsView
  }
  
  internal var markersCopy: [TiGooglemapsAnnotationProxy] {
    return markerQueue.sync { markerStorage }
  }
  
  internal var overlaysCopy: [TiProxy] {
    return overlayQueue.sync { overlayStorage }
  }
  
  @objc func markers() -> [TiGooglemapsAnnotationProxy] {
    return markersCopy
  }
  
  @objc func overlays() -> [TiProxy] {
    return overlaysCopy
  }
  
  private func performOnMainThread(wait: Bool = false, _ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, wait)
    }
  }
  
  private func withMapView(_ block: @escaping (GMSMapView) -> Void) {
    guard let mapView = googlemapsView?.mapView else { return }
    performOnMainThread {
      block(mapView)
    }
  }
  
  private func replaceStoredValue(_ value: Any?, forKey key: String) {
    replaceValue(value, forKey: key, notification: false)
  }
  
  private func markerBarrier(_ block: @escaping () -> Void) {
    markerQueue.async(flags: .barrier, execute: block)
  }
  
  private func overlayBarrier(_ block: @escaping () -> Void) {
    overlayQueue.async(flags: .barrier, execute: block)
  }
  
  private func castArray<T>(_ value: Any?) -> [T] {
    if let typed = value as? [T] {
      return typed
    }
    if let array = value as? [Any] {
      return array.compactMap { $0 as? T }
    }
    return []
  }
  
  // MARK: - Settings
  
  @objc(setMyLocationButton:)
  func setMyLocationButton(value: Any?) {
    withMapView { mapView in
      mapView.settings.myLocationButton = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "myLocationButton")
  }
  
  @objc(setCompassButton:)
  func setCompassButton(value: Any?) {
    withMapView { mapView in
      mapView.settings.compassButton = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "compassButton")
  }
  
  @objc(setIndoorPicker:)
  func setIndoorPicker(value: Any?) {
    withMapView { mapView in
      mapView.settings.indoorPicker = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "indoorPicker")
  }
  
  @objc(setIndoorEnabled:)
  func setIndoorEnabled(value: Any?) {
    withMapView { mapView in
      mapView.isIndoorEnabled = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "indoorEnabled")
  }
  
  @objc(setScrollGestures:)
  func setScrollGestures(value: Any?) {
    withMapView { mapView in
      mapView.settings.scrollGestures = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "scrollGestures")
  }
  
  @objc(setZoomGestures:)
  func setZoomGestures(value: Any?) {
    withMapView { mapView in
      mapView.settings.zoomGestures = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "zoomGestures")
  }
  
  @objc(setTiltGestures:)
  func setTiltGestures(value: Any?) {
    withMapView { mapView in
      mapView.settings.tiltGestures = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "tiltGestures")
  }
  
  @objc(setRotateGestures:)
  func setRotateGestures(value: Any?) {
    withMapView { mapView in
      mapView.settings.rotateGestures = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "rotateGestures")
  }
  
  @objc(setConsumesGesturesInView:)
  func setConsumesGesturesInView(value: Any?) {
    withMapView { mapView in
      mapView.settings.consumesGesturesInView = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "consumesGesturesInView")
  }
  
  @objc(setAllowScrollGesturesDuringRotateOrZoom:)
  func setAllowScrollGesturesDuringRotateOrZoom(value: Any?) {
    withMapView { mapView in
      mapView.settings.allowScrollGesturesDuringRotateOrZoom = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "allowScrollGesturesDuringRotateOrZoom")
  }
  
  @objc(setMyLocationEnabled:)
  func setMyLocationEnabled(value: Any?) {
    withMapView { mapView in
      mapView.isMyLocationEnabled = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "myLocationEnabled")
  }
  
  @objc(setMapType:)
  func setMapType(value: Any?) {
    withMapView { mapView in
      let defaultMapType = Int32(GMSMapViewType.normal.rawValue)
      let rawValue = UInt(TiUtils.intValue(value, def: defaultMapType))
      mapView.mapType = GMSMapViewType(rawValue: rawValue) ?? GMSMapViewType.normal
    }
    
    replaceStoredValue(value, forKey: "mapType")
  }
  
  @objc(setTrafficEnabled:)
  func setTrafficEnabled(value: Any?) {
    withMapView { mapView in
      mapView.isTrafficEnabled = TiUtils.boolValue(value)
    }
    
    replaceStoredValue(value, forKey: "trafficEnabled")
  }
  
  @objc(setPadding:)
  func setPadding(args: [String: Any]) {
    withMapView { mapView in
      let padding = TiUtils.contentInsets(args)
      mapView.padding = padding
    }
    
    replaceStoredValue(args, forKey: "padding")
  }
  
  // MARK: - Region / Location
  
  @objc(setRegion:)
  func setRegion(args: [String: Any]) {
    let latitude = TiUtils.floatValue(args["latitude"])
    let longitude = TiUtils.floatValue(args["longitude"])
    let longitudeDelta = TiUtils.floatValue(args["longitudeDelta"], def: -1)
    var zoom = TiUtils.floatValue(args["zoom"], def: 1)
    let bearing = TiUtils.floatValue(args["bearing"], def: 0)
    let viewingAngle = TiUtils.floatValue(args["viewingAngle"], def: 0)
    
    if args["zoom"] == nil && longitudeDelta != -1 {
      zoom = round(log(360 / longitudeDelta) / ln2)
    } else if args["zoom"] != nil && longitudeDelta != -1 {
      NSLog("[WARN] Found both `zoomLevel` and `longitudeDelta` properties. Please use either one. Using `zoom` for backwards compatibility …")
    }
    
    let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude),
                                          longitude: CLLocationDegrees(longitude),
                                          zoom: Float(zoom),
                                          bearing: CLLocationDirection(bearing),
                                          viewingAngle: CLLocationDirection(viewingAngle))
    
    withMapView { mapView in
      mapView.camera = camera
    }
    
    replaceStoredValue(args, forKey: "region")
  }
  
  @objc(setLocation:)
  func setLocation(args: [String: Any]) {
    let latitude = TiUtils.floatValue(args["latitude"])
    let longitude = TiUtils.floatValue(args["longitude"])
    let longitudeDelta = TiUtils.floatValue(args["longitudeDelta"], def: -1)
    let zoom = TiUtils.floatValue(args["zoom"], def: -1)
    let animate = (args["animate"] as? Bool) ?? true
    
    let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    
    let update: GMSCameraUpdate
    if longitudeDelta != -1 {
      update = GMSCameraUpdate.setTarget(coordinate, zoom: Float(round(log(360 / longitudeDelta) / ln2)))
    } else if zoom != -1 {
      update = GMSCameraUpdate.setTarget(coordinate, zoom: Float(zoom))
    } else {
      update = GMSCameraUpdate.setTarget(coordinate)
    }
    
    withMapView { mapView in
      if animate {
        mapView.animate(with: update)
      } else {
        mapView.moveCamera(update)
      }
    }
  }
  
  @objc(setPaddingAdjustmentBehavior:)
  func setPaddingAdjustmentBehavior(value: Any?) {
    withMapView { mapView in
      mapView.paddingAdjustmentBehavior = GMSMapViewPaddingAdjustmentBehavior(rawValue: UInt(TiUtils.intValue(value))) ?? .never
    }
  }
  
  @objc(paddingAdjustmentBehavior)
  func paddingAdjustmentBehavior() -> NSNumber? {
    guard let mapView = googlemapsView?.mapView else { return nil }
    return NSNumber(value: mapView.paddingAdjustmentBehavior.rawValue)
  }
  
  @objc(setMapStyle:)
  func setMapStyle(value: Any?) {
    guard let value = value else {
      withMapView { $0.mapStyle = nil }
      return
    }
    
    withMapView { mapView in
      guard let string = value as? String else {
        NSLog("[ERROR] Invalid map-style provided. Use either a raw JSON string or a path to your JSON file instead!")
        return
      }
      
      var style: GMSMapStyle?
      
      if URL(fileURLWithPath: string).pathExtension == "json" {
        if let url = TiUtils.toURL(string, proxy: self) {
          style = try? GMSMapStyle(contentsOfFileURL: url)
        }
      } else {
        style = try? GMSMapStyle(jsonString: TiUtils.stringValue(value))
      }

      mapView.mapStyle = style
    }
  }
  
  // MARK: - Camera actions
  
  @objc(moveCamera:)
  func moveCamera(value: TiGooglemapsCameraUpdateProxy) {
    withMapView { mapView in
      if let cameraUpdate = value.cameraUpdate() {
        mapView.moveCamera(cameraUpdate)
      }
    }
  }
  
  @objc(animateWithCameraUpdate:)
  func animateWithCameraUpdate(value: TiGooglemapsCameraUpdateProxy) {
    withMapView { mapView in
      if let cameraUpdate = value.cameraUpdate() {
        mapView.animate(with: cameraUpdate)
      }
    }
  }
  
  // MARK: - Clustering
  
  @objc(cluster:)
  func cluster(_ unused: Any?) {
    performOnMainThread {
      self.googlemapsView?.clusterManager.cluster()
    }
  }
  
  @objc(addClusterItem:)
  func addClusterItem(_ args: [Any]) {
    guard let clusterItemProxy = args.first as? TiGooglemapsClusterItemProxy,
          let clusterItem = clusterItemProxy.clusterItem() else {
      return
    }
    
    performOnMainThread {
      self.googlemapsView?.clusterManager.add(clusterItem)
    }
  }
  
  @objc(addClusterItems:)
  func addClusterItems(_ args: [Any]) {
    let items: [TiGooglemapsClusterItemProxy] = castArray(args.first)
    let nativeItems = items.compactMap { $0.clusterItem() }
    performOnMainThread {
      guard let clusterManager = self.googlemapsView?.clusterManager else { return }
      nativeItems.forEach { clusterManager.add($0) }
    }
  }
  
  @objc(setClusterItems:)
  func setClusterItems(_ args: [Any]) {
    performOnMainThread {
      self.googlemapsView?.clusterManager.clearItems()
      self.addClusterItems(args)
    }
  }
  
  @objc(removeClusterItem:)
  func removeClusterItem(_ args: [Any]) {
    guard let clusterItemProxy = args.first as? TiGooglemapsClusterItemProxy,
          let clusterItem = clusterItemProxy.clusterItem() else {
      return
    }
    
    performOnMainThread {
      self.googlemapsView?.clusterManager.remove(clusterItem)
    }
  }
  
  @objc(clearClusterItems:)
  func clearClusterItems(_ unused: Any?) {
    performOnMainThread {
      self.googlemapsView?.clusterManager.clearItems()
    }
  }
  
  // MARK: - Annotation management
  
  @objc(addAnnotation:)
  func addAnnotation(_ args: [Any]) {
    guard let annotationProxy = args.first as? TiGooglemapsAnnotationProxy else { return }
    
    markerBarrier { [weak self] in
      guard let self = self else { return }
      self.markerStorage.append(annotationProxy)
      
      DispatchQueue.main.async { [weak self] in
        guard let mapView = self?.googlemapsView?.mapView else { return }
        annotationProxy.marker.map = mapView
      }
    }
  }
  
  @objc(addAnnotations:)
  func addAnnotations(_ args: [Any]) {
    let annotations: [TiGooglemapsAnnotationProxy] = castArray(args.first)
    annotations.forEach { addAnnotation([$0]) }
  }
  
  @objc(removeAnnotation:)
  func removeAnnotation(_ args: [Any]) {
    guard let annotationProxy = args.first as? TiGooglemapsAnnotationProxy else { return }
    
    markerBarrier { [weak self] in
      guard let self = self else { return }
      self.markerStorage.removeAll { $0 === annotationProxy }
      
      DispatchQueue.main.async {
        annotationProxy.marker.map = nil
      }
    }
  }
  
  @objc(removeAnnotations:)
  func removeAnnotations(_ args: [Any]) {
    let annotations: [TiGooglemapsAnnotationProxy] = castArray(args.first)
    annotations.forEach { removeAnnotation([$0]) }
  }
  
  @objc(removeAllAnnotations:)
  func removeAllAnnotations(_ args: Any?) {
    markerBarrier { [weak self] in
      guard let self = self else { return }
      self.markerStorage.removeAll()
      
      DispatchQueue.main.async { [weak self] in
        self?.googlemapsView?.mapView.clear()
      }
    }
  }
  
  @objc(setAnnotations:)
  func setAnnotations(_ args: [Any]) {
    let annotations: [TiGooglemapsAnnotationProxy] = castArray(args.first)

    markerBarrier { [weak self] in
      guard let self = self else { return }
      for annotation in self.markerStorage {
        DispatchQueue.main.async {
          annotation.marker.map = nil
        }
      }
      self.markerStorage.removeAll()
    }
    
    addAnnotations([annotations])
  }
  
  // MARK: - Polylines / Polygons / Circles
  
  @objc(addPolyline:)
  func addPolyline(_ args: [Any]) {
    guard let polylineProxy = args.first as? TiGooglemapsPolylineProxy else { return }
    
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.append(polylineProxy)
      
      DispatchQueue.main.async { [weak self] in
        guard let mapView = self?.googlemapsView?.mapView else { return }
        polylineProxy.polyline().map = mapView
      }
    }
  }
  
  @objc(removeAllPolylines:)
  func removeAllPolylines(_ args: Any?) {
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.removeAll { proxy in
        guard let polylineProxy = proxy as? TiGooglemapsPolylineProxy else { return false }
        DispatchQueue.main.async {
          polylineProxy.polyline().map = nil
        }
        return true
      }
    }
  }
  
  @objc(removePolyline:)
  func removePolyline(_ args: [Any]) {
    guard let polylineProxy = args.first as? TiGooglemapsPolylineProxy else { return }
    
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.removeAll { $0 === polylineProxy }
      
      DispatchQueue.main.async {
        polylineProxy.polyline().map = nil
      }
    }
  }
  
  @objc(addPolygon:)
  func addPolygon(_ args: [Any]) {
    guard let polygonProxy = args.first as? TiGooglemapsPolygonProxy else { return }
    
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.append(polygonProxy)
      
      DispatchQueue.main.async { [weak self] in
        guard let mapView = self?.googlemapsView?.mapView else { return }
        polygonProxy.polygon().map = mapView
      }
    }
  }
  
  @objc(removeAllPolygons:)
  func removeAllPolygons(_ args: Any?) {
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.removeAll { proxy in
        guard let polygonProxy = proxy as? TiGooglemapsPolygonProxy else { return false }
        DispatchQueue.main.async {
          polygonProxy.polygon().map = nil
        }
        return true
      }
    }
  }
  
  @objc(removePolygon:)
  func removePolygon(_ args: [Any]) {
    guard let polygonProxy = args.first as? TiGooglemapsPolygonProxy else { return }
    
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.removeAll { $0 === polygonProxy }
      
      DispatchQueue.main.async {
        polygonProxy.polygon().map = nil
      }
    }
  }
  
  @objc(addCircle:)
  func addCircle(_ args: [Any]) {
    guard let circleProxy = args.first as? TiGooglemapsCircleProxy else { return }
    
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.append(circleProxy)
      
      DispatchQueue.main.async { [weak self] in
        guard let mapView = self?.googlemapsView?.mapView else { return }
        circleProxy.circle().map = mapView
      }
    }
  }
  
  @objc(removeAllCircles:)
  func removeAllCircles(_ args: Any?) {
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.removeAll { proxy in
        guard let circleProxy = proxy as? TiGooglemapsCircleProxy else { return false }
        DispatchQueue.main.async {
          circleProxy.circle().map = nil
        }
        return true
      }
    }
  }
  
  @objc(removeCircle:)
  func removeCircle(_ args: [Any]) {
    guard let circleProxy = args.first as? TiGooglemapsCircleProxy else { return }
    
    overlayBarrier { [weak self] in
      guard let self = self else { return }
      self.overlayStorage.removeAll { $0 === circleProxy }
      
      DispatchQueue.main.async {
        circleProxy.circle().map = nil
      }
    }
  }
  
  @objc(addTile:)
  func addTile(_ args: [Any]) {
    guard let tileProxy = args.first as? TiGooglemapsTileProxy else { return }
    withMapView { mapView in
      tileProxy.tile().map = mapView
    }
  }
  
  @objc(removeTile:)
  func removeTile(_ args: [Any]) {
    guard let tileProxy = args.first as? TiGooglemapsTileProxy else { return }
    tileProxy.tile().map = nil
  }
  
  @objc(addHeatmapLayer:)
  func addHeatmapLayer(_ args: [Any]) {
    guard let heatmapProxy = args.first as? TiGooglemapsHeatmapLayerProxy else { return }
    withMapView { mapView in
      heatmapProxy.heatmapLayer().map = mapView
    }
  }
  
  @objc(removeHeatmapLayer:)
  func removeHeatmapLayer(_ args: [Any]) {
    guard let heatmapProxy = args.first as? TiGooglemapsHeatmapLayerProxy else { return }
    heatmapProxy.heatmapLayer().map = nil
  }
  
  // MARK: - Selection
  
  @objc(selectedAnnotation:)
  func selectedAnnotation(_ unused: Any?) -> TiGooglemapsAnnotationProxy? {
    guard let selectedMarker = googlemapsView?.mapView.selectedMarker else { return nil }
    return markersCopy.first { $0.marker === selectedMarker }
  }
  
  @objc(selectAnnotation:)
  func selectAnnotation(_ value: [Any]) {
    guard let annotationProxy = value.first as? TiGooglemapsAnnotationProxy else { return }
    googlemapsView?.mapView.selectedMarker = annotationProxy.marker
  }
  
  @objc(deselectAnnotation:)
  func deselectAnnotation(_ unused: Any?) {
    googlemapsView?.mapView.selectedMarker = nil
  }
  
  // MARK: - Animations
  
  @objc(animateToLocation:)
  func animateToLocation(_ args: [Any]) {
    guard let params = args.first as? [String: Any] else { return }
    
    let latitude = TiUtils.doubleValue(params["latitude"])
    let longitude = TiUtils.doubleValue(params["longitude"])
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    guard CLLocationCoordinate2DIsValid(coordinate) else {
      NSLog("[ERROR] Ti.GoogleMaps: Invalid location provided. Please check your latitude and longitude.")
      return
    }
    
    performOnMainThread {
      self.googlemapsView?.mapView.animate(toLocation: coordinate)
    }
  }
  
  @objc(animateToZoom:)
  func animateToZoom(_ args: [Any]) {
    guard let zoomValue = args.first else { return }
    let zoomLevel = CGFloat(TiUtils.floatValue(zoomValue))
    
    performOnMainThread {
      guard let mapView = self.googlemapsView?.mapView else { return }
      
      if args.count == 2 {
        let duration = CGFloat(TiUtils.floatValue(args[1])) / 1000
        let centerPoint = mapView.center
        let location = mapView.projection.coordinate(for: centerPoint)
        
        CATransaction.begin()
        CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: Float(zoomLevel))
        mapView.animate(to: camera)
        CATransaction.commit()
      } else {
        mapView.animate(toZoom: Float(zoomLevel))
      }
    }
  }
  
  @objc(animateToBearing:)
  func animateToBearing(_ args: [Any]) {
    guard args.count >= 1 else { return }
    let bearing = TiUtils.doubleValue(args[0])
    performOnMainThread {
      self.googlemapsView?.mapView.animate(toBearing: bearing)
    }
  }
  
  @objc(animateToViewingAngle:)
  func animateToViewingAngle(_ args: [Any]) {
    guard args.count >= 1 else { return }
    let angle = TiUtils.doubleValue(args[0])
    performOnMainThread {
      self.googlemapsView?.mapView.animate(toViewingAngle: angle)
    }
  }
  
  @objc(indoorDisplay:)
  func indoorDisplay(_ unused: Any?) -> TiGooglemapsIndoorDisplayProxy? {
    var result: TiGooglemapsIndoorDisplayProxy?
    
    TiThreadPerformOnMainThread({
      guard let mapView = self.googlemapsView?.mapView else { return }
      result = TiGooglemapsIndoorDisplayProxy()._init(withPageContext: self.pageContext, andIndoorDisplay: mapView.indoorDisplay)
    }, true)
    
    return result
  }
  
  @objc(containsCoordinate:)
  func containsCoordinate(_ annotation: [String: Any]) -> NSNumber? {
    guard let mapView = googlemapsView?.mapView else { return NSNumber(value: false) }
    let latitude = TiUtils.doubleValue(annotation["latitude"])
    let longitude = TiUtils.doubleValue(annotation["longitude"])
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    let region = mapView.projection.visibleRegion
    let bounds = GMSCoordinateBounds(region: region())
    return NSNumber(value: bounds.contains(coordinate))
  }
  
  @objc(coordinateForPoint:)
  func coordinateForPoint(_ value: [String: Any]) -> [String: Any]? {
    guard let mapView = googlemapsView?.mapView else { return nil }
    let point = TiUtils.pointValue(value)
    let coordinate = mapView.projection.coordinate(for: point)
    
    return [
      "latitude": coordinate.latitude,
      "longitude": coordinate.longitude
    ]
  }
  
  @objc(showAnnotations:)
  func showAnnotations(_ args: [Any]) {
    performOnMainThread {
      guard let mapView = self.googlemapsView?.mapView else { return }
      
      var padding: CGFloat = 40
      var animated = false
      var markersToUse: [GMSMarker] = []
      
      let annotations: [TiGooglemapsAnnotationProxy] = self.castArray(args.first)
      if !annotations.isEmpty {
        markersToUse = annotations.compactMap { $0.marker }
      } else {
        markersToUse = self.markersCopy.compactMap { $0.marker }
      }
      
      if args.count > 1 {
        padding = CGFloat(TiUtils.floatValue(args[1]))
      }
      
      if args.count > 2 {
        animated = TiUtils.boolValue(args[2])
      }
      
      var bounds = GMSCoordinateBounds()
      for marker in markersToUse {
        bounds = bounds.includingCoordinate(marker.position)
      }
      
      let update = GMSCameraUpdate.fit(bounds, withPadding: padding)
      
      if animated {
        mapView.animate(with: update)
      } else {
        mapView.moveCamera(update)
      }
    }
  }
  
  @objc(drawRoundedPolylineBetweenCoordinates:)
  func drawRoundedPolylineBetweenCoordinates(_ args: [String: Any]) -> [String: Any]? {
    guard let coordinates = args["coordinates"] as? [[String: NSNumber]],
          coordinates.count == 2 else {
      return nil
    }
    
    let options = args["options"] as? [String: Any] ?? [:]
    
    let startDict = coordinates[0]
    let endDict = coordinates[1]
    
    let startLocation = CLLocationCoordinate2D(latitude: TiUtils.doubleValue(startDict["latitude"]),
                                               longitude: TiUtils.doubleValue(startDict["longitude"]))
    let endLocation = CLLocationCoordinate2D(latitude: TiUtils.doubleValue(endDict["latitude"]),
                                             longitude: TiUtils.doubleValue(endDict["longitude"]))
    
    var result: [String: Any]?
    performOnMainThread(wait: true) {
      guard let mapView = self.googlemapsView?.mapView else { return }
      
      let path = GMSMutablePath()
      let distance = GMSGeometryDistance(startLocation, endLocation)
      let midPoint = GMSGeometryInterpolate(startLocation, endLocation, 0.5)
      let heading = GMSGeometryHeading(midPoint, startLocation)
      let controlPointAngle = 360.0 - (90.0 - heading)
      let controlPoint = GMSGeometryOffset(midPoint, distance / 2.0, controlPointAngle)
      
      var midCoordinate = CLLocationCoordinate2D()
      let step: Double = 0.05
      var t: Double = 0.0
      var coords: [CLLocationCoordinate2D] = []
      
      while t < 1.0 {
        let t1 = 1.0 - t
        let latitude = t1 * t1 * startLocation.latitude +
          2 * t1 * t * controlPoint.latitude +
          t * t * endLocation.latitude
        let longitude = t1 * t1 * startLocation.longitude +
          2 * t1 * t * controlPoint.longitude +
          t * t * endLocation.longitude
        let point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        coords.append(point)
        t += step
      }
      
      for (idx, coordinate) in coords.enumerated() {
        path.add(coordinate)
        if idx == coords.count / 2 {
          midCoordinate = coordinate
        }
      }
      
      let polyline = GMSPolyline(path: path)
      polyline.strokeWidth = 2.0
      let gradient = GMSStrokeStyle.gradient(from: .clear, to: .black)
      polyline.spans = [GMSStyleSpan(style: gradient)]
      polyline.map = mapView
      
      let bounds = GMSCoordinateBounds(coordinate: startLocation, coordinate: endLocation)
      let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      
      if TiUtils.boolValue("animate", properties: options) {
        if let camera = mapView.camera(for: bounds, insets: insets) {
          mapView.animate(to: camera)
        }
      } else {
        mapView.moveCamera(GMSCameraUpdate.fit(bounds, with: insets))
      }
      
      result = [
        "latitude": midCoordinate.latitude,
        "longitude": midCoordinate.longitude
      ]
    }
    
    return result
  }
  
  // MARK: - Accessors
  
  @objc(annotations)
  func annotations() -> [TiGooglemapsAnnotationProxy] {
    return markersCopy
  }
  
  @objc(polylines)
  func polylines() -> [TiGooglemapsPolylineProxy] {
    return overlaysCopy.compactMap { $0 as? TiGooglemapsPolylineProxy }
  }
  
  @objc(polygons)
  func polygons() -> [TiGooglemapsPolygonProxy] {
    return overlaysCopy.compactMap { $0 as? TiGooglemapsPolygonProxy }
  }
  
  @objc(circles)
  func circles() -> [TiGooglemapsCircleProxy] {
    return overlaysCopy.compactMap { $0 as? TiGooglemapsCircleProxy }
  }
  
  @objc(zoom)
  func zoom() -> NSNumber? {
    NSLog("[WARN] Map.View.zoom is deprecated since 5.4.1 in favor of Map.View.zoomLevel")
    return zoomLevel()
  }
  
  @objc(zoomLevel)
  func zoomLevel() -> NSNumber? {
    guard let mapView = googlemapsView?.mapView else { return nil }
    return NSNumber(value: mapView.camera.zoom)
  }
  
  @objc(setClusterConfiguration:)
  func setClusterConfiguration(_ configuration: [String: Any]) {
    let ranges = configuration["ranges"] as? [NSNumber]
    let backgrounds = configuration["rangeBackgrounds"] as? [String]
    let minimumClusterSize = TiUtils.intValue(configuration["minimumClusterSize"], def: 4)
    let maximumClusterZoom = TiUtils.intValue(configuration["maximumClusterZoom"], def: 20)
    let animationDuration = configuration["animationDuration"] as? Double ?? 0.5
    
    if let renderer = googlemapsView?.clusterRenderer {
      renderer.minimumClusterSize = UInt(minimumClusterSize)
      renderer.maximumClusterZoom = UInt(maximumClusterZoom)
      renderer.animationDuration = animationDuration
    }
    
    replaceStoredValue(ranges, forKey: "clusterRanges")
    replaceStoredValue(backgrounds, forKey: "clusterBackgrounds")
  }
  
  @objc(takeSnapshot:)
  func takeSnapshot(_ size: [String: Any]) -> TiBlob? {
    let width = CGFloat(TiUtils.floatValue(size["width"]))
    let height = CGFloat(TiUtils.floatValue(size["height"]))
    let renderSize = CGSize(width: width, height: height)
    
    guard renderSize.width > 0, renderSize.height > 0 else { return nil }
    guard let mapContainer = googlemapsView else { return nil }
    
    let renderer = UIGraphicsImageRenderer(size: renderSize)
    var snapshot: UIImage?
    performOnMainThread(wait: true) {
      snapshot = renderer.image { _ in
        mapContainer.drawHierarchy(in: mapContainer.bounds, afterScreenUpdates: true)
      }
    }
    
    guard let image = snapshot else { return nil }
    return TiBlob(image: image)
  }
}
