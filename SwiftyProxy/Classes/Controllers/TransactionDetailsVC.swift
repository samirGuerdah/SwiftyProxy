//  Created by Samir Guerdah on 18/11/2017.

import UIKit

class TransactionDetailsVC: UIViewController {
    var tableView = UITableView(frame: .zero)
    let dataSource: HttpHeaderDataSource
    init(httpHeaders: [AnyHashable: Any]?, data: Data?) {
        self.dataSource = HttpHeaderDataSource(httpHeaders: httpHeaders, data: data)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func loadView() {
        self.view = UIView(frame: .zero)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        // Layout
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 2
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self.dataSource
        self.dataSource.registerResableViewsForTableView(self.tableView)
    }

    //init(httpHeaders: [AnyHashable: Any]?, data: Data?)
    func updateWithHttpheaders(_ httpHeaders: [AnyHashable: Any]?, data: Data?) {
        self.dataSource.httpHeaders = httpHeaders
        self.dataSource.data = data
        self.tableView.reloadData()
    }
}
