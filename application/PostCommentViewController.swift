//
//  PostCommentViewController.swift
//  reddift
//
//  Created by sonson on 2016/11/21.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

let PostCommentViewControllerDidSendCommentName = Notification.Name(rawValue: "PostCommentViewControllerDidSendCommentName")

class PostCommentViewController: UIViewController, FromFieldViewDelegate {
    let thing: Thing
    let textView = UITextView(frame: CGRect.zero)
    var bottomSpaceConstraint: NSLayoutConstraint?
    let fromFieldView = FromFieldView(frame: CGRect.zero)
    let fieldHeight = CGFloat(44)
    
    static func controller(with thing: Thing) -> UINavigationController {
        let controller = PostCommentViewController(with: thing)
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.thing = Link(id: "")
        super.init(coder: aDecoder)
    }
    
    init(with thing: Thing) {
        self.thing = thing
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.contentOffset = CGPoint(x: 0, y: -108)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        let views = [
            "textView": textView,
            "accountBaseView": fromFieldView
        ]
        
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backOnBarButton"), style: .plain, target: self, action: #selector(PostCommentViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send"), style: .plain, target: self, action: #selector(PostCommentViewController.send(sender:)))

        self.view.addSubview(textView)
        textView.addSubview(fromFieldView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor.white
        fromFieldView.backgroundColor = UIColor.white
        
        var contentInset = textView.contentInset
        contentInset.top = fieldHeight
        textView.contentInset = contentInset
        fromFieldView.frame = CGRect(x: 0, y: -fieldHeight, width: self.view.frame.size.width, height: fieldHeight)
        
        textView.setNeedsLayout()
        
        textView.alwaysBounceVertical = true
        
        self.view.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        )
        let topConstraint = NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1, constant: 0)
        let bottomSpaceConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1, constant: 0)
        self.bottomSpaceConstraint = bottomSpaceConstraint
        self.view.addConstraint(topConstraint)
        self.view.addConstraint(bottomSpaceConstraint)

        NotificationCenter.default.addObserver(self, selector: #selector(PostCommentViewController.keyboardWillChangeFrame(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostCommentViewController.keyboardWillChangeFrame(notification:)), name: .UIKeyboardDidChangeFrame, object: nil)
        
        let str = "test\n **bold** \n"
        textView.text = str
        
        setupAccountView()
        
        fromFieldView.delegate = self
    }
    
    func didTapFromFieldView(sender: FromFieldView) {
        if let s = UIApplication.shared.keyWindow?.rootViewController?.storyboard {
            let nav = s.instantiateViewController(withIdentifier: "AccountListNavigationController")
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func setupAccountView() {
    }
    
    @objc func close(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func send(sender: Any) {
        do {
            try UIApplication.appDelegate()?.session?.postComment(self.textView.text, parentName: thing.name, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let comment):
                    print(comment)
                    DispatchQueue.main.async {
                        let userInfo: [String: Any] = [
                            "newComment": comment,
                            "parent": self.thing
                        ]
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: PostCommentViewControllerDidSendCommentName, object: nil, userInfo: userInfo)
                    }
                }
            })
        } catch {
//            let nserror = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"\(error)"])
//            postNotification(name: LinkContainerCellarDidLoadName, userInfo: [LinkContainerCellar.errorKey: nserror, LinkContainerCellar.providerKey: self])
        }
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect, let bottomSpaceConstraint = self.bottomSpaceConstraint {
                print(rect)
                let h = self.view.frame.size.height - rect.origin.y
                bottomSpaceConstraint.constant = h
            }
        }
    }
}
