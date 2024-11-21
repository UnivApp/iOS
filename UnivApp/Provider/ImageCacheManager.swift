//
//  ImageCacheManager.swift
//  UnivApp
//
//  Created by 정성윤 on 11/21/24.
//

import Foundation

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private var cache = [String: String]()
    private let lock = NSLock()

    private init() {}

    func getImage(for name: String) -> String? {
        lock.lock()
        defer { lock.unlock() }
        return cache[name]
    }

    func setImage(_ image: String, for name: String) {
        lock.lock()
        defer { lock.unlock() }
        cache[name] = image
    }
}
