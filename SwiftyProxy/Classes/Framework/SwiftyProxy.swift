
//  Created by Samir on 27/07/2018.

import Foundation

open class SwiftyProxy: NSObject {
    public static let shared = SwiftyProxy()
    var enabled = false

    @objc public class func enable() {
        SwiftyProxy.shared.enabled = true

        // Enable the NSURLSession sharedSession && NSURLConeexion requests interception
        URLProtocol.registerClass(SwiftyProxyURLProtocol.self);

        // Add a floating button if needed
        var floatingButtonAlreadyAdded = false
        UIApplication.shared.windows.forEach { (window) in
            if window is FloatingButtonWindow {
                floatingButtonAlreadyAdded = true
            }
        }
        if !floatingButtonAlreadyAdded {
            _ = FloatingButtonVC()
        }
    }
}
