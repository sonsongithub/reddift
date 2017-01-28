//
//  LinkContainerCellar.swift
//  reddift
//
//  Created by sonson on 2016/10/05.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

public let LinkContainerCellarDidLoadName = Notification.Name(rawValue: "LinkContainerCellarDidLoadName")

class LinkContainerCellar {
    static let reloadIndicesKey     = "ReloadIndices"
    static let insertIndicesKey     = "InsertIndices"
    static let deleteIndicesKey     = "DeleteIndices"
    static let errorKey             = "Error"
    static let isAtTheBeginningKey  = "atTheBeginning"
    static let providerKey          = "Provider"
    
    var containers: [LinkContainable] = []
    var thumbnails: [Thumbnail] {
        get {
            return containers.flatMap({$0.thumbnails})
        }
    }
    
    func updateHidden() {
        for i in 0..<containers.count {
            containers[i].isHidden = containers[i].link.hidden
        }
    }
    
    var width = CGFloat(0)
    var fontSize = CGFloat(0)
    
    func layout(with width: CGFloat, fontSize: CGFloat) {
        self.width = width
        self.fontSize = fontSize
        self.containers.forEach({ $0.layout(with: width, fontSize: fontSize) })
    }
    
    private(set) var isLoading: Bool = false
    func load(atTheBeginning: Bool) {}
    func tryLoadingMessage() -> String { return "" }
    func loadingMessage() -> String { return "" }
}
