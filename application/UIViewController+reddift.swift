//
//  UIViewController+reddift.swift
//  reddift
//
//  Created by sonson on 2016/09/11.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

extension UIViewController {
    func createImageViewPageControllerWith(_ thumbnails: [Thumbnail], openThumbnail: Thumbnail, isOpenedBy3DTouch: Bool = false) -> ImageViewPageController {
        for i in 0 ..< thumbnails.count {
            if thumbnails[i].thumbnailURL == openThumbnail.thumbnailURL && thumbnails[i].parentID == openThumbnail.parentID {
                return ImageViewPageController.controller(thumbnails: thumbnails, index: i, isOpenedBy3DTouch: isOpenedBy3DTouch)
            }
        }
        return ImageViewPageController.controller(thumbnails: thumbnails, index: 0, isOpenedBy3DTouch: isOpenedBy3DTouch)
    }
}
