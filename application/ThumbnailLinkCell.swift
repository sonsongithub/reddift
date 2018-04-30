//
//  ThumbnailLinkCell.swift
//  reddift
//
//  Created by sonson on 2016/10/05.
//  Copyright © 2016年 sonson. All rights reserved.
//

class ThumbnailLinkCell: LinkCell, ImageDownloadable, ImageViewAnimator {
    var titleTextViewHeightConstraint: NSLayoutConstraint?
    let thumbnailImageView = UIImageView(frame: CGRect.zero)
    let activityIndicatorViewOnThumbnail = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let titleAndThumbnailBaseView = UIView(frame: CGRect.zero)
    
    static let horizontalLeftMargin   = CGFloat(8)
    static let horizontalCenterMargin = CGFloat(8)
    static let horizontalRightMargin  = CGFloat(8)
    static let thumbnailWidth         = CGFloat(88)
    static let thumbnailHeight        = CGFloat(88)
    
    func targetImageView(thumbnail: Thumbnail) -> UIImageView? {
        return self.container?.link.id == thumbnail.parentID ? thumbnailImageView : nil
    }
    
    func imageViews() -> [UIImageView] {
        return [thumbnailImageView]
    }
    
    static func textAreaWidth(_ width: CGFloat) -> CGFloat {
        return width - thumbnailWidth - horizontalLeftMargin - horizontalCenterMargin - horizontalRightMargin
    }
    
    override class func estimateTitleSize(attributedString: NSAttributedString, withBountWidth: CGFloat, margin: UIEdgeInsets) -> CGSize {
        let constrainedWidth = ThumbnailLinkCell.textAreaWidth(withBountWidth)
        return UZTextView.size(for: attributedString, withBoundWidth: constrainedWidth, margin: UIEdgeInsets.zero)
    }
    
    override class func estimateHeight(titleHeight: CGFloat) -> CGFloat {
        let thumbnailHeight = ThumbnailLinkCell.thumbnailHeight
        let h = titleHeight > thumbnailHeight ? titleHeight : thumbnailHeight
        return ThumbnailLinkCell.verticalTopMargin + h + ThumbnailLinkCell.verticalBotttomMargin + ContentInfoView.height + ContentToolbar.height
    }
    
    func updateTitleTextViewHeightConstraintWith(_ height: CGFloat) {
        if let t = titleTextViewHeightConstraint {
            t.constant = height
        } else {
            let heightConstraint = NSLayoutConstraint(item: titleTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
            titleTextView.addConstraint(heightConstraint)
            titleTextViewHeightConstraint = heightConstraint
        }
    }
    
    override var container: LinkContainable? {
        didSet {
            if let container = container as? ThumbnailLinkContainer {
                updateTitleTextViewHeightConstraintWith(container.titleSize.height)
                self.setNeedsUpdateConstraints()
                setImage(of: container
                    .thumbnailURL)
            }
        }
    }
    
    // MARK: - UIViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        activityIndicatorViewOnThumbnail.isHidden = false
        activityIndicatorViewOnThumbnail.startAnimating()
        activityIndicatorViewOnThumbnail.isHidden = false
        activityIndicatorViewOnThumbnail.startAnimating()
    }
    
    // MARK: - Setup
    
    func setupTitleAndThumbnailBaseViewConstraints() {
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorViewOnThumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "thumbnailImageView": thumbnailImageView,
            "titleTextView": titleTextView
            ] as [String: Any]
        let metrics = [
            "horizontalCenterMargin": ThumbnailLinkCell.horizontalCenterMargin
        ]
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[titleTextView]-horizontalCenterMargin-[thumbnailImageView]-0-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        )
        
        do {
            
            let centerx = NSLayoutConstraint(item: thumbnailImageView, attribute: .centerX, relatedBy: .equal, toItem: activityIndicatorViewOnThumbnail, attribute: .centerX, multiplier: 1, constant: 0)
            titleAndThumbnailBaseView.addConstraint(centerx)
            let centery = NSLayoutConstraint(item: thumbnailImageView, attribute: .centerY, relatedBy: .equal, toItem: activityIndicatorViewOnThumbnail, attribute: .centerY, multiplier: 1, constant: 0)
            titleAndThumbnailBaseView.addConstraint(centery)
        }
        
        do {
            let centery = NSLayoutConstraint(item: titleAndThumbnailBaseView, attribute: .centerY, relatedBy: .equal, toItem: titleTextView, attribute: .centerY, multiplier: 1, constant: 0)
            titleAndThumbnailBaseView.addConstraint(centery)
        }
        do {
            let widthConstraint = NSLayoutConstraint(item: thumbnailImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ThumbnailLinkCell.thumbnailWidth)
            thumbnailImageView.addConstraint(widthConstraint)
            let heightConstraint = NSLayoutConstraint(item: thumbnailImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ThumbnailLinkCell.thumbnailHeight)
            thumbnailImageView.addConstraint(heightConstraint)
            let centery = NSLayoutConstraint(item: titleAndThumbnailBaseView, attribute: .centerY, relatedBy: .equal, toItem: thumbnailImageView, attribute: .centerY, multiplier: 1, constant: 0)
            titleAndThumbnailBaseView.addConstraint(centery)
        }
    }
    
    func setupTitleAndThumbnailBaseView() {
        titleAndThumbnailBaseView.addSubview(titleTextView)
        titleAndThumbnailBaseView.addSubview(thumbnailImageView)
        titleAndThumbnailBaseView.addSubview(activityIndicatorViewOnThumbnail)
        activityIndicatorViewOnThumbnail.startAnimating()
    }
    
    override func setupConstraints() {
        contentInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentToolbar.translatesAutoresizingMaskIntoConstraints = false
        titleAndThumbnailBaseView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "titleAndThumbnailBaseView": titleAndThumbnailBaseView,
            "contentInfoView": contentInfoView,
            "contentToolbar": contentToolbar
            ]
        let metric = [
            "horizontalLeftMargin": ThumbnailLinkCell.horizontalLeftMargin,
            "horizontalRightMargin": ThumbnailLinkCell.horizontalRightMargin,
            "verticalTopMargin": LinkCell.verticalTopMargin,
            "verticalBottomMargin": LinkCell.verticalBotttomMargin,
            "contentInfoViewHeight": ContentInfoView.height,
            "contentToolbarHeight": ContentToolbar.height
        ]
        
        ["contentInfoView", "contentToolbar"].forEach({
            self.contentView.addConstraints (
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[\($0)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            )
        })
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalLeftMargin-[titleAndThumbnailBaseView]-horizontalRightMargin-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalTopMargin-[titleAndThumbnailBaseView]-verticalBottomMargin-[contentInfoView(==contentInfoViewHeight)]-0-[contentToolbar(==contentToolbarHeight)]-0-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
    }
    
    override func setupDispatching() {
        super.setupDispatching()
        let rec = UITapGestureRecognizer(target: self, action: #selector(ThumbnailLinkCell.didTapGesture(recognizer:)))
        titleAndThumbnailBaseView.addGestureRecognizer(rec)
    }
    
    override func setupViews() {
        selectionStyle = .none
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        titleTextView.isUserInteractionEnabled = false
        titleTextView.backgroundColor = UIColor.clear
        titleAndThumbnailBaseView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(titleAndThumbnailBaseView)
        self.contentView.addSubview(contentInfoView)
        self.contentView.addSubview(contentToolbar)
    }
    
    override func setup() {
        setupViews()
        setupConstraints()
        setupTitleAndThumbnailBaseView()
        setupTitleAndThumbnailBaseViewConstraints()
        setupDispatching()
        setupTitleAndThumbnailBaseView()
        NotificationCenter.default.addObserver(self, selector: #selector(ThumbnailLinkCell.didFinishDownloading(notification:)), name: ImageDownloadableDidFinishDownloadingName, object: nil)
    }
    
    // MARK: - Action
    
    @objc func didTapGesture(recognizer: UITapGestureRecognizer) {
        if let container = container as? ThumbnailLinkContainer {
            let userInfo: [String: Any] = ["link": container.link, "thumbnail": container.thumbnails[0], "view": thumbnailImageView]
            NotificationCenter.default.post(name: LinkCellDidTapThumbnailNotification, object: nil, userInfo: userInfo)
        }
    }
    
    // MARK: - 3D touch
    
    override func urlAt(_ location: CGPoint, peekView: UIView) -> (URL, CGRect)? {        
        return nil
    }
    
    override func thumbnailAt(_ location: CGPoint, peekView: UIView) -> (Thumbnail, CGRect, LinkContainable, Int)? {
        if let container = container {
            let p = peekView.convert(location, to: titleAndThumbnailBaseView)
            if titleAndThumbnailBaseView.frame.contains(p) {
                let sourceRect = titleAndThumbnailBaseView.convert(thumbnailImageView.frame, to: peekView)
                return (container.thumbnails[0], sourceRect, container, 0)
            }
        }
        return nil
    }
    
    // MARK: - ImageDownloadable
    
    func setImage(of url: URL) {
        do {
            let image = try self.cachedImageInCache(of: url)
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.image = image
            activityIndicatorViewOnThumbnail.isHidden = true
            activityIndicatorViewOnThumbnail.stopAnimating()
        } catch {
        }
    }
    
    func setErrorImage() {
        thumbnailImageView.contentMode = .center
        thumbnailImageView.image = UIImage(named: "error")
        activityIndicatorViewOnThumbnail.isHidden = true
        activityIndicatorViewOnThumbnail.stopAnimating()
    }
    
    @objc func didFinishDownloading(notification: NSNotification) {
        if let userInfo = notification.userInfo, let _ = userInfo[ImageDownloadableSenderKey], let url = userInfo[ImageDownloadableUrlKey] as? URL {
            if let container = container as? ThumbnailLinkContainer {
                if container.thumbnailURL == url {
                    if let _ = userInfo[ImageDownloadableErrorKey] as? NSError {
                        setErrorImage()
                    } else {
                        setImage(of: container.thumbnailURL)
                    }
                }
            }
        }
    }
    
}
