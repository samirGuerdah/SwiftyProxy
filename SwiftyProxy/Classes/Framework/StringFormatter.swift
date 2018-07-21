//  Created by Samir on 06/07/2018.

import Foundation

func JSONStringify(value: Any, prettyPrinted: Bool = true) -> String {
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
    if JSONSerialization.isValidJSONObject(value) {
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: options!)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        } catch {
            return ""
        }
    }
    return ""
}
