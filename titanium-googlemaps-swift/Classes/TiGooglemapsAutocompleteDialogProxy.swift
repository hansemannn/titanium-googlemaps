/**
 * Axway Titanium
 */

import UIKit
import TitaniumKit
import GooglePlaces

@objc(TiGooglemapsAutocompleteDialogProxy)
public class TiGooglemapsAutocompleteDialogProxy: TiProxy, GMSAutocompleteViewControllerDelegate {
  private var autocompleteController: GMSAutocompleteViewController?
  
  private func controller() -> GMSAutocompleteViewController {
    if let controller = autocompleteController {
      return controller
    }
    
    let controller = GMSAutocompleteViewController()
    controller.delegate = self
    autocompleteController = controller
    return controller
  }
  
  private func resetController() {
    autocompleteController?.delegate = nil
    autocompleteController = nil
  }
  
  // MARK: - Public API
  
  @objc public func configure(_ value: String) {
    GMSPlacesClient.provideAPIKey(value)
  }
  
  @objc public func open(_ args: [String: Any]) {
    rememberSelf()
    
    runOnMainThread {
      let animated = TiUtils.boolValue(args["animated"], def: true)
      TiApp.sharedApp().showModalController(self.controller(), animated: animated)
    }
  }
  
  @objc public func setTableCellBackgroundColor(_ value: Any?) {
    controller().tableCellBackgroundColor = TiUtils.colorValue(value).color
  }
  
  @objc public func setTableCellSeparatorColor(_ value: Any?) {
    controller().tableCellSeparatorColor = TiUtils.colorValue(value).color
  }
  
  @objc public func setPrimaryTextColor(_ value: Any?) {
    controller().primaryTextColor = TiUtils.colorValue(value).color
  }
  
  @objc public func setPrimaryTextHighlightColor(_ value: Any?) {
    controller().primaryTextHighlightColor = TiUtils.colorValue(value).color
  }
  
  @objc public func setSecondaryTextColor(_ value: Any?) {
    controller().secondaryTextColor = TiUtils.colorValue(value).color
  }
  
  @objc public func setTintColor(_ value: Any?) {
    controller().tintColor = TiUtils.colorValue(value).color
  }
  
  // MARK: - Delegate
  
  public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    if _hasListeners("success") {
      fireEvent("success", with: ["place": Self.dictionary(from: place)])
    }
    
    closeDialog()
  }
  
  public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    if _hasListeners("error") {
      let nsError = error as NSError
      fireEvent("error", with: ["error": error.localizedDescription, "code": nsError.code])
    }
    
    closeDialog()
  }
  
  public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    if _hasListeners("cancel") {
      fireEvent("cancel", with: nil)
    }
    
    closeDialog()
  }
  
  // MARK: - Utilities
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  private func closeDialog() {
    runOnMainThread {
      self.autocompleteController?.dismiss(animated: true) {
        self.resetController()
        self.forgetSelf()
      }
    }
  }
  
  @objc public class func dictionary(from place: GMSPlace) -> [String: Any] {
    return [
      "name": place.name ?? NSNull(),
      "placeID": place.placeID ?? NSNull(),
      "latitude": place.coordinate.latitude,
      "longitude": place.coordinate.longitude,
      "formattedAddress": place.formattedAddress ?? NSNull(),
      "addressComponents": array(from: place.addressComponents)
    ]
  }
  
  @objc public class func array(from components: [GMSAddressComponent]?) -> Any {
    guard let components = components else {
      return NSNull()
    }
    
    return components.map {
      [
        "types": $0.types,
        "name": $0.name
      ]
    }
  }
  
  /*
  @objc public class func dictionary(from prediction: GMSAutocompletePrediction?) -> [String: Any]? {
    guard let prediction = prediction else { return nil }
    
    return [
      "attributedFullText": prediction.attributedFullText.string,
      "attributedPrimaryText": prediction.attributedPrimaryText.string,
      "attributedSecondaryText": prediction.attributedSecondaryText?.string as Any,
      "placeID": prediction.placeID ?? NSNull(),
      "types": prediction.types
    ]
  }*/
}
