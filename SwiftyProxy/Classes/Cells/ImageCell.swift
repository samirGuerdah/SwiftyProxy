//  Created by Samir on 17/07/2018.

import Foundation

class ImageCell: UITableViewCell {

    static let kReuseIdentifier = "ImageCell"

    var label = UILabel(frame: .zero)
    var contentImageView = UIImageView(frame: .zero)

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = FontType.fontFor(type: .regular)
        label.textColor = Color.colorFor(type: .black)
        contentView.addSubview(label)

        contentView.addSubview(contentImageView)
        contentImageView.translatesAutoresizingMaskIntoConstraints = false

        // Layout
        let marginGuide = self.layoutMarginsGuide
        label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true

        contentImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        contentImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        contentImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        contentImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        contentImageView.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 749),
                                                                 for: UILayoutConstraintAxis.vertical)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fillWith(data: Data) {
        if let image = UIImage(data: data) {
            contentImageView.image = image
            label.text = "\(image.size.width) pt x \(image.size.height) pt"
        }
    }
}
