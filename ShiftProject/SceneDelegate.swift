import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let session = UserSessionService()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let ws = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: ws)
        let nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window

        if self.session.isAuthorized {
            let mainVC = MainModuleBuilder.build()
            nav.setViewControllers([mainVC], animated: false)
        } else {
            let regVC = RegistrationModuleBuilder.build()
            nav.setViewControllers([regVC], animated: false)
        }

        nav.navigationBar.prefersLargeTitles = true
    }
}
