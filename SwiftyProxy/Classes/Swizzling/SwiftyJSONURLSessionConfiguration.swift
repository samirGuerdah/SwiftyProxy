
//  Created by Samir on 23/07/2018.

import Foundation

internal private(set) var defaultSessionConf: URLSessionConfiguration?
internal private(set) var ephemeralSessionConf: URLSessionConfiguration?

private let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getClassMethod(forClass, originalSelector),
        let swizzledMethod = class_getClassMethod(forClass, swizzledSelector) else { return }

    let origImplementation = method_getImplementation(originalMethod)
    let newImplementation = method_getImplementation(swizzledMethod)

    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension URLSessionConfiguration {
    @objc public static func swizzleSessionConfigurations() {
        let originalDefault = #selector(getter: URLSessionConfiguration.self.default)
        let swizzledDefault = #selector(getter: swizzled_default)

        let originalEphemeral = #selector(getter: URLSessionConfiguration.self.ephemeral)
        let swizzledEphemeral = #selector(getter: swizzled_ephemeral)

        swizzling(URLSessionConfiguration.self, originalDefault, swizzledDefault)
        swizzling(URLSessionConfiguration.self, originalEphemeral, swizzledEphemeral)
    }

    @objc fileprivate class var swizzled_default: URLSessionConfiguration {
        get {
            let conf = self.swizzled_default
            defaultSessionConf = conf
            SwiftyProxy.registerSessionConfiguration(conf)
            return conf
        }
    }

    @objc fileprivate class var swizzled_ephemeral: URLSessionConfiguration {
        get {
            let conf = self.swizzled_ephemeral
            ephemeralSessionConf = conf
            SwiftyProxy.registerSessionConfiguration(conf)
            return conf
        }
    }
}
