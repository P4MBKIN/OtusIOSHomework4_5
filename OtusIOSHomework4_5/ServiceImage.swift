//
//  ServiceImage.swift
//  OtusIOSHomework4_5
//
//  Created by Pavel on 22.01.2020.
//  Copyright © 2020 OtusCourse. All rights reserved.
//

import UIKit
import Alamofire
import Combine

protocol ServiceImage {
    func getImage() -> Future<UIImage?, Never>
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
    
    func getImage() -> Future<UIImage?, Never> {
        return Future { [url] promise in
            Alamofire.request(url).responseData { response in
                guard response.error == nil else {
                    print("\(response.error!) for \(url)")
                    promise(.success(nil))
                    return
                }
                guard let data = response.data else {
                    print("Empty data for \(url)")
                    promise(.success(nil))
                    return
                }
                guard let image = UIImage(data: data) else {
                    print("Bad data for \(url)")
                    promise(.success(nil))
                    return
                }
                guard let output = self.filterApplicator.applyFilter(image: image) else {
                    print("Can't apply filter for \(url)")
                    promise(.success(nil))
                    return
                }
                print("It's OK for \(url)")
                promise(.success(output))
                return
            }
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
