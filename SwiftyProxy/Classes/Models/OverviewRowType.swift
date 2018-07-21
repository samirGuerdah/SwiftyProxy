//  Created by Samir on 17/07/2018.

import Foundation

enum OverviewRowType: String {
    case url = "URL"
    case method = "Method"
    case httpProtocol = "Protocol Name"
    case response = "Response"
    case ssl = "SSL"

    case isProxyConnection = "Proxy Connection"
    case isReusedConnection = "Reused Connection"
    case resourceFetchType = "Fetch Type"

    // Timing
    case domainLookupStartDate = "Domain Lookup Start"
    case domainLookupEndDate = "Domain Lookup End"
    case connectStartDate = "Connect Start"
    case connectEndDate = "Connect End"
    case secureConnectionStartDate = "Secure Connection Start"
    case secureConnectionEndDate = "Secure Connection End"

    case fetchStartDate = "Fetch Start"
    case requestStartDate = "Request Start"
    case requestEndDate = "Request End"
    case responseStartDate = "Response Start"
    case responseEndDate = "Response End"

    static func allRows() -> [OverviewRowType] {
        return [.url, .method, .httpProtocol, .response, .ssl,
                .isProxyConnection, .isReusedConnection, .resourceFetchType,
                .domainLookupStartDate, .domainLookupEndDate, .connectStartDate,
                .connectEndDate, .secureConnectionStartDate, .secureConnectionEndDate,
                .fetchStartDate, .requestStartDate, .requestEndDate, .responseStartDate, .responseEndDate
                ]
    }

    static func numberOfRows() -> Int {
        return allRows().count
    }
}
