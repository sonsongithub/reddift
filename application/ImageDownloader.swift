//
//  ImageDownloadable.swift
//  UZImageCollection
//
//  Created by sonson on 2015/07/03.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

let ImageDownloadableDidFinishDownloadingName = Notification.Name(rawValue: "ImageDownloadableDidFinishDownloadingName")

private let createConfiguration: () -> URLSessionConfiguration = {
    var configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    return configuration
}

private var configuration = createConfiguration()

private var session = URLSession(configuration: configuration)

let ImageDownloadableErrorKey  = "error"
let ImageDownloadableUrlKey    = "URL"
let ImageDownloadableSenderKey = "sender"

protocol ImageCache {
    func save(_ data: Data, of url: URL) throws
    func existsCachedImage(of url: URL) -> Bool
    func cachedDataInThumbnail(of url: URL) throws -> Data
    func cachedDataInCache(of url: URL) throws -> Data
    func cachedImageInThumbnail(of url: URL) throws -> UIImage
    func cachedImageInCache(of url: URL) throws -> UIImage
    func deleteAllCaches()
    func deleteAllThumbnails()
}

protocol ImageDownloadable: ImageCache {
    func postNotificationForImageDownload(url: URL, sender: AnyObject, error: NSError?)
    func download(imageURLs: [URL], sender: AnyObject)
    func downloadImages()
}

extension ImageCache {
    
    private func fileLocationURL(from url: URL, directory name: String) throws -> URL {
        let urlString = url.absoluteString
        let urlStringMD5 = urlString.md5
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheRootPath = paths[0]
        let cacheRootURL = URL(fileURLWithPath: cacheRootPath)
        do {
            let cachePath = cacheRootURL.appendingPathComponent(name)
            let imageLocationURL = cachePath.appendingPathComponent(urlStringMD5)
            try FileManager.default.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: [:])
            return imageLocationURL
        } catch let error {
            throw error
        }
    }
    
    private func imageLocationURL(from url: URL, in directory: String) throws -> URL {
        do {
            return try fileLocationURL(from: url, directory: directory)
        } catch {
            throw error
        }
    }
    
    private func thumbnail(of image: UIImage) throws -> UIImage {
        let scale = image.size.width > image.size.height ? 120 / image.size.width : 120 / image.size.height
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let output = resizeImage else { throw ReddiftAPPError.canNotCreateThumbnailImageFromOriginalImage }
        return output
    }
    
    private func cachedData(of url: URL, in directory: String) throws -> Data {
        do {
            let location = try imageLocationURL(from: url, in: directory)
            return try Data(contentsOf: location)
        } catch {
            throw error
        }
    }
    
    private func cachedImage(of url: URL, in directory: String) throws -> UIImage {
        do {
            let fileURL = try imageLocationURL(from: url, in: directory)
            let path = fileURL.path
            guard let image = UIImage(contentsOfFile: path) else { throw ReddiftAPPError.cachedImageFileIsNotFound }
            return image
        } catch {
            throw error
        }
    }
    
    func save(_ data: Data, of url: URL) throws {
        do {
            guard let image = UIImage(data: data) else { throw ReddiftAPPError.canNotCreateImageFromData }
            let thumbnail = try self.thumbnail(of: image)
            guard let thumbnailData = thumbnail.pngData() else { throw ReddiftAPPError.canNotCreatePNGImageDataFromUIImage }
            let imageURL = try imageLocationURL(from: url, in: "cache")
            let thumbnailURL = try imageLocationURL(from: url, in: "thumbnail")
            try data.write(to: imageURL)
            try thumbnailData.write(to: thumbnailURL)
        } catch {
            throw error
        }
    }
    
    func existsCachedImage(of url: URL) -> Bool {
        do {
            let path = try imageLocationURL(from: url, in: "cache").path
            return FileManager.default.isReadableFile(atPath: path)
        } catch {
            return false
        }
    }
    
    func cachedDataInThumbnail(of url: URL) throws -> Data {
        do {
            return try cachedData(of: url, in: "thumbnail")
        } catch { throw error }
    }
    
    func cachedDataInCache(of url: URL) throws -> Data {
        do {
            return try cachedData(of: url, in: "cache")
        } catch { throw error }
    }
    
    func cachedImageInThumbnail(of url: URL) throws -> UIImage {
        do {
            return try cachedImage(of: url, in: "thumbnail")
        } catch { throw error }
    }
    
    func cachedImageInCache(of url: URL) throws -> UIImage {
        do {
            return try cachedImage(of: url, in: "cache")
        } catch { throw error }
    }
    
    func deleteAllCaches() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheRootPath: NSString = paths[0] as NSString
        let cachePath = cacheRootPath.appendingPathComponent("cache")
        print(cachePath)
        
        FileManager.default.subpaths(atPath: cachePath)?.forEach {
            let targetPath = cachePath + "/" + $0
            do {
                try FileManager.default.removeItem(atPath: targetPath)
            } catch {
            }
        }
    }

    func deleteAllThumbnails() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheRootPath: NSString = paths[0] as NSString
        let cachePath = cacheRootPath.appendingPathComponent("thumbnail")
        print(cachePath)
        
        FileManager.default.subpaths(atPath: cachePath)?.forEach {
            let targetPath = cachePath + "/" + $0
            do {
                try FileManager.default.removeItem(atPath: targetPath)
            } catch {
            }
        }
    }
}

extension ImageDownloadable {
    func downloadImages() {
    }
    
    func postNotificationForImageDownload(url: URL, sender: AnyObject, error: NSError?) {
        var userInfo = [ImageDownloadableSenderKey: sender, ImageDownloadableUrlKey: url] as [String: Any]
        if let error = error {
            userInfo[ImageDownloadableErrorKey] = error
        }
        DispatchQueue.main.async(execute: { () -> Void in
            NotificationCenter.default.post(name: ImageDownloadableDidFinishDownloadingName, object: nil, userInfo: userInfo)
        })
    }
    
    func sessionForImageDownloadable() -> URLSession {
        return session
    }
    
    func download(imageURLs: [URL], sender: AnyObject) {
        imageURLs.forEach({
            let url = $0
            if existsCachedImage(of: url) { return }
            let https_url = url.httpsSchemaURL
            let request = URLRequest(url: https_url)
            let task = sessionForImageDownloadable().dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                do {
                    if let data = data {
                        try self.save(data, of: url)
                        self.postNotificationForImageDownload(url: url, sender: sender, error: nil)
                    } else {
                        let error = ReddiftAPPError.canNotAcceptDataFromServer as NSError
                        self.postNotificationForImageDownload(url: url, sender: sender, error: error)
                    }
                } catch {
                    self.postNotificationForImageDownload(url: url, sender: sender, error: error as NSError)
                }
            })
            task.resume()
            
        })
    }
}
