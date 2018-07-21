//  Created by Samir on 13/07/2018.

import Foundation

enum FontType {
    case regular
    case bold
    case small
}

extension FontType {
    static func fontFor(type: FontType) -> UIFont {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        let bodyFontDescriptor = bodyFont.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits.traitBold)
        let smallFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)

        switch type {
        case .regular:
            return bodyFont
        case .bold:
            return UIFont(descriptor: bodyFontDescriptor!, size: 0)
        case .small:
            return smallFont
        }
    }
}
