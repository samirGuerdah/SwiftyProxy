//  Created by Samir on 04/01/2018.

import UIKit

class KeyValueCell: UITableViewCell {

    static let kReuseIdentifier = "KeyValueCell"

    /// UI properties
    var keyLabel = UILabel(frame: .zero)
    var valueLabel = UILabel(frame: .zero)

    /// Inits
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        let regularFont = FontType.fontFor(type: .regular)
        let boldGont = FontType.fontFor(type: .bold)

        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        keyLabel.numberOfLines = 0
        keyLabel.font = boldGont
        contentView.addSubview(keyLabel)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.numberOfLines = 0
        valueLabel.font = regularFont
        valueLabel.textColor = Color.colorFor(type: .gray)
        contentView.addSubview(valueLabel)

        // Layout
        keyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        keyLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        keyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        keyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        keyLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -25).isActive = true

        valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                             constant: -16).isActive = true
        valueLabel.topAnchor.constraint(equalTo: keyLabel.topAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        valueLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow,
                                                           for: UILayoutConstraintAxis.horizontal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //swiftlint:disable:next cyclomatic_complexity function_body_length
    func fillCell(rowType: OverviewRowType, httpTransaction: HttpTransaction) {
        self.keyLabel.text = rowType.rawValue
        self.valueLabel.text = "--"
        let request = httpTransaction.request
        let formatter = Formatter.dateFormatter

        switch rowType {
        case .url: self.valueLabel.text = request.url?.absoluteString
        case .method: self.valueLabel.text = request.httpMethod?.uppercased()
        case .httpProtocol: self.valueLabel.text = request.url?.scheme

        case .response:
            if let httpResponse = httpTransaction.httpResponse {
                self.valueLabel.text = "\(httpResponse.statusCode)"
            } else if let error = httpTransaction.error {
                self.valueLabel.text = error.localizedDescription
            }
        case .ssl: self.valueLabel.text = (request.url?.scheme == "https" ? "Yes" : "No")
        case .isProxyConnection:
            if let metrics = httpTransaction.transactionMetrics {
                self.valueLabel.text = metrics.isProxyConnection ? "Yes" : "No"
            }
        case .isReusedConnection:
            if let metrics = httpTransaction.transactionMetrics {
                self.valueLabel.text = (metrics.isReusedConnection ? "Yes" : "No")
            }
        case .resourceFetchType:
            self.valueLabel.text = httpTransaction.resourceFetchTypeString
        case .domainLookupStartDate:
            if let metrics = httpTransaction.transactionMetrics,
                let domainLookupStartDate = metrics.domainLookupStartDate {
                self.valueLabel.text = formatter.string(from: domainLookupStartDate)
            }
        case .domainLookupEndDate:
            if let metrics = httpTransaction.transactionMetrics, let domainLookupEndDate = metrics.domainLookupEndDate {
                self.valueLabel.text = formatter.string(from: domainLookupEndDate)
            }
        case .connectStartDate:
            if let metrics = httpTransaction.transactionMetrics, let connectStartDate = metrics.connectStartDate {
                self.valueLabel.text = formatter.string(from: connectStartDate)
            }
        case .connectEndDate:
            if let metrics = httpTransaction.transactionMetrics, let connectEndDate = metrics.connectEndDate {
                self.valueLabel.text = formatter.string(from: connectEndDate)
            }
        case .secureConnectionStartDate:
            if let metrics = httpTransaction.transactionMetrics,
                let secureConnectionStartDate = metrics.secureConnectionStartDate {
                self.valueLabel.text = formatter.string(from: secureConnectionStartDate)
            }
        case .secureConnectionEndDate:
            if let metrics = httpTransaction.transactionMetrics,
                let secureConnectionEndDate = metrics.secureConnectionEndDate {
                self.valueLabel.text = formatter.string(from: secureConnectionEndDate)
            }

        case .fetchStartDate:
            if let metrics = httpTransaction.transactionMetrics, let fetchStartDate = metrics.fetchStartDate {
                self.valueLabel.text = formatter.string(from: fetchStartDate)
            }
        case .requestStartDate:
            if let metrics = httpTransaction.transactionMetrics, let requestStartDate = metrics.requestStartDate {
                self.valueLabel.text = formatter.string(from: requestStartDate)
            }
        case .requestEndDate:
            if let metrics = httpTransaction.transactionMetrics, let requestEndDate = metrics.requestEndDate {
                self.valueLabel.text = formatter.string(from: requestEndDate)
            }
        case .responseStartDate:
            if let metrics = httpTransaction.transactionMetrics, let responseStartDate = metrics.responseStartDate {
                self.valueLabel.text = formatter.string(from: responseStartDate)
            }
        case .responseEndDate:
            if let metrics = httpTransaction.transactionMetrics, let responseEndDate = metrics.responseEndDate {
                self.valueLabel.text = formatter.string(from: responseEndDate)
            }
        }
    }
}
