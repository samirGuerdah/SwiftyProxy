//  Created by Samir Guerdah on 18/11/2017.

import UIKit

class TransactionDetailsOverviewVC: UIViewController {

    var tableView = UITableView(frame: .zero)
    let dataSource: OverviewDataSource

    init(httpTransaction: HttpTransaction) {
        self.dataSource = OverviewDataSource(httpTransaction: httpTransaction)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.view = UIView(frame: .zero)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 2

        // Layout
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.dataSource.registerReusableCells(tableView: self.tableView)
    }

    func updateWithTransaction(_ transaction: HttpTransaction) {
        self.dataSource.httpTransaction = transaction
        self.tableView.reloadData()
    }
}
