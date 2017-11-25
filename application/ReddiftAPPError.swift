//
//  ReddiftAPPError.swift
//  reddift
//
//  Created by sonson on 2016/07/28.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

public enum ReddiftAPPError: Int, Error {
    case unknown
    
    /// thumbnail
    case cachedImageFileIsNotFound
    case canNotCreateURLFromImageURLString
    case canNotCreateFilePathFromImageFileURL
    case canNotCreateThumbnailImageFromOriginalImage
    case canNotCreateImageFromData
    case canNotCreatePNGImageDataFromUIImage
    case canNotCreateURLStringFromURL
    case canNotAcceptDataFromServer
    case canNotGetImageViewForSpecifiedImageURL
}
