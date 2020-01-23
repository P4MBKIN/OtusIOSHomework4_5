//
//  FilterApplicator.swift
//  OtusIOSHomework4_5
//
//  Created by Pavel Antonov on 23.01.2020.
//  Copyright © 2020 OtusCourse. All rights reserved.
//

import UIKit

protocol FilterApplicator {
    func applyFilter(image: UIImage) -> UIImage?
}

enum FilterType: String {
    case noir = "CIPhotoEffectNoir"
    case blur = "CIBoxBlur"
    case sepia = "CISepiaTone"
}

class Filer: FilterApplicator {

    let type: FilterType

    init(type: FilterType) {
        self.type = type
    }

    func applyFilter(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: type.rawValue) else {
            return nil
        }
        currentFilter.setValue(CIImage(image: image), forKeyPath: kCIInputImageKey)
        guard let output = currentFilter.outputImage, let cgimg = context.createCGImage(output,from: output.extent) else {
            return nil
        }
        let result = UIImage(cgImage: cgimg)
        return result
    }
}
