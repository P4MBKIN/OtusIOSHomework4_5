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
    func getImage(completion: @escaping (Swift.Result<UIImage, ImageError>) -> ())
}

fileprivate enum TypeImage: String {
    case smile = "https://png.pngtree.com/png-clipart/20190516/original/pngtree-lol-emoji-vector-icon-png-image_3719384.jpg"
    case sad = "https://images-na.ssl-images-amazon.com/images/I/312Gml3UM0L.jpg"
    case normal = "https://images.assetsdelivery.com/compings_v2/terrry4/terrry41904/terrry4190401586.jpg"
}

class ImageDownloaderBase: ServiceImage {
    
    let filterApplicator: FilterApplicator
    let url: URL
    
    fileprivate init(filterApplicator: FilterApplicator, type: TypeImage) {
        // Dependency injection (DI)
        self.filterApplicator = filterApplicator

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
            guard let image = UIImage(data: data), let output = self.filterApplicator.applyFilter(image: image) else {
                completion(.failure(.notApplyFilter))
                return
            }
            completion(.success(output))
            return
        }
    }
}

class SmileImageDownloader: ImageDownloaderBase {
    init(filterApplicator: FilterApplicator) {
        super.init(filterApplicator: filterApplicator, type: TypeImage.smile)
    }
}

class SadImageDownloader: ImageDownloaderBase {
    init(filterApplicator: FilterApplicator) {
        super.init(filterApplicator: filterApplicator, type: TypeImage.sad)
    }
}

class NormalImageDownloader: ImageDownloaderBase {
    init(filterApplicator: FilterApplicator) {
        super.init(filterApplicator: filterApplicator, type: TypeImage.normal)
    }
}
