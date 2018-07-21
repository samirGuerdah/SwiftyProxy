//  Created by Samir on 18/07/2018.

import Foundation

class RequestListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    var httpTransactionList: [HttpTransaction]
    var selectTransactionCompletion: ((HttpTransaction) -> Void)?

    // MARK: Inits
    init(httpTransactionList: [HttpTransaction]) {
        self.httpTransactionList = httpTransactionList
    }

    // MARK: Public function
    func registerReusableCells(tableView: UITableView) {
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.kCompletedCellIdentifier)
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.kLoadingCellIdentifier)
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.httpTransactionList.count
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
}
