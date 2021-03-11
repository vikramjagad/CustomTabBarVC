//
//  TabViewController.swift
//  Grocery
//
//  Created by Vikram Jagad on 22/11/20.
//

import UIKit

public enum TabBarPlace: Int {
    case top
    case bottom
}

public enum TabBarType: String {
    case title
    case titleWithImgInTop
    case titleWithImgInSide
}

public enum TabBarSelectionType: Int {
    case bottom
    case full
}

public enum TabBarBadgePosition: Int {
    case aboveImage
    case aboveTitle
}

public class TabBarModel: NSObject {
    let title: String
    let img: String
    let selectedImg: String
    var badgeCount: String
    
    public init(title: String, img: String, selectedImg: String, badgeCount: String) {
        self.title = title
        self.img = img
        self.selectedImg = selectedImg
        self.badgeCount = badgeCount
    }
}

private let ipad = (UIDevice.current.userInterfaceIdiom == .pad)

public struct TabBarCustomParam {
    public var equalWidth: Bool = true
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var titleColor: UIColor = .red
    public var selectedViewColor: UIColor = .blue
    public var selectedTitleColor: UIColor = .white
    public var imgRenderingMode: UIImage.RenderingMode = .alwaysTemplate
    public var imgTintColor: UIColor = .red
    public var selectedImgTintColor: UIColor = .white
    public var showSelectionView: Bool = true
    public var showSelectionCorner: Bool = true
    public var viewSelectionCornerRadius: CGFloat = 12
    public var tabHeight: CGFloat = ipad ? 80 : 60
    public var place: TabBarPlace = .bottom
    public var type: TabBarType = .titleWithImgInTop
    public var selectionType: TabBarSelectionType = .full
    public var titleLeadingTrailingSpacing: CGFloat = 5
    public var imgTopSpacing: CGFloat = 5
    public var imgTitleSpacing: CGFloat = 5
    public var imgLeadingSpacing: CGFloat = 5
    public var titleTopSpacing: CGFloat = 5
    public var titleBottomSpacing: CGFloat = 5
    public let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    public var viewControllers: [UIViewController] = []
    public var tabData: [TabBarModel] = []
    public var selectedControllerIndex: Int = 0
    let viewCenterLeadingTrailing: CGFloat = 0
    let viewCenterTopBottom: CGFloat = 0
    public var imgHeight: CGFloat = ipad ? 40 : 20
    public var viewMainSpacing: CGFloat = 8
    public var viewSelectionHeight: CGFloat = 2
    public var addShadow = false
    public var shadowColor = UIColor.lightGray
    public var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    public var shadowOpacity: Float = 0.3
    public var cornerRadius: CGFloat = 0
    public var cornerTo: UIRectCorner = []
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public var topSafeAreaSpacing: CGFloat = UIApplication.shared.statusBarFrame.size.height
    public var bottomSafeAreaSpacing: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    public var tabColor: UIColor = .yellow
    public var selectionViewTopBottomSpacing: CGFloat = 4
    public var badgeHeight: CGFloat = 15
    public var badgeTextColor: UIColor = .white
    public var badgeBgColor: UIColor = .red
    public var badgeTextFont: UIFont = UIFont.systemFont(ofSize: 12)
    public var hideBadgeOnSelection: Bool = false
    public var badgePosition: TabBarBadgePosition = .aboveImage
    
    public init() {
        
    }
}

public extension Notification.Name {
    enum Keys: String {
        case updateBadgeCount
    }
    
    static let updateBadgeCount = Notification.Name(rawValue: Keys.updateBadgeCount.rawValue)
}

public class CustomTabBarController: UIViewController {
    //MARK:- Variables
    //Private
    private let viewSelectionTag: Int = 1000
    private let viewMainTag: Int = 10000
    private let viewCenterTag: Int = 20000
    private let lblTag: Int = 30000
    private let imgViewTag: Int = 40000
    private let btnTag: Int = 50000
    private let lblBadgeTag: Int = 60000
    private var parentVC: UIViewController
    private var addTabToView: UIView
    private var scrlView = UIScrollView()
    private var viewDummyScrlView = UIView()
    private var viewSelection = UIView()
    private var controllers: [UIViewController] = []
    //Public
    public var customParam = TabBarCustomParam()
    
    //MARK:- Enum
    public enum Keys: String {
        case index
        case badgeValue
    }
    
    //MARK:- Initializers
    public convenience init(param: TabBarCustomParam? = nil, parentVC: UIViewController, toView: UIView) {
        self.init(nibName: nil, bundle: Bundle.main)
        if let param = param {
            customParam = param
        }
        self.parentVC = parentVC
        addTabToView = toView
        setUpVC()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        parentVC = UIViewController()
        addTabToView = UIView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Cannot initialize here.")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateBadgeCount, object: nil)
        for subView in addTabToView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    //MARK:- Private Methods
    private func setUpVC() {
        setUpScrlView()
        if (customParam.showSelectionView) {
            setUpSelectionView()
        }
        setUpViews()
        addNewController()
        handleSmallThanScreenWidth()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (self.customParam.showSelectionView) {
                self.moveSelectionView()
            }
            if (self.customParam.addShadow) {
                self.setUpShadowAndCorner()
            }
        }
    }
    
    private func setUpScrlView() {
        scrlView = UIScrollView(frame: CGRect(x: 0, y: 0, width: customParam.screenWidth, height: customParam.tabHeight))
        scrlView.showsVerticalScrollIndicator = false
        scrlView.showsHorizontalScrollIndicator = false
        scrlView.bounces = false
        scrlView.bouncesZoom = false
        scrlView.translatesAutoresizingMaskIntoConstraints = false
        addTabToView.addSubview(scrlView)
        scrlView.leadingAnchor.constraint(equalTo: addTabToView.leadingAnchor).isActive = true
        scrlView.trailingAnchor.constraint(equalTo: addTabToView.trailingAnchor).isActive = true
        scrlView.heightAnchor.constraint(equalToConstant: customParam.tabHeight).isActive = true
        switch customParam.place {
        case .bottom:
            addTabToView.addConstraint(NSLayoutConstraint(item: scrlView, attribute: .bottom, relatedBy: .equal, toItem: addTabToView, attribute: .bottom, multiplier: 1, constant: -customParam.bottomSafeAreaSpacing))
        case .top:
            addTabToView.addConstraint(NSLayoutConstraint(item: scrlView, attribute: .top, relatedBy: .equal, toItem: addTabToView, attribute: .top, multiplier: 1, constant: customParam.topSafeAreaSpacing))
        }
        if (customParam.addShadow) {
            scrlView.layer.masksToBounds = false
            scrlView.layer.shadowColor = UIColor.shadow.cgColor
            scrlView.layer.shadowOffset = CGSize(width: 0, height: -1)
            scrlView.layer.shadowOpacity = 0.3
            scrlView.layer.zPosition = 0
        }
        addViewBottom()
        addViewDummyToScrlView()
        addObserver()
    }
    
    private func setUpViews() {
        var viewPrevious: UIView?
        for i in 0..<customParam.tabData.count {
            let viewMain = addViewMain(toView: viewDummyScrlView, index: i)
            let viewCenter = addViewCenter(toView: viewMain)
            let lbl = addLbl(toView: viewCenter, index: i)
            let imgView = addImgView(toView: viewCenter, index: i)
            let lblBadge = addBadgeLbl(toView: viewCenter, index: i)
            switch customParam.type {
            case .title:
                lbl.leadingAnchor.constraint(equalTo: viewCenter.leadingAnchor, constant: customParam.titleLeadingTrailingSpacing).isActive = true
                lbl.topAnchor.constraint(equalTo: viewCenter.topAnchor, constant: customParam.titleTopSpacing).isActive = true
                viewCenter.bottomAnchor.constraint(equalTo: lbl.bottomAnchor, constant: customParam.titleBottomSpacing).isActive = true
            case .titleWithImgInTop:
                viewCenter.addSubview(imgView)
                viewCenter.bringSubviewToFront(lblBadge)
                imgView.centerXAnchor.constraint(equalTo: viewCenter.centerXAnchor).isActive = true
                imgView.topAnchor.constraint(equalTo: viewCenter.topAnchor, constant: customParam.imgTopSpacing).isActive = true
                imgView.leadingAnchor.constraint(greaterThanOrEqualTo: viewCenter.leadingAnchor, constant: customParam.imgLeadingSpacing).isActive = true
                imgView.heightAnchor.constraint(equalToConstant: customParam.imgHeight).isActive = true
                imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
                lbl.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: customParam.imgTitleSpacing).isActive = true
                viewCenter.bottomAnchor.constraint(equalTo: lbl.bottomAnchor, constant: customParam.titleBottomSpacing).isActive = true
                lbl.leadingAnchor.constraint(equalTo: viewCenter.leadingAnchor, constant: customParam.titleLeadingTrailingSpacing).isActive = true
            case .titleWithImgInSide:
                viewCenter.addSubview(imgView)
                viewCenter.bringSubviewToFront(lblBadge)
                imgView.centerYAnchor.constraint(equalTo: viewCenter.centerYAnchor, constant: 0).isActive = true
                imgView.leadingAnchor.constraint(equalTo: viewCenter.leadingAnchor, constant: customParam.imgLeadingSpacing).isActive = true
                imgView.topAnchor.constraint(greaterThanOrEqualTo: viewCenter.topAnchor, constant: customParam.imgTopSpacing).isActive = true
                imgView.heightAnchor.constraint(equalToConstant: customParam.imgHeight).isActive = true
                imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
                lbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: customParam.imgTitleSpacing).isActive = true
                lbl.topAnchor.constraint(equalTo: viewCenter.topAnchor, constant: customParam.titleTopSpacing).isActive = true
                viewCenter.bottomAnchor.constraint(equalTo: lbl.bottomAnchor, constant: customParam.titleBottomSpacing).isActive = true
            }
            switch customParam.badgePosition {
            case .aboveImage:
                if (customParam.type == .title) {
                    lblBadge.topAnchor.constraint(equalTo: lbl.topAnchor, constant: -(customParam.badgeHeight/2)).isActive = true
                    lblBadge.trailingAnchor.constraint(equalTo: lbl.trailingAnchor, constant: customParam.badgeHeight/2).isActive = true
                } else {
                    lblBadge.topAnchor.constraint(equalTo: imgView.topAnchor, constant: -(customParam.badgeHeight/2)).isActive = true
                    lblBadge.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: customParam.badgeHeight/2).isActive = true
                }
                viewCenter.trailingAnchor.constraint(equalTo: lbl.trailingAnchor, constant: customParam.titleLeadingTrailingSpacing).isActive = true
            case .aboveTitle:
                lblBadge.topAnchor.constraint(equalTo: lbl.topAnchor, constant: -(customParam.badgeHeight/2)).isActive = true
                lblBadge.trailingAnchor.constraint(equalTo: lbl.trailingAnchor, constant: customParam.badgeHeight/2).isActive = true
                viewCenter.trailingAnchor.constraint(equalTo: lbl.trailingAnchor, constant: customParam.titleLeadingTrailingSpacing).isActive = true
            }
            if (customParam.equalWidth) {
                viewMain.widthAnchor.constraint(equalToConstant: (customParam.screenWidth - (customParam.viewMainSpacing * CGFloat(customParam.tabData.count + 1)) - customParam.edgeInsets.left - customParam.edgeInsets.right)/CGFloat(customParam.tabData.count)).isActive = true
            }
            if (i == 0) {
                viewMain.leadingAnchor.constraint(equalTo: viewDummyScrlView.leadingAnchor, constant: customParam.viewMainSpacing).isActive = true
            } else if (viewPrevious != nil) {
                viewMain.leadingAnchor.constraint(equalTo: viewPrevious!.trailingAnchor, constant: customParam.viewMainSpacing).isActive = true
            }
            if (i == customParam.tabData.count - 1) {
                viewDummyScrlView.trailingAnchor.constraint(equalTo: viewMain.trailingAnchor, constant: customParam.viewMainSpacing).isActive = true
            }
            viewPrevious = viewMain
            addBtn(toView: viewMain, index: i)
        }
    }
    
    private func setUpSelectionView() {
        viewSelection.backgroundColor = customParam.selectedViewColor
        viewSelection.tag = viewSelectionTag
        viewDummyScrlView.addSubview(viewSelection)
        viewDummyScrlView.translatesAutoresizingMaskIntoConstraints = false
        if (customParam.showSelectionCorner) {
            viewSelection.layer.cornerRadius = customParam.viewSelectionCornerRadius
        } else {
            viewSelection.layer.cornerRadius = 0
        }
    }
    
    private func moveSelectionView() {
        for subView in viewDummyScrlView.subviews {
            if (subView.tag == viewMainTag + customParam.selectedControllerIndex) {
                if let viewMain = viewDummyScrlView.viewWithTag(viewMainTag + customParam.selectedControllerIndex) {
                    UIView.animate(withDuration: 0.2) {
                        switch self.customParam.selectionType {
                        case .full:
                            self.viewSelection.frame = CGRect(x: viewMain.frame.origin.x, y: viewMain.frame.origin.y + self.customParam.selectionViewTopBottomSpacing, width: viewMain.frame.width, height: viewMain.frame.size.height - (2 * self.customParam.selectionViewTopBottomSpacing))
                        case .bottom:
                            self.viewSelection.frame = CGRect(x: viewMain.frame.origin.x, y: viewMain.frame.size.height - self.customParam.viewSelectionHeight, width: viewMain.frame.size.width, height: self.customParam.viewSelectionHeight)
                        }
                    }
                }
            }
        }
    }
    
    private func addViewBottom() {
        let viewBottom = UIView()
        viewBottom.backgroundColor = customParam.tabColor
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        addTabToView.addSubview(viewBottom)
        viewBottom.leadingAnchor.constraint(equalTo: addTabToView.leadingAnchor).isActive = true
        viewBottom.trailingAnchor.constraint(equalTo: addTabToView.trailingAnchor).isActive = true
        viewBottom.bottomAnchor.constraint(equalTo: addTabToView.bottomAnchor).isActive = true
        viewBottom.heightAnchor.constraint(equalToConstant: customParam.bottomSafeAreaSpacing).isActive = true
    }
    
    private func addViewDummyToScrlView() {
        viewDummyScrlView = UIView(frame: CGRect(x: 0, y: 0, width: scrlView.frame.size.width, height: scrlView.frame.size.height))
        viewDummyScrlView.translatesAutoresizingMaskIntoConstraints = false
        viewDummyScrlView.backgroundColor = customParam.tabColor
        scrlView.addSubview(viewDummyScrlView)
        viewDummyScrlView.topAnchor.constraint(equalTo: scrlView.topAnchor, constant: customParam.edgeInsets.top).isActive = true
        viewDummyScrlView.leadingAnchor.constraint(equalTo: scrlView.leadingAnchor, constant: customParam.edgeInsets.left).isActive = true
        viewDummyScrlView.bottomAnchor.constraint(equalTo: scrlView.bottomAnchor, constant: -customParam.edgeInsets.bottom).isActive = true
        viewDummyScrlView.trailingAnchor.constraint(equalTo: scrlView.trailingAnchor, constant: -customParam.edgeInsets.right).isActive = true
        viewDummyScrlView.heightAnchor.constraint(equalToConstant: customParam.tabHeight - customParam.edgeInsets.top - customParam.edgeInsets.bottom).isActive = true
    }
    
    private func addObserver() {
        NotificationCenter.default.removeObserver(self, name: .updateBadgeCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeCount(_:)), name: .updateBadgeCount, object: nil)
    }
    
    private func addViewMain(toView: UIView, index: Int) -> UIView {
        let viewMain = UIView()
        viewMain.tag = viewMainTag + index
        viewMain.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(viewMain)
        viewMain.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        viewMain.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        return viewMain
    }
    
    private func addViewCenter(toView: UIView) -> UIView {
        let viewCenter = UIView()
        viewCenter.tag = viewCenterTag
        viewCenter.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(viewCenter)
        viewCenter.topAnchor.constraint(greaterThanOrEqualTo: toView.topAnchor).isActive = true
        viewCenter.centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
        viewCenter.leadingAnchor.constraint(greaterThanOrEqualTo: toView.leadingAnchor).isActive = true
        viewCenter.centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
        return viewCenter
    }
    
    private func addLbl(toView: UIView, index: Int) -> UILabel {
        let lbl = UILabel()
        lbl.tag = lblTag
        if (index == customParam.selectedControllerIndex) {
            lbl.textColor = customParam.selectedTitleColor
        } else {
            lbl.textColor = customParam.titleColor
        }
        lbl.font = customParam.titleFont
        if (customParam.tabData.indices.contains(index)) {
            lbl.text = customParam.tabData[index].title
        }
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(lbl)
        return lbl
    }
    
    private func addBadgeLbl(toView: UIView, index: Int) -> UILabel {
        let lbl = UILabel()
        lbl.tag = lblBadgeTag
        lbl.textColor = customParam.badgeTextColor
        lbl.font = customParam.badgeTextFont
        lbl.backgroundColor = customParam.badgeBgColor
        if (customParam.tabData.indices.contains(index)) {
            lbl.text = customParam.tabData[index].badgeCount
            lbl.isHidden = customParam.tabData[index].badgeCount.isEmpty
        }
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(lbl)
        lbl.heightAnchor.constraint(equalToConstant: customParam.badgeHeight).isActive = true
        lbl.widthAnchor.constraint(equalTo: lbl.heightAnchor).isActive = true
        lbl.layer.cornerRadius = customParam.badgeHeight/2
        lbl.layer.masksToBounds = true
        return lbl
    }
    
    private func addImgView(toView: UIView, index: Int) -> UIImageView {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.tag = imgViewTag
        if !(customParam.tabData[index].img.isEmpty) {
            imgView.image = UIImage(named: customParam.tabData[index].img)?.withRenderingMode(customParam.imgRenderingMode)
        }
        if (customParam.imgRenderingMode == .alwaysTemplate) {
            if (customParam.tabData[index].selectedImg.isEmpty) {
                if (index == customParam.selectedControllerIndex) {
                    imgView.tintColor = customParam.selectedImgTintColor
                } else {
                    imgView.tintColor = customParam.imgTintColor
                }
            } else {
                if (index == customParam.selectedControllerIndex) {
                    imgView.image = UIImage(named: customParam.tabData[index].selectedImg)
                } else {
                    imgView.image = UIImage(named: customParam.tabData[index].img)
                }
            }
        }
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
    
    private func addBtn(toView: UIView, index: Int) {
        let btn = UIButton(type: .custom)
        btn.tag = btnTag + index
        btn.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(btn)
        btn.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        btn.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        btn.addTarget(self, action: #selector(changeSelection(_:)), for: .touchUpInside)
    }
    
    private func addConstraints(toVC: UIViewController) {
        toVC.view.translatesAutoresizingMaskIntoConstraints = false
        toVC.view.leadingAnchor.constraint(equalTo: addTabToView.leadingAnchor).isActive = true
        toVC.view.trailingAnchor.constraint(equalTo: addTabToView.trailingAnchor).isActive = true
        switch customParam.place {
        case .bottom:
            addTabToView.addConstraint(NSLayoutConstraint(item: toVC.view as Any, attribute: .top, relatedBy: .equal, toItem: addTabToView, attribute: .top, multiplier: 1, constant: 0))
            toVC.view.bottomAnchor.constraint(equalTo: scrlView.topAnchor).isActive = true
        case .top:
            toVC.view.topAnchor.constraint(equalTo: scrlView.bottomAnchor).isActive = true
            addTabToView.addConstraint(NSLayoutConstraint(item: toVC.view as Any, attribute: .bottom, relatedBy: .equal, toItem: addTabToView, attribute: .bottom, multiplier: 1, constant: -customParam.bottomSafeAreaSpacing))
        }
    }
    
    private func handleSmallThanScreenWidth() {
        viewDummyScrlView.setNeedsLayout()
        viewDummyScrlView.layoutIfNeeded()
        if (!(customParam.equalWidth) && (viewDummyScrlView.frame.size.width < customParam.screenWidth)) {
            for subView in viewDummyScrlView.subviews {
                if (subView.tag != viewSelectionTag) {
                    subView.widthAnchor.constraint(equalToConstant: (customParam.screenWidth - (customParam.viewMainSpacing * CGFloat(customParam.tabData.count + 1)) - customParam.edgeInsets.left - customParam.edgeInsets.right)/CGFloat(customParam.tabData.count)).isActive = true
                }
            }
        }
    }
    
    private func setUpShadowAndCorner() {
        viewDummyScrlView.layer.shadowColor = customParam.shadowColor.cgColor
        viewDummyScrlView.layer.masksToBounds = false
        viewDummyScrlView.layer.shadowOffset = customParam.shadowOffset
        viewDummyScrlView.layer.shadowOpacity = customParam.shadowOpacity
        viewDummyScrlView.layer.zPosition = 1
        let path = UIBezierPath(roundedRect: viewDummyScrlView.bounds, byRoundingCorners: customParam.cornerTo, cornerRadii: CGSize(width: customParam.cornerRadius, height: customParam.cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        viewDummyScrlView.layer.mask = mask
    }
    
    private func removeOldController() {
        if (customParam.viewControllers.indices.contains(customParam.selectedControllerIndex)) {
            let currentVC: UIViewController = customParam.viewControllers[customParam.selectedControllerIndex]
            currentVC.willMove(toParent: nil)
            currentVC.removeFromParent()
            currentVC.view.removeFromSuperview()
            currentVC.didMove(toParent: nil)
        }
    }
    
    private func addNewController() {
        if (customParam.viewControllers.indices.contains(customParam.selectedControllerIndex)) {
            let VC: UIViewController = customParam.viewControllers[customParam.selectedControllerIndex]
            VC.willMove(toParent: parentVC)
            parentVC.addChild(VC)
            addTabToView.addSubview(VC.view)
            addConstraints(toVC: VC)
            VC.didMove(toParent: parentVC)
        }
    }
    
    private func changeSelectionView() {
        if (customParam.showSelectionView) {
            moveSelectionView()
        }
        for subView in viewDummyScrlView.subviews {
            if let viewCenter = subView.viewWithTag(viewCenterTag) {
                if let lbl = viewCenter.viewWithTag(lblTag) as? UILabel {
                    if (subView.tag == viewMainTag + customParam.selectedControllerIndex) {
                        lbl.textColor = customParam.selectedTitleColor
                    } else {
                        lbl.textColor = customParam.titleColor
                    }
                }
                if (customParam.type != .title && customParam.imgRenderingMode == .alwaysTemplate) {
                    if let imgView = viewCenter.viewWithTag(imgViewTag) as? UIImageView {
                        if (customParam.tabData[subView.tag - viewMainTag].selectedImg.isEmpty && customParam.imgRenderingMode == .alwaysTemplate) {
                            if (subView.tag == viewMainTag + customParam.selectedControllerIndex) {
                                imgView.tintColor = customParam.selectedImgTintColor
                            } else {
                                imgView.tintColor = customParam.imgTintColor
                            }
                        } else {
                            if (subView.tag == viewMainTag + customParam.selectedControllerIndex) {
                                imgView.image = UIImage(named: customParam.tabData[subView.tag - viewMainTag].selectedImg)
                            } else {
                                imgView.image = UIImage(named: customParam.tabData[subView.tag - viewMainTag].img)
                            }
                        }
                    }
                }
                if let lbl = viewCenter.viewWithTag(lblBadgeTag) as? UILabel {
                    if ((subView.tag == viewMainTag + customParam.selectedControllerIndex) && (customParam.hideBadgeOnSelection)) {
                        lbl.text = ""
                        lbl.isHidden = true
                    }
                }
            }
        }
    }
    
    //MARK:- Public Methods
    public func changeTabIndex(to: Int) {
        removeOldController()
        customParam.selectedControllerIndex = to
        addNewController()
        changeSelectionView()
    }
    
    //MARK:- Selector Methods
    @objc private func changeSelection(_ sender: UIButton) {
        removeOldController()
        customParam.selectedControllerIndex = sender.tag - btnTag
        addNewController()
        changeSelectionView()
    }
    
    @objc private func updateBadgeCount(_ sender: Notification) {
        if let obj = sender.object as? [String : Any], let index = obj[Keys.index.rawValue] as? Int, let badgeValue = obj[Keys.badgeValue.rawValue] as? Int {
            if (customParam.tabData.indices.contains(index)) {
                for subView in viewDummyScrlView.subviews {
                    if (subView.tag - viewMainTag == index) {
                        if let lbl = subView.viewWithTag(lblBadgeTag) as? UILabel {
                            if (badgeValue >= 100) {
                                lbl.text = "99+"
                            } else {
                                lbl.text = "\(badgeValue)"
                            }
                            lbl.isHidden = badgeValue == 0
                        }
                    }
                }
            }
        }
    }
}

private extension UIColor {
    class var shadow: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        } else {
            return .lightGray
        }
    }
}
