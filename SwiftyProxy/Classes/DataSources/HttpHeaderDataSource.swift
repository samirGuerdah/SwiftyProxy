//  Created by Samir on 16/07/2018.

import Foundation

class HttpHeaderDataSource: NSObject, UITableViewDataSource {
    enum SectionType: Int {
        case httpHeader
        case data

        static func allSections() -> [SectionType] {
            return [.httpHeader, .data]
        }
    }

    var httpHeaders: [AnyHashable: Any]?
    var data: Data?
    var headerKeys: [AnyHashable] = []

    init(httpHeaders: [AnyHashable: Any]?, data: Data?) {
        self.httpHeaders = httpHeaders
        self.data = data
        if let headers = httpHeaders {
            self.headerKeys = Array(headers.keys)
        }
    }

    func registerResableViewsForTableView(_ tableView: UITableView) {
        tableView.register(HttpHeaderCell.self, forCellReuseIdentifier: HttpHeaderCell.kHttpHeaderCellReuseIdentifier)
        tableView.register(HttpHeaderCell.self, forCellReuseIdentifier: HttpHeaderCell.kTextCellReuseIdentifier)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.kReuseIdentifier)
    }

    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allSections().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else {
            fatalError("no type corresponding to section \(section)")
        }

        switch sectionType {
        case .httpHeader: return self.headerKeys.count
        case .data: return self.data != nil ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let section = indexPath.section
        guard let sectionType = SectionType(rawValue: section) else {
            fatalError("no type corresponding to section \(section)")
        }
        switch sectionType {
        case .httpHeader: return httpHeaderCell(indexPath: indexPath, tableView: tableView)
        case .data:
            if containsImageContentType() {
                return self.imageCell(indexPath: indexPath, tableView: tableView)
            }
            return self.textCell(indexPath: indexPath, tableView: tableView)
        }
    }

    // swiftlint:disable force_cast
    // MARK: Cells
    func httpHeaderCell(indexPath: IndexPath, tableView: UITableView) -> HttpHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HttpHeaderCell.kHttpHeaderCellReuseIdentifier,
                                                 for: indexPath) as! HttpHeaderCell
        let row = indexPath.row
        let key = self.headerKeys[row]
        let value = self.httpHeaders?[key]
        cell.fillWith(key: key, value: value)
        return cell
    }

    func textCell(indexPath: IndexPath, tableView: UITableView) -> HttpHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HttpHeaderCell.kTextCellReuseIdentifier,
                                                 for: indexPath) as! HttpHeaderCell
        guard let data = self.data else {
            cell.label.text = ""
            return cell
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            let dataString = String(decoding: data, as: UTF8.self)
            cell.label.text = dataString
            return cell
        }
        let jsonString = JSONStringify(value: json)
        cell.label.text = jsonString
        return cell
    }

    func imageCell(indexPath: IndexPath, tableView: UITableView) -> ImageCell {
        guard let data = self.data else { fatalError()}
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.kReuseIdentifier,
                                                 for: indexPath) as! ImageCell
        cell.fillWith(data: data)
        return cell
    }

    /// MARK: Private
    func containsImageContentType() -> Bool {
        guard let contentType = self.httpHeaders?["Content-Type"] as? String, contentType.hasPrefix("image/") else {
            return false
        }
        return true
    }
}
