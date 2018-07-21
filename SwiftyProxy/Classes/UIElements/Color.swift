//  Created by Samir on 05/07/2018.

import Foundation

enum Color {
    case black
    case orange
    case blue
    case red
    case gray

    static func coloForHttpResponseCode(_ code: Int) -> UIColor {
        if code >= 500 {
            return Color.colorFor(type: .red)
        } else if code >= 400 {
            return Color.colorFor(type: .orange)
        } else if code >= 300 {
            return Color.colorFor(type: .blue)
        }
        return Color.colorFor(type: .black)
    }

    static func colorFor(type: Color) -> UIColor {
        switch type {
        case .black: return UIColor.black
        case .red: return UIColor.red
        case .orange: return UIColor.orange
        case .blue: return UIColor.blue
        case .gray: return UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        }
    }
}
