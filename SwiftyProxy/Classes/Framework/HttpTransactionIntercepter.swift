//  Created by Samir Guerdah on 12/11/2017.

import Foundation

public class HttpTransactionIntercepter {

    static let URLProtocolDataDidUpdateNotification = NSNotification.Name("URLProtocolDidUpdateNotification")
    let lockQueue = DispatchQueue(label: "com.SwiftyProxy.LockQueue")

    public static let shared = HttpTransactionIntercepter()
    var httpTransactions = [HttpTransaction]()

    func registerOrUpdateWithTask(_ task: HttpTransaction) {
        DispatchQueue.main.async {
            if let index = self.httpTransactions.index(of: task) {
                self.httpTransactions.remove(at: index)
            }
            self.httpTransactions.append(task)
            self.httpTransactions.sort(by: { (trs1, trs2) -> Bool in
                guard let trs1Date = trs1.fetchStartDate, let trs2Date = trs2.fetchStartDate else {
                    return true
                }
                return  trs1Date.compare(trs2Date) == .orderedDescending
            })
            self.postUpdateNotification()
        }
    }

    func eraseAll() {
        self.httpTransactions.removeAll()
    }

    func httpTransactioWithIdentifier(_ identifier: String) -> HttpTransaction? {
        return self.httpTransactions.filter({ (trans) -> Bool in
            return trans.identifier == identifier
        }).first
    }

    func postUpdateNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: HttpTransactionIntercepter.URLProtocolDataDidUpdateNotification,
                                            object: self, userInfo: nil)
        }
    }
}
