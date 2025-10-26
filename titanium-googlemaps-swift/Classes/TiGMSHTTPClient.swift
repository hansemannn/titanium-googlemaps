//
//  TiGMSHTTPClient.swift
//  TiGooglemaps
//
//  Created by Hans Knöchel on 26.10.25.
//

import Foundation

private let kTiGoogleMapsBasePath = "https://maps.googleapis.com/maps/api"

class TiGMSHTTPClient {
  private let apiKey: String
  private let session: URLSession
  
  init(apiKey: String, session: URLSession = URLSession(configuration: .default)) {
    self.apiKey = apiKey
    self.session = session
  }
  
  func load(withRequestPath path: String,
            andOptions options: [String: Any],
            completionHandler: @escaping ([String: Any]?, Error?) -> Void) {
    guard let url = entitledURL(withPath: path, andOptions: options) else {
      let error = NSError(domain: NSURLErrorDomain,
                          code: URLError.badURL.rawValue,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid request URL"])
      completionHandler(nil, error)
      return
    }
    
    session.dataTask(with: url) { data, _, error in
      if let error = error {
        completionHandler(nil, error)
        return
      }
      
      guard let data = data else {
        let noDataError = NSError(domain: NSURLErrorDomain,
                                  code: URLError.badServerResponse.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: "Empty response"])
        completionHandler(nil, noDataError)
        return
      }
      
      do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let json = jsonObject as? [String: Any]
        
        if let errorMessage = json?["error_message"] as? String {
          let apiError = NSError(domain: NSURLErrorDomain,
                                 code: -1,
                                 userInfo: [NSLocalizedDescriptionKey: errorMessage])
          completionHandler(json, apiError)
          return
        }
        
        completionHandler(json, nil)
      } catch {
        completionHandler(nil, error)
      }
    }.resume()
  }
  
  func entitledURL(withPath path: String, andOptions options: [String: Any]?) -> URL? {
    guard var components = URLComponents(string: "\(kTiGoogleMapsBasePath)/\(path)") else {
      return nil
    }
    
    var queryItems: [URLQueryItem] = options?.map { key, value in
      URLQueryItem(name: key, value: "\(value)")
    } ?? []
    
    queryItems.append(URLQueryItem(name: "key", value: apiKey))
    components.queryItems = queryItems
    
    return components.url
  }
  
  static func formattedWaypoints(from array: [String]?) -> String? {
    guard let array = array, !array.isEmpty else { return nil }
    
    return array.joined(separator: "|")
  }
}
