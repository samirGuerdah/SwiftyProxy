//  Created by Samir on 22/05/2018.

import UIKit

public class FloatingButtonVC: UIViewController {
    private(set) var button: UIButton!

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = CGFloat.greatestFiniteMagnitude
        window.isHidden = false
        window.rootViewController = self
    }

    private let window = FloatingButtonWindow()

    override public func loadView() {
        let view = UIView()
        let button = UIButton(type: .custom)

        let bundle = Bundle(for: FloatingButtonVC.self)
        let image = UIImage(named: "proxy.png", in: bundle, compatibleWith: nil)

        button.setImage(image, for: UIControlState.normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.sizeToFit()
        let screenSize = UIScreen.main.bounds.size
        button.frame = CGRect(origin: CGPoint(x: screenSize.width-60, y: screenSize.height-60), size: CGSize(width: 48, height: 48))
        button.autoresizingMask = []
        view.addSubview(button)
        self.view = view
        self.button = button
        window.button = button
        view.frame = button.bounds

        /// Pan gesture
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:)))
        button.addGestureRecognizer(panner)

        /// Tap action
        button.addTarget(self, action: #selector(tapAction), for: UIControlEvents.touchUpInside)
    }

    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var center = button.center
        center.x += offset.x
        center.y += offset.y
        button.center = center
    }

    @objc func tapAction() {
        let httpTransactions = HttpTransactionIntercepter.shared.httpTransactions
        let responseVC = RequestListVC(httpTransactionList: httpTransactions)
        let navigationController = UINavigationController(rootViewController: responseVC)
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        }
        self.present(navigationController, animated: true)
    }
}
