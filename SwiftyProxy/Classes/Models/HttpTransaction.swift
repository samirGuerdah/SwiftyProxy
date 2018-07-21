//  Created by Samir on 09/07/2018.

import Foundation

public class HttpTransaction {

    let identifier: String
    let task: URLSessionTask
    let request: URLRequest
    let session: URLSession
    var metrics: URLSessionTaskMetrics?
    var error: Error?
    var responseData: Data?
    var requestData: Data?
    var httpResponse: HTTPURLResponse?
    var credential: URLCredential?

    init(identifier: String,
         task: URLSessionTask,
         request: URLRequest,
         session: URLSession,
         metrics: URLSessionTaskMetrics?,
         error: Error?,
         responseData: Data?,
         requestData: Data?,
         httpResponse: HTTPURLResponse?,
         credential: URLCredential?) {

        self.identifier = identifier
        self.task = task
        self.request = request
        self.session = session
        self.metrics = metrics
        self.error = error
        self.responseData = responseData
        self.requestData = requestData
        self.httpResponse = httpResponse
        self.credential = credential
    }

    //swiftlint:disable:next function_parameter_count
    func updateWith(metrics: URLSessionTaskMetrics?,
                    error: Error?,
                    responseData: Data?,
                    requestData: Data?,
                    httpResponse: HTTPURLResponse?,
                    credential: URLCredential?) {
        self.metrics = metrics
        self.error = error
        self.responseData = responseData
        self.requestData = requestData
        self.httpResponse = httpResponse
        self.credential = credential
    }

    public func containsText(searchText: String) -> Bool {
        guard let httpResponse = task.response as? HTTPURLResponse else {
            return false
        }
        if "\(httpResponse.statusCode)".contains(searchText) {
            return true
        }
        if let httpMethod = task.originalRequest?.httpMethod, httpMethod.lowercased().contains(searchText) {
            return true
        }
        if let path =  task.originalRequest?.url?.path, path.lowercased().contains(searchText) {
            return true
        }
        if let host = task.originalRequest?.url?.host, host.lowercased().contains(searchText) {
            return true
        }
        return false
    }
}
extension HttpTransaction {
        var state: URLSessionTask.State? {
            return task.state
        }
        var httpMethod: String? {
            return request.httpMethod
        }
        var url: URL? {
            return request.url
        }
        var headers: [String: String]? {
            return request.allHTTPHeaderFields
        }
        var body: Data? {
            return requestData
        }
        func bodyString() -> String? {
            guard let body = body else {
                return nil
            }
            return String(data: body, encoding: String.Encoding.utf8)
        }

        var transactionMetrics: URLSessionTaskTransactionMetrics? {
            return metrics?.transactionMetrics.last
        }

        var fetchStartDate: Date? {
            return transactionMetrics?.fetchStartDate
        }

        var requestStartDate: Date? {
            return transactionMetrics?.requestStartDate
        }

        var responseEndDate: Date? {
            return transactionMetrics?.responseEndDate
        }

        var resourceFetchTypeString: String {
            guard let resourceType = transactionMetrics?.resourceFetchType else {
                return "Unknown"
            }
            switch resourceType {
            case .unknown: return "Unknown"
            case .localCache: return "Local cache"
            case .networkLoad: return "Network load"
            case .serverPush: return "Server push"
        }
    }

        /// Refactor
        var transactionDuration: String? {
            guard let startDate = fetchStartDate, let endDate = responseEndDate else { return nil }
            let seconds = endDate.timeIntervalSince(startDate)
            let milleS = (seconds * 1000)

            let formatter = Formatter.numberFormatter
            formatter.maximumFractionDigits = seconds < 1 ? 0 : 2
            if seconds < 1 {
                let number = NSNumber(value: milleS)
                if let value = formatter.string(from: number) {
                    return "\(value) ms"
                }
            } else {
                let number = NSNumber(value: seconds)
                if let value = formatter.string(from: number) {
                    return "\(value) s"
                }
            }
            return nil
        }
}

extension HttpTransaction: Equatable {
    public static func == (lhs: HttpTransaction, rhs: HttpTransaction) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension HttpTransaction: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        identifier: \(identifier)\n
        task: \(task.debugDescription) \n
        request: \(request.debugDescription) \n
        session: \(session.debugDescription) \n
        metrics: \(metrics.debugDescription) \n
        error: \(error.debugDescription) \n
        responseData: \(responseData.debugDescription) \n
        httpResponse: \(httpResponse.debugDescription) \n
        credential: \(credential.debugDescription)
        """
    }
}
