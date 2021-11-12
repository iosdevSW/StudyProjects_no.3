//
//  SceneDelegate.swift
//  Chapter03-TabBar
//
//  Created by 신상우 on 2021/11/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let tbC = self.window?.rootViewController as? UITabBarController {
            if let tbItems = tbC.tabBar.items{
//                tbItems[0].image = UIImage(named:"calendar.png")
//                tbItems[1].image = UIImage(named: "file-tree.png")
//                tbItems[2].image = UIImage(named:"photo")
                
                tbItems[0].image = UIImage(named:"designbump")?.withRenderingMode(.alwaysOriginal)
                tbItems[1].image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
                tbItems[2].image = UIImage(named:"facebook")?.withRenderingMode(.alwaysOriginal)
                //이미지를 템플릿에 맞춰 렌더링하지않고 원본 이미지 그대로 가져오는 메소드. 기억하자!!
                
                //이미지템플릿으로 렌더링 하지 않으면 하이라이팅 기능도 사라진다. 임의로 하이라이팅 넣기!
                for tbItem in tbItems {
                    let image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
                    tbItem.selectedImage = image
                    //title 속성 커스터마이징
//                    tbItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .disabled)
//                    tbItem.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
//                    tbItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15)], for: .normal)
                }
                //위에 했던 title 속성 커스터마이징을 외형 프록시 객체를 이용하여 설정.
                //화면 요소별 속성을 공통적으로 적용할 수 있는 객체
                let tbItemProxy = UITabBarItem.appearance()
                tbItemProxy.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
                tbItemProxy.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .disabled)
                tbItemProxy.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15)], for: .normal)
                
                tbItems[0].title = "calendar"
                tbItems[1].title = "file"
                tbItems[2].title = "photo"
            }
            tbC.tabBar.tintColor = .white // 선택된 탭 바 아이템의 색상 설정
            tbC.tabBar.unselectedItemTintColor = .gray //선택되지 않은 아이템의 색상 설정
            tbC.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0) // 이미지 늘리기( 인자값 좌표의 그림만 늘리고 나머지 그림은 양쪽 상하좌우에 붙음)
            
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

