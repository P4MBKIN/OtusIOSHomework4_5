//
//  ServiceLocator.swift
//  OtusIOSHomework4_5
//
//  Created by Pavel Antonov on 23.01.2020.
//  Copyright © 2020 OtusCourse. All rights reserved.
//

protocol ServiceLocating {
    func getService<T: ServiceImage>() -> T?
}

final class ImageServiceLacator: ServiceLocating {
    
    public static let shared = ImageServiceLacator()
    
    private lazy var services: Dictionary<String, ServiceImage> = [:]
    
    private init() {
        addService(service: SmileImageDownloader(filterApplicator: Filer(type: .blur)))
        addService(service: SadImageDownloader(filterApplicator: Filer(type: .noir)))
        addService(service: NormalImageDownloader(filterApplicator: Filer(type: .sepia)))
    }
    
    private func typeName(some: Any) -> String {
        return some is Any.Type ? "\(some)" : "\(type(of: some))"
    }
    
    private func addService<T: ServiceImage>(service: T) {
        let key = typeName(some: T.self)
        services[key] = service
    }
    
    func getService<T: ServiceImage>() -> T? {
        let key = typeName(some: T.self)
        return services[key] as? T
    }
}
