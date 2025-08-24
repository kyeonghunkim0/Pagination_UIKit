//
//  ImageLoader.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import UIKit
import Combine

final class ImageLoader {
    
    let backgroundQueue = DispatchQueue.global(qos: .background)

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, _) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
