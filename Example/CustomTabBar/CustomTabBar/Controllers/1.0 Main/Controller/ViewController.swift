//
//  ViewController.swift
//  TabDemo
//
//  Created by Vikram Jagad on 09/03/21.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- Interface Builder
    //UIView
    @IBOutlet weak var viewContainer: UIView!
    
    //UITextField
    @IBOutlet weak var tfCorner: UITextField!
    @IBOutlet weak var tfIndex: UITextField!
    @IBOutlet weak var tfBadgeCount: UITextField!
    
    //MARK:- Variables
    //Private
    private var tabParam = TabBarCustomParam()
    private var tabViewController: CustomTabBarController!
    var controllers: [UIViewController] = []
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    //MARK:- Private Methods
    private func setUpVC() {
        setUpTextFields()
        setUpTabParams()
        setUpTab()
    }
    
    private func setUpTextFields() {
        tfCorner.delegate = self
        tfIndex.delegate = self
        tfBadgeCount.delegate = self
    }
    
    private func setUpTabParams() {
        let subVC1 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC1.title = "VC 1"
        let subVC2 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC2.title = "VC 2"
        let subVC3 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC3.title = "VC 3"
        let subVC4 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC4.title = "VC 4"
        let subVC5 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC5.title = "VC 5"
        let subVC6 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC6.title = "VC 6"
        let subVC7 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC7.title = "VC 7"
        let subVC8 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC8.title = "VC 8"
        let subVC9 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subVC9.title = "VC 9"
        tabParam.viewControllers = [subVC1, subVC2, subVC3, subVC4, subVC5, subVC6, subVC7, subVC8, subVC9]
        tabParam.tabData = [TabBarModel(title: "VC 1", img: "ic_account", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 2", img: "ic_camera", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 3", img: "ic_delete", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 4", img: "ic_account", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 5", img: "ic_camera", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 6", img: "ic_delete", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 6", img: "ic_account", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 7", img: "ic_camera", selectedImg: "", badgeCount: ""),
                            TabBarModel(title: "VC 8", img: "ic_delete", selectedImg: "", badgeCount: "")]
        tabParam.place = .top
        tabParam.type = .title
        tabParam.equalWidth = false
        tabParam.showSelectionView = false
        tabParam.tabColor = .white
        tabParam.titleColor = .black
        tabParam.imgTintColor = .black
        tabParam.selectedTitleColor = .red
        tabParam.selectedImgTintColor = .red
        tabParam.viewMainSpacing = 4
        tabParam.imgLeadingSpacing = 16
        tabParam.titleLeadingTrailingSpacing = 16
        tabParam.tabHeight = 40
        tabParam.addShadow = true
        tabParam.cornerRadius = 0
        tabParam.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        tabParam.shadowOffset = CGSize(width: 0, height: 1)
        tabParam.cornerTo = [.bottomLeft, .bottomRight]
        tabParam.titleFont = .systemFont(ofSize: 16)
        tabParam.badgeBgColor = .red
        tabParam.badgeTextFont = .systemFont(ofSize: 12)
        tabParam.badgeTextColor = .white
        tabParam.selectedViewColor = .red
        tabParam.badgeHeight = 20
        tabParam.hideBadgeOnSelection = true
        tabParam.badgePosition = .aboveImage
    }
    
    private func setUpTab() {
        tabViewController = nil
        tabViewController = CustomTabBarController(param: tabParam, parentVC: self, toView: viewContainer)
    }
    
    //MARK:- Actions
    @IBAction func segmentControlPlaceValueChangedHandler(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            tabParam.place = .top
            tabParam.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
            tabParam.shadowOffset = CGSize(width: 0, height: 1)
            tabParam.cornerTo = [.bottomLeft, .bottomRight]
        } else if (sender.selectedSegmentIndex == 1) {
            tabParam.place = .bottom
            tabParam.edgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
            tabParam.shadowOffset = CGSize(width: 0, height: -1)
            tabParam.cornerTo = [.topLeft, .topRight]
        }
        setUpTab()
    }
    
    @IBAction func segmentControlTypeValueChangedHandler(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            tabParam.type = .title
            tabParam.tabHeight = 45
        } else if (sender.selectedSegmentIndex == 1) {
            tabParam.type = .titleWithImgInTop
            tabParam.tabHeight = 65
        } else if (sender.selectedSegmentIndex == 2) {
            tabParam.type = .titleWithImgInSide
            tabParam.tabHeight = 45
        }
        setUpTab()
    }
    
    @IBAction func segmentControlSelectionTypeValueChangedHandler(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            tabParam.showSelectionView = false
            tabParam.selectedTitleColor = .red
            tabParam.selectedImgTintColor = .red
        } else if (sender.selectedSegmentIndex == 1) {
            tabParam.showSelectionView = true
            tabParam.selectionType = .full
            tabParam.selectedTitleColor = .white
            tabParam.selectedImgTintColor = .white
        } else if (sender.selectedSegmentIndex == 2) {
            tabParam.showSelectionView = true
            tabParam.selectionType = .bottom
            tabParam.selectedTitleColor = .red
            tabParam.selectedImgTintColor = .red
        }
        setUpTab()
    }
    
    @IBAction func segmentControlShowShadowValueChangedHandler(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            tabParam.addShadow = true
        } else if (sender.selectedSegmentIndex == 0) {
            tabParam.addShadow = false
        }
        setUpTab()
    }
    
    @IBAction func segmentControlBadgePositionValueChangedHandler(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            tabParam.badgePosition = .aboveImage
        } else if (sender.selectedSegmentIndex == 1) {
            tabParam.badgePosition = .aboveTitle
        }
        setUpTab()
    }
}

//MARK:- UITextFieldDelegate Methods
extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == tfCorner) {
            tabParam.cornerRadius = CGFloat(getInteger(anything: textField.text))
            setUpTab()
        } else {
            let dictObj = [CustomTabBarController.Keys.index.rawValue: getInteger(anything: tfIndex.text),
                           CustomTabBarController.Keys.badgeValue.rawValue: getInteger(anything: tfBadgeCount.text)]
            NotificationCenter.default.post(name: .updateBadgeCount, object: dictObj)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return true
        }
        if (string.isEmpty) {
            return true
        }
        let fullString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        let numberSet = CharacterSet(charactersIn: "1234567890").inverted
        let compSepByCharInSet = string.components(separatedBy: numberSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if (string == numberFiltered) {
            if ((textField == tfIndex) && (getInteger(anything: fullString) > (tabParam.viewControllers.count - 1))) {
                return false
            } else if ((textField == tfCorner) && (getInteger(anything: fullString) > (Int(tabParam.tabHeight)/2))) {
                return false
            }
            return true
        } else {
            return false
        }
    }
}

func getInteger(anything: Any?) -> Int {
    if let any:Any = anything {
        if let num = any as? NSNumber {
            return num.intValue
        } else if let str = any as? NSString {
            return str.integerValue
        }
    }
    return 0
}
