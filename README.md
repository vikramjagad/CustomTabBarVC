# CustomTabBarVC

Custom Tab Bar with options for modification.

Library for Custom Tab Bar Controller. Custom options available according to type specified in Custom Tab Bar Params.

# Add as Pod

    pod 'CustomTabBarVC'
    
# Add as Swift Package Manager
    
    https://github.com/vikramjagad/CustomTabBarVC.git

# How to use?


    let subVC1 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
    subVC1.title = "VC 1"
    let subVC2 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
    subVC2.title = "VC 2"
    let subVC3 = UIStoryboard(name: "Sub", bundle: .main).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
    subVC3.title = "VC 3"
    tabParam.viewControllers = [subVC1, subVC2, subVC3]
    tabParam.tabData = [TabModel(title: "VC 1", img: "ic_account", selectedImg: "", badgeCount: ""),
                        TabModel(title: "VC 2", img: "ic_camera", selectedImg: "", badgeCount: ""),
                        TabModel(title: "VC 3", img: "ic_delete", selectedImg: "", badgeCount: "")]
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


![Simulator Screen Shot - iPhone SE (2nd generation) - 2021-03-09 at 14 52 11](https://user-images.githubusercontent.com/68367137/110448452-3a5e6e80-80e7-11eb-96db-7a064f771568.png)

![Simulator Screen Shot - iPhone SE (2nd generation) - 2021-03-09 at 14 52 15](https://user-images.githubusercontent.com/68367137/110448461-3b8f9b80-80e7-11eb-9a19-4d16ca656a9a.png)

![Simulator Screen Shot - iPhone SE (2nd generation) - 2021-03-09 at 14 52 24](https://user-images.githubusercontent.com/68367137/110448463-3c283200-80e7-11eb-88bd-54a2ef108880.png)

![Simulator Screen Shot - iPhone SE (2nd generation) - 2021-03-09 at 14 52 29](https://user-images.githubusercontent.com/68367137/110448464-3cc0c880-80e7-11eb-8652-d77b5ecb4351.png)

![Simulator Screen Shot - iPhone SE (2nd generation) - 2021-03-09 at 14 52 40](https://user-images.githubusercontent.com/68367137/110448467-3d595f00-80e7-11eb-98d1-c84c34782b45.png)

![Simulator Screen Shot - iPhone SE (2nd generation) - 2021-03-09 at 14 52 54](https://user-images.githubusercontent.com/68367137/110448469-3df1f580-80e7-11eb-8875-ec593d9eb559.png)
