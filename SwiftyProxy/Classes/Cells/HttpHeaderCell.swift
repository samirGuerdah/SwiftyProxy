//  Created by Samir on 07/01/2018.

import UIKit

class HttpHeaderCell: UITableViewCell {

    static let kHttpHeaderCellReuseIdentifier = "HttpHeaderCellReuseIdentifier"
    static let kTextCellReuseIdentifier = "TextCellReuseIdentifier"

    var label = UILabel(frame: .zero)

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = FontType.fontFor(type: .regular)
        label.textColor = Color.colorFor(type: .gray)
        contentView.addSubview(label)

        // Layout
        let marginGuide = self.layoutMarginsGuide
        label.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fillWith(key: AnyHashable, value: Any?) {
        if let value = value {
            let boldFont = FontType.fontFor(type: .bold)
            let attributesDic = [NSAttributedStringKey.font: boldFont,
                                 NSAttributedStringKey.foregroundColor: Color.colorFor(type: .black)]
            let valueAttributedString = NSAttributedString(string: "\(value)")
            let keyAttributedString = NSMutableAttributedString(string: "\(key): ", attributes: attributesDic)
            keyAttributedString.append(valueAttributedString)
            self.label.attributedText = keyAttributedString
        }
    }
}
