//
//  CommentContainerCellar.swift
//  reddift
//
//  Created by sonson on 2016/03/14.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

let CommentContainerCellarDidLoadCommentsName = Notification.Name(rawValue: "CommentContainerCellarDidLoadComments")

class CommentContainerCellar {
    static let reloadIndicesKey = "ReloadIndices"
    static let insertIndicesKey = "InsertIndices"
    static let deleteIndicesKey = "DeleteIndices"
    static let errorKey         = "Error"
    static let initialLoadKey   = "ReloadData"
    
    var link: Link = Link(id: "")
    var loading = false
    var containers: [CommentContainable] = []
    var sort: CommentSort = .controversial
    
    /// Shared session configuration
    var sessionConfiguration: URLSessionConfiguration {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            return configuration
        }
    }
    
    /// Thumbnail
    var thumbnails: [Thumbnail] {
        get {
            return containers
                .compactMap({$0 as? CommentContainer})
                .flatMap({$0.thumbnails})
        }
    }
    
    /**
     Initialize CommentContainerCellar.
     - parameter link: To be written.
     - parameter delegate: To be written.
     - returns: To be written.
     */
    init(link: Link?) {
        if let link = link {
            self.link = link
        }
    }
    
    ///
    func layout(with width: CGFloat, fontSize: CGFloat) {
        self.containers.forEach({$0.layout(with: width, fontSize: fontSize)})
    }
    
    /**
     Expand child contents of the Thing objects.
     - parameter things: Array of Thing objects. The all child objects of the elements of the specified array will be expanded.
     - parameter width: Width of comment view. It is required to layout comment contents.
     - parameter depth: The depth of current Thing object in the specified array.
     */
    func expandIncommingComments(things: [Thing], width: CGFloat, depth: Int = 1) -> [CommentContainable] {
        let incomming: [(Thing, Int)] = things
            .filter { $0 is Comment || $0 is More }
            .flatMap { reddift.extendAllReplies(in: $0, current: depth) }
        
        let list: [CommentContainable] = incomming.compactMap({
            if $0.0 is More && $0.0.id == "_" {
                return nil
            }
            do {
                return try CommentContainable.createContainer(with: $0.0, depth: $0.1, width: width)
            } catch { return nil }
        })
        return list
    }
    
    func appendNewComment(_ newComment: Comment, to parentComment: Comment?, width: CGFloat) -> IndexPath? {
        if let parentComment = parentComment {
            if let index = containers.index(where: {$0.thing.name == parentComment.name}) {
                let contaier = containers[index]
                do {
                    let newContainer = try CommentContainable.createContainer(with: newComment, depth: contaier.depth + 1, width: width)
                    containers.insert(newContainer, at: index + 1)
                    return IndexPath(row: index + 1, section: 0)
                } catch { print(error) }
            }
        } else {
            do {
                let newContainer = try CommentContainable.createContainer(with: newComment, depth: 1, width: width)
                containers.append(newContainer)
                return IndexPath(row: containers.count - 1, section: 0)
            } catch { print(error) }
        }
        return nil
    }
    
    /**
     Starts to download More contents at specified index.
     This method is called when user selects a more cell.
     - parameter index: Index of contents array. This index is made from selected IndexPath object.
     - parameter width: Width of comment view. It is required to layout comment contents.
     */
    func downloadChildComments(of moreContainer: MoreContainer, index: Int, width: CGFloat) {
        if moreContainer.isLoading {
            return
        }
        moreContainer.isLoading = true
        NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.reloadIndicesKey: [IndexPath(row: index, section: 0)]])
        do {
            let children = moreContainer.more.children.reversed() as [String]
            try UIApplication.appDelegate()?.session?.getArticles(link, sort: sort, comments: children, completion: { (result) -> Void in
                moreContainer.isLoading = false
                switch result {
                case .failure(let error):
                    NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.errorKey: error])
                case .success(let tuple):
                    let things: [Thing] = tuple.1.children.filter {($0 is Comment) || ($0 is More)}
                    let temp = self.expandIncommingComments(things: things, width: width, depth: moreContainer.depth)
                    
                    self.prefetch(containers: temp)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let targetIndex = self.containers.index(where: {$0 === moreContainer}) {
                            self.containers.remove(at: targetIndex)
                            self.containers.insert(contentsOf: temp, at: targetIndex)
                            
                            var reloadIndices: [IndexPath] = []
                            var insertIndices: [IndexPath] = []
                            var deleteIndices: [IndexPath] = []
                            
                            if temp.count == 0 {
                                deleteIndices.append(IndexPath(row: targetIndex, section: 0))
                            } else if temp.count == 1 {
                                reloadIndices.append(IndexPath(row: targetIndex, section: 0))
                            } else if temp.count > 1 {
                                reloadIndices.append(IndexPath(row: targetIndex, section: 0))
                                insertIndices += (targetIndex + 1 ..< targetIndex + temp.count).map {IndexPath(row: $0, section: 0)}
                            }
                            NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [
                                CommentContainerCellar.reloadIndicesKey: reloadIndices,
                                CommentContainerCellar.insertIndicesKey: insertIndices,
                                CommentContainerCellar.deleteIndicesKey: deleteIndices
                                ])
                        }
                    })
                }
            })
        } catch {
        }
    }
    
    /**
     Starts to download Comment contents at specified index.
     This method is called when user selects a comment cell.
     - parameter index: Index of contents array. This index is made from selected IndexPath object.
     - parameter width: Width of comment view. It is required to layout comment contents.
     */
    func downloadChildComments(of commentContainer: CommentContainer, index: Int, width: CGFloat) {
        if commentContainer.isLoading || !commentContainer.comment.isExpandable {
            return
        }
        commentContainer.isLoading = true
        NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.reloadIndicesKey: [IndexPath(row: index, section: 0)]])
        do {
            try UIApplication.appDelegate()?.session?.getArticles(link, sort: .confidence, comments: [commentContainer.comment.id], completion: { (result) -> Void in
                commentContainer.isLoading = false
                switch result {
                case .failure(let error):
                    NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.errorKey: error])
                case .success(let (_, listing)):
                    if listing.children.count == 1 && listing.children[0].id == commentContainer.comment.id && listing.children[0] is Comment {
                        let temp = self.expandIncommingComments(things: listing.children, width: width, depth: commentContainer.depth)
                        
                        self.prefetch(containers: temp)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            if let targetIndex = self.containers.index(where: {$0 === commentContainer}) {
                                self.containers.remove(at: targetIndex)
                                self.containers.insert(contentsOf: temp, at: targetIndex)
                                
                                let reloadIndices = [IndexPath(row: targetIndex, section: 0)]
                                var insertIndices: [IndexPath] = []
                                if temp.count > 1 {
                                    insertIndices += (targetIndex + 1 ..< targetIndex + temp.count).map {IndexPath(row: $0, section: 0)}
                                }
                                NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.reloadIndicesKey: reloadIndices, CommentContainerCellar.insertIndicesKey: insertIndices])
                            }
                        })
                    } else {
                        NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.errorKey: NSError(domain: "", code: 0, userInfo: nil)])
                    }
                }
            })
        } catch {
        }
    }
    
    /**
     Starts to download More or Comment contents at specified index.
     This method is called when user selects a more or comment cell.
     - parameter index: Index of contents array. This index is made from selected IndexPath object.
     - parameter width: Width of comment view. It is required to layout comment contents.
     */
    func download(index: Int, width: CGFloat) {
        switch containers[index] {
        case (let moreContainer as MoreContainer):
            downloadChildComments(of: moreContainer, index: index, width: width)
        case (let commentContainer as CommentContainer):
            downloadChildComments(of: commentContainer, index: index, width: width)
        default:
            print("error")
        }
    }
    
    /**
     Get start index and count of child element of the target comment.
     - parameter index: Index of target comment.
     - returns: Tuple. Start index of child elements and count of child elements.
     */
    func indexOfChildren(index: Int) -> (Int, Int) {
        let commentThing = containers[index]
        
        var childIndex = 0
        var childCount = 0
        
        if index == containers.count - 1 {
            // this comment is the last object.
        } else if commentThing.depth == containers[index + 1].depth {
            // there are not any child objects.
        } else {
            // there are one or more child comments of the target.
            // so, search the index of the children.
            childIndex = index + 1
            for i in (index + 1)..<containers.count {
                let c = containers[i]
                if c.depth > commentThing.depth {
                    childCount = childCount + 1
                } else {
                    break
                }
            }
        }
        return (childIndex, childCount)
    }
    
    /**
     Collapse child elements that are specified by start index and count.
     - parameter fromIndex: Start index of the elements that will be collapsed.
     - parameter count: Count of the elements that will be collapsed.
     */
    func collapseChildComments(from: Int, count: Int) {
        for i in from..<from + count {
            containers[i].isHidden = true
        }
    }
    
    /**
     Make child elements that are specified by start index and count visible.
     - parameter fromIndex: Start index of the elements that will be made visible.
     - parameter count: Count of the elements that will be made visible.
     */
    func expandChildComments(from: Int, count: Int) {
        var prevDepth = containers[from].depth
        var prevIsHidden = false
        var prevIsCollapsed = false
        let depthOffset = containers[from].depth
        var isHiddenFlagStack: [Bool] = []
        
        for i in from..<from + count {
            if prevDepth == containers[i].depth {
                // set invisible when prior element is invisible.
                containers[i].isHidden = prevIsHidden
            } else if prevDepth < containers[i].depth {
                // push stack when content's depth will be dropped down.
                if !prevIsCollapsed && !prevIsHidden {
                    containers[i].isHidden = false
                    isHiddenFlagStack.append(false)
                } else if !prevIsCollapsed && prevIsHidden {
                    containers[i].isHidden = true
                    isHiddenFlagStack.append(true)
                } else if prevIsCollapsed && !prevIsHidden {
                    containers[i].isHidden = true
                    isHiddenFlagStack.append(false)
                } else if prevIsCollapsed && !prevIsHidden {
                    containers[i].isHidden = true
                    isHiddenFlagStack.append(true)
                }
            } else {
                // pop stack when content's depth will be rised.
                let d = containers[i].depth - depthOffset
                containers[i].isHidden = isHiddenFlagStack[d]
                for _ in 0..<isHiddenFlagStack.count - d {
                    isHiddenFlagStack.removeLast()
                }
            }
            prevIsHidden = containers[i].isHidden
            prevIsCollapsed = containers[i].isCollapsed
            prevDepth = containers[i].depth
        }
    }
    
    /**
     Toggle between expanding and closing children of the target comment.
     - parameter index: Index of the target comment.
     */
    func toggleExpand(index: Int) {
        // toggle close flag and obtain child elements.
        containers[index].isCollapsed = !containers[index].isCollapsed
        let (childIndex, childCount) = indexOfChildren(index: index)
        
        // IndexPath array to send the table view.
        let reloadIndices = (index..<index + childCount + 1).map({IndexPath(row: $0, section: 0)})
        
        // Update number of children, in order to display "x children" label.
        // This number includes own.
        containers[index].numberOfChildren = childCount + 1
        
        // set collapsed flag of children
        if childCount > 0 {
            if !containers[index].isCollapsed {
                expandChildComments(from: childIndex, count: childCount)
            } else {
                collapseChildComments(from: childIndex, count: childCount)
            }
        }
        
        // Execute reloading table view.
        NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [
            CommentContainerCellar.reloadIndicesKey: reloadIndices
            ])
    }
    
    /**
     Try to generate image url list from link to imgur.com from contents which is included by the specified array.
     This method checks whether the contents at the specified index has url to imgur.com or not.
     If it has the url, this method downloads html of the url and extend image url list.
     - parameter index: The index of CommentContainer which you want to expand its image url ist.
     */
    func prefetch(containers: [CommentContainable]) {
        containers.forEach({
            if let commentContainer = $0 as? CommentContainer {
                for i in 0..<commentContainer.urlContainer.count {
                    if let urlContainer = commentContainer.urlContainer[i] as? ImgurURLInComment {
                        let url = urlContainer.sourceURL.httpsSchemaURL
                        var request = URLRequest(url: url)
                        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56", forHTTPHeaderField: "User-Agent")
                        let session: URLSession = URLSession(configuration: self.sessionConfiguration)
                        let task = session.dataTask(with: request, completionHandler: { (data, _, _) -> Void in
                            if let data = data, let decoded = String(data: data, encoding: .utf8) {
                                if !decoded.is404OfImgurcom {
                                    var new = ImgurURLInComment(sourceURL: url, parentID: commentContainer.comment.id)
                                    new.imageURL = decoded.extractImgurImageURL(parentID: commentContainer.comment.id)
                                    commentContainer.urlContainer[i] = new
                                    
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        if let targetIndex = self.containers.index(where: {$0 === commentContainer}) {
                                            let reloadIndices = [IndexPath(row: targetIndex, section: 0)]
                                            NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.reloadIndicesKey: reloadIndices])
                                        }
                                    })
                                }
                            }
                        })
                        task.resume()
                    }
                }
            }
        })
    }
    
    /**
     Start to load comments and link.
     - parameter width: Width of comment view. It is required to layout comment contents.
     */
    func load(width: CGFloat) {
        do {
            try UIApplication.appDelegate()?.session?.getArticles(link, sort: sort, comments: nil, limit: nil, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tuple):
                    let listing0 = tuple.0
                    if listing0.children.count == 1 {
                        if let link = listing0.children[0] as? Link {
                            if !link.selftextHtml.isEmpty {
                                do {
                                    let comment = Comment(link: link)
                                    let c = try CommentContainer.createContainer(with: comment, depth: 1, width: width)
                                    c.isTop = true
                                    self.containers.append(c)
                                } catch {
                                }
                            }
                        }
                    }
                    
                    let listing = tuple.1
                    self.containers.append(contentsOf: self.expandIncommingComments(things: listing.children, width: width))
                    
                    self.prefetch(containers: self.containers)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        NotificationCenter.default.post(name: CommentContainerCellarDidLoadCommentsName, object: nil, userInfo: [CommentContainerCellar.initialLoadKey: true])
                    })
                }
            })
        } catch {
        }
    }
}
