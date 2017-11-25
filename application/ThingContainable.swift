//
//  ThingContainable.swift
//  reddift
//
//  Created by sonson on 2016/09/29.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

let ThingContainableDidUpdate = Notification.Name(rawValue: "ThingContainableDidUpdate")

class ThingContainable {
    internal var intrinsicThing: Thing
    var thing: Thing {
        get {
            return intrinsicThing
        }
    }
    
    init(with aThing: Thing) {
        intrinsicThing = aThing
    }
    
    var cellIdentifier: String {
        return "InvisibleCell"
    }
    
    var height: CGFloat {
        return 0
        
    }
    
    var isHidden: Bool = false
    
    // update
    func update() {
        do {
            try UIApplication.appDelegate()?.session?.getInfo([self.thing.name], completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    if listing.children.count == 1 {
                        self.intrinsicThing = listing.children[0]
                        DispatchQueue.main.async(execute: { () -> Void in
                            NotificationCenter.default.post(name: ThingContainableDidUpdate, object: nil, userInfo: ["contents": self])
                        })
                    }
                }
            })
        } catch { print(error) }
    }
    
    // hide
    func hide() {
        do {
            try UIApplication.appDelegate()?.session?.setHide(true, name: self.thing.name, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    self.update()
                }
            })
        } catch { print(error) }
    }
    
    // report
    func report() {
        do {
            try UIApplication.appDelegate()?.session?.report(self.thing, reason: "", otherReason: "", completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let obj):
                    print(obj)
                }
            })
        } catch { print(error) }
    }
    
    // vote
    func vote(voteDirection: VoteDirection) {
        do {
            try UIApplication.appDelegate()?.session?.setVote(voteDirection, name: self.thing.name, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    self.update()
                }
            })
        } catch { print(error) }
    }
    
    // save
    func save(saved: Bool) {
        do {
            try UIApplication.appDelegate()?.session?.setSave(saved, name: self.thing.name, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    self.update()
                }
            })
        } catch { print(error) }
    }
}
