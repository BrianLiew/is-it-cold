//
//  Networking.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation

class Networking {
    
    func make_request(completion_handler: @escaping (Data?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        DispatchQueue.global().async {
            let task = session.dataTask(with: forecast_url!) { data, response, error in
                
                guard let http_response = response as? HTTPURLResponse,
                      (200...299).contains(http_response.statusCode) else {
                          if let error_unwrapped = error { print("http response error: \(error_unwrapped.localizedDescription)") }
                          return
                      }
                
                // check if data is JSON
                guard let mime = response?.mimeType, mime == "application/json" else {
                    if let error_unwrapped = error { print("MIME error: \(error_unwrapped.localizedDescription)") }
                    return
                }
                
                if let data_unwrapped = data { completion_handler(data_unwrapped) }

            }
            task.resume()
        }
    }
    
}
