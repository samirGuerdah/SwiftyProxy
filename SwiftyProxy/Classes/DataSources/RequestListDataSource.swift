//  Created by Samir on 18/07/2018.

import Foundation

class RequestListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    var httpTransactionList: [HttpTransaction] {
        didSet {
            self.groupeTransactionsByUrlHost()
        }
    }
    var httpTransactionsDic: Dictionary<String, [HttpTransaction]> = [:]
    var hosts: [String] = []

    var selectTransactionCompletion: ((HttpTransaction) -> Void)?

    // MARK: Inits
    init(httpTransactionList: [HttpTransaction]) {
        self.httpTransactionList = httpTransactionList
        super.init()
        self.groupeTransactionsByUrlHost()
    }

    // MARK: Public function
    func registerReusableCells(tableView: UITableView) {
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.kCompletedCellIdentifier)
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.kLoadingCellIdentifier)
    }

    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.hosts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.hosts[section]
        guard let transList = self.httpTransactionsDic[key] else { return 0 }
        return transList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.requestCellFor(indexPath: indexPath, tableView: tableView)
    }

    // MARK: UITableViewDelegate
    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let httpTransaction = self.httpTransactionList[indexPath.row]
        self.selectTransactionCompletion?(httpTransaction)
    }

    // swiftlint:disable force_cast
    // MARK: Cells
    func requestCellFor(indexPath: IndexPath, tableView: UITableView) -> RequestCell {
        let httpTransaction = self.httpTransactionList[indexPath.row]
        guard let state = httpTransaction.state else {
            fatalError()
        }

        let cellIdentifier = state == .running ? RequestCell.kLoadingCellIdentifier :
            RequestCell.kCompletedCellIdentifier
        let cell: RequestCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                              for: indexPath) as! RequestCell
        cell.fillWith(httpTransaction: httpTransaction)
        return cell
    }

    // MARK: Private
    func groupeTransactionsByUrlHost()  {
        self.httpTransactionList.forEach { (trans) in
            if let host = trans.url?.host, !self.hosts.contains(host) {
                self.hosts.append(host)
                let filteredTransactions = self.httpTransactionList.filter({ (transactionToFilter) -> Bool in
                    return transactionToFilter.url?.host == host
                })
                self.httpTransactionsDic[host] = filteredTransactions
            }
        }
    }
}
