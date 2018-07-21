//  Created by Samir Guerdah on 15/11/2017.

import UIKit

public class RequestListVC: UIViewController, UISearchResultsUpdating {

    // MARK: Properties
    var tableView = UITableView(frame: .zero)
    let dataSource: RequestListDataSource
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: Inits
    init(httpTransactionList: [HttpTransaction]) {
        self.dataSource = RequestListDataSource(httpTransactionList: httpTransactionList)
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View life cycle
    override public func loadView() {
        view = UIView(frame: .zero)
        view.addSubview(self.tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        /// NavigationBar setup
        self.title = "SwiftyProxy"
        self.navigationItem.rightBarButtonItem = self.eraseButton()
        self.navigationItem.leftBarButtonItem = self.backButton()

        /// TableView setup
        self.tableView.separatorStyle = .singleLine
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension

        /// Search controller setup
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            self.tableView.tableHeaderView = self.searchController.searchBar
        }

        /// register to notification data update
        NotificationCenter.default.addObserver(self, selector: #selector(requestsDataDidChange(_:)),
                                               name: HttpTransactionIntercepter.URLProtocolDataDidUpdateNotification,
                                               object: nil)

        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.dataSource.registerReusableCells(tableView: self.tableView)
        self.dataSource.selectTransactionCompletion = { transation in
            self.searchController.isActive = false
            let detailsVC = TransactionDetailsContainerVC(httpTransaction: transation)
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.isEmpty {
            self.dataSource.httpTransactionList = HttpTransactionIntercepter.shared.httpTransactions
            reloadResponseList()
            return
        }
        self.dataSource.httpTransactionList = HttpTransactionIntercepter.shared.httpTransactions
        .filter { (response) -> Bool in
            return response.containsText(searchText: searchText.lowercased())
        }
        reloadResponseList()
    }

    func reloadResponseList() {
        let indexSet = IndexSet(integer: 0)
        tableView.reloadSections(indexSet, with: .automatic)
    }

    /// MARK: NavigationBar
    func eraseButton() -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash,
                                   target: self, action: #selector(eraseAll))
        return item
    }

    func backButton() -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                   target: self, action: #selector(backAction))
        return item
    }

    // MARK: User action
    @objc func eraseAll() {
        HttpTransactionIntercepter.shared.eraseAll()
        self.dataSource.httpTransactionList.removeAll()
        self.tableView.reloadData()
    }

    @objc func backAction() {
        dismiss(animated: true)
    }

    @objc func requestsDataDidChange(_ notification: Notification) {
        self.dataSource.httpTransactionList = HttpTransactionIntercepter.shared.httpTransactions
        self.tableView.reloadData()
    }
}
