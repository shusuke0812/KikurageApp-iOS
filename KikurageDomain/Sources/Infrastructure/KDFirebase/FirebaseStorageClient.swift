//
//  File.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/1.
//

import FirebaseStorage
import Foundation
import RxSwift

public protocol FirebaseStorageClientProtocol {
    func postImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], FirebaseClientError>) -> Void)
    func postImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]>
}

public class FirebaseStorageClient: FirebaseStorageClientProtocol {
    private let metaData: StorageMetadata
    
    public init() {
        metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
    }
    
    public func postImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], FirebaseClientError>) -> Void) {
        var imageStorageFullPaths: [String] = []
        
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue(label: "com.shusuke.KikurageApp.upload_images_queue")
        
        var resultError: Error?
        dispatchQueue.async { [weak self] in
            for (i, imageData) in zip(imageData.indices, imageData) {
                guard let imageData = imageData else {
                    dispatchSemaphore.signal()
                    return
                }
                let fileName: String = DateHelper.formatToStringForImageData(date: Date()) + "_\(i).jpeg"
                let storageReference = Storage.storage().reference().child(imageStoragePath + fileName)
                _ = storageReference.putData(imageData, metadata: self?.metaData) { _, error in
                    if let error = error {
                        resultError = error
                        dispatchSemaphore.signal()
                        return
                    }
                    imageStorageFullPaths.append(storageReference.fullPath)
                    dispatchSemaphore.signal()
                }
            }
            DispatchQueue.main.async {
                if let resultError = resultError {
                    completion(.failure(.apiError(.createError)))
                    return
                }
                completion(.success(imageStorageFullPaths))
            }
        }
    }
    
    public func postImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]> {
        Single<[String]>.create { single in
            var imageStorageFullPaths: [String] = []
            let dispatchSemaphore = DispatchSemaphore(value: 0)
            let dispatchQueue = DispatchQueue(label: "com.shusuke.KikurageApp.upload_images_queue")
            var resultError: Error?
            dispatchQueue.async { [weak self] in
                for (i, imageData) in zip(imageData.indices, imageData) {
                    guard let imageData = imageData else {
                        dispatchSemaphore.signal()
                        return
                    }
                    let fileName: String = DateHelper.formatToStringForImageData(date: Date()) + "_\(i).jpeg"
                    let storageReference = Storage.storage().reference().child(imageStoragePath + fileName)
                    _ = storageReference.putData(imageData, metadata: self?.metaData) { _, error in
                        if let error = error {
                            resultError = error
                            dispatchSemaphore.signal()
                            return
                        }
                        imageStorageFullPaths.append(storageReference.fullPath)
                        dispatchSemaphore.signal()
                    }
                }
                if let resultError = resultError {
                    single(.failure(FirebaseClientError.apiError(.createError)))
                    return
                }
                single(.success(imageStorageFullPaths))
            }
            return Disposables.create()
        }
    }
}

fileprivate struct DateHelper {
    private init() {}
    
    private static let originalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static func formatToStringForImageData(date: Date) -> String {
        originalDateFormatter.dateFormat = "yyyyMMddHHmmss"
        return originalDateFormatter.string(from: date)
    }
}
