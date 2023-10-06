//
//  TabBarController.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 10/6/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = ViewController()
        firstViewController.tabBarItem.title = "First"

        let secondViewController = TempVC()
        secondViewController.tabBarItem.title = "Second"

        // 3. 뷰 컨트롤러들을 viewControllers 프로퍼티에 할당
        self.viewControllers = [firstViewController, secondViewController]

        // 최초 선택될 탭 설정 (0부터 시작)
        self.selectedIndex = 0
    }
}
