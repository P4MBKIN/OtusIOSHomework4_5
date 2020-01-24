//
//  NewsListViewModel.swift
//  OtusIOSHomework4_5
//
//  Created by Pavel Antonov on 24.01.2020.
//  Copyright © 2020 OtusCourse. All rights reserved.
//

import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    
    @Published private(set) var smileImage: Image? = nil
    @Published private(set) var sadImage: Image? = nil
    @Published private(set) var normalImage: Image? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadImages(
        service1: SmileImageDownloader? = ImageServiceLacator.shared.getService(),
        service2: SadImageDownloader? = ImageServiceLacator.shared.getService(),
        service3: NormalImageDownloader? = ImageServiceLacator.shared.getService()
    ) {

        guard let service1 = service1, let service2 = service2, let service3 = service3 else {
            print("Can't get services")
            return
        }
        let future1 = service1.getImage()
        let future2 = service2.getImage()
        let future3 = service3.getImage()
        let _ = Publishers.Zip3(future1, future2, future3).sink {
            guard let smileUIImage = $0.0, let sadUIImage = $0.1, let normalUIImage = $0.2 else {
                return
            }
            self.smileImage = Image(uiImage: smileUIImage)
            self.sadImage = Image(uiImage: sadUIImage)
            self.normalImage = Image(uiImage: normalUIImage)
        }
        .store(in: &self.cancellables)
    }
}
