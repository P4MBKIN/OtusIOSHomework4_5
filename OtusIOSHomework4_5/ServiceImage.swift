//
//  ServiceImage.swift
//  OtusIOSHomework4_5
//
//  Created by Pavel on 22.01.2020.
//  Copyright © 2020 OtusCourse. All rights reserved.
//

import UIKit
import Alamofire

enum ImageError: Error {
    case badURL, emptyData, notApplyFilter
}

protocol ServiceImage {
    associatedtype Image: UIImage
    
    func getImage(completion: @escaping (Swift.Result<Image, ImageError>) -> ())
}

enum TypeImage: String {
    case smile = "https://png.pngtree.com/png-clipart/20190516/original/pngtree-lol-emoji-vector-icon-png-image_3719384.jpg"
    case sad = "https://images-na.ssl-images-amazon.com/images/I/312Gml3UM0L.jpg"
    case normal = "https://images.assetsdelivery.com/compings_v2/terrry4/terrry41904/terrry4190401586.jpg"
}

struct ImageDownloader: ServiceImage {
    
    let filter: CIFilter
    let url: URL
    
    init(filter: CIFilter, type: TypeImage) {
        self.filter = filter
        self.url = URL(string: type.rawValue)!
    }
    
    func getImage(completion: @escaping (Swift.Result<UIImage, ImageError>) -> ()) {
        Alamofire.request(url).responseData { response in
            guard response.error == nil else {
                print(response.error!)
                completion(.failure(.badURL))
                return
            }
            guard let data = response.data else {
                print("Empty data")
                completion(.failure(.emptyData))
                return
            }
            let context = CIContext(options: nil)
            self.filter.setValue(CIImage(data: data), forKey: kCIInputImageKey)
            if let output = self.filter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
                completion(.success(UIImage(cgImage: cgImage)))
                return
            }
            completion(.failure(.notApplyFilter))
            return
        }
    }
}


