//  Created by Samir Guerdah on 15/11/2017.

import UIKit

class RequestCell: UITableViewCell {

    /// The reuse identifier for the loading http transaction type cell
    static let kLoadingCellIdentifier = "LoadingCellIdentifier"

    /// The reuse identifier for the comlpleted http transaction type cell
    static let kCompletedCellIdentifier = "CompletedCellIdentifier"

    // MARK: Properties
    var httpCodeLabel = UILabel(frame: .zero)
    var pathLabel = UILabel(frame: .zero)
    var hostLabel = UILabel(frame: .zero)
    var timeLabel = UILabel(frame: .zero)
    var durationLabel = UILabel(frame: .zero)
    var activityIndicatorView = UIActivityIndicatorView(frame: .zero)
    let leftContainerView = UIView(frame: .zero)

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        guard let cellIdentifier = reuseIdentifier else {
            fatalError("reuseIdentifier nil")
        }
        setupUIElements(reuseIdentifier: cellIdentifier)
        layoutUIElement(reuseIdentifier: cellIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fillWith(httpTransaction: HttpTransaction) {
        guard let cellIdentifier = reuseIdentifier else {
            fatalError("reuseIdentifier nil")
        }

        if cellIdentifier == RequestCell.kLoadingCellIdentifier {
            activityIndicatorView.startAnimating()
        }
        if cellIdentifier == RequestCell.kCompletedCellIdentifier {
            if let code = httpTransaction.httpResponse?.statusCode {
                httpCodeLabel.text = "\(code)"
                httpCodeLabel.textColor = Color.coloForHttpResponseCode(code)
            } else {
                httpCodeLabel.text = "!!"
                httpCodeLabel.textColor = Color.colorFor(type: .red)
            }
        }
        if let httpMethod = httpTransaction.httpMethod, let path = httpTransaction.url?.path {
            pathLabel.text = "\(httpMethod) \(path)"
        }
        if let host = httpTransaction.url?.host {
            hostLabel.text = host
        }
        if let fetchStartDate = httpTransaction.fetchStartDate {
            let timeFormatter = Formatter.timeFormatter
            timeLabel.text = timeFormatter.string(from: fetchStartDate)
        }
        durationLabel.text = httpTransaction.transactionDuration
        contentView.layoutIfNeeded()
    }

    func setupUIElements(reuseIdentifier: String) {
        let bodyBoldFont = FontType.fontFor(type: .bold)
        let smallFont = FontType.fontFor(type: .small)
        leftContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftContainerView)

        if reuseIdentifier == RequestCell.kCompletedCellIdentifier {
            httpCodeLabel.numberOfLines = 0
            httpCodeLabel.font = bodyBoldFont
            httpCodeLabel.translatesAutoresizingMaskIntoConstraints = false
            leftContainerView.addSubview(httpCodeLabel)
        }
        if reuseIdentifier == RequestCell.kLoadingCellIdentifier {
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.activityIndicatorViewStyle = .gray
            activityIndicatorView.isHidden = false
            leftContainerView.addSubview(activityIndicatorView)
        }

        pathLabel.numberOfLines = 0
        pathLabel.font = bodyBoldFont
        pathLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pathLabel)

        hostLabel.numberOfLines = 0
        hostLabel.font = smallFont
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostLabel)

        timeLabel.numberOfLines = 0
        timeLabel.font = smallFont
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)

        durationLabel.numberOfLines = 0
        durationLabel.font = smallFont
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationLabel)
    }

    func layoutUIElement(reuseIdentifier: String) {
        let marginGuide = contentView.layoutMarginsGuide

        leftContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leftContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        leftContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        leftContainerView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        if reuseIdentifier == RequestCell.kLoadingCellIdentifier {
            activityIndicatorView.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: leftContainerView.centerYAnchor).isActive = true
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        if reuseIdentifier == RequestCell.kCompletedCellIdentifier {
            httpCodeLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
            httpCodeLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
            httpCodeLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        }

        pathLabel.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 8).isActive = true
        pathLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        pathLabel.trailingAnchor.constraint(lessThanOrEqualTo: marginGuide.trailingAnchor).isActive = true
        pathLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)

        hostLabel.trailingAnchor.constraint(lessThanOrEqualTo: marginGuide.trailingAnchor).isActive = true
        hostLabel.leadingAnchor.constraint(equalTo: pathLabel.leadingAnchor).isActive = true
        hostLabel.topAnchor.constraint(equalTo: pathLabel.bottomAnchor, constant: 3).isActive = true

        timeLabel.leadingAnchor.constraint(equalTo: pathLabel.leadingAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 3).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

        durationLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        durationLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
    }
}
