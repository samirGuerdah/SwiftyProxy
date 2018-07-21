//  Created by Samir on 17/07/2018.

import Foundation

class OverviewDataSource: NSObject, UITableViewDataSource {

    // MARK: Properties
    var httpTransaction: HttpTransaction

    // MARK: Inits
    init(httpTransaction: HttpTransaction) {
        self.httpTransaction = httpTransaction
    }

    func registerReusableCells(tableView: UITableView) {
        tableView.register(KeyValueCell.self, forCellReuseIdentifier: KeyValueCell.kReuseIdentifier)
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OverviewRowType.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.keyValueCellFo(indexPath: indexPath, tableView: tableView)
    }

    // swiftlint:disable force_cast
    // MARK: Cells
    func keyValueCellFo(indexPath: IndexPath, tableView: UITableView) -> KeyValueCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueCell.kReuseIdentifier,
                                                 for: indexPath) as! KeyValueCell
        let row = indexPath.row
        let rowType = OverviewRowType.allRows()[row]
        cell.fillCell(rowType: rowType, httpTransaction: self.httpTransaction)
        return cell
    }
}
