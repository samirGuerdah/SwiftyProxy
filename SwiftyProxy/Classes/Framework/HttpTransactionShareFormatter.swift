//  Created by Samir on 13/07/2018.

import Foundation

class HttpTransactionShareFormatter {
// swiftlint:disable:next function_body_length cyclomatic_complexity
    static func cURLRepresentationFor(httpTransaction: HttpTransaction) -> String {
        var components = ["$ curl -v"]
        let request = httpTransaction.request
        guard   let url = request.url,
                let host = url.host
        else {
                return "$ curl command could not be created"
        }

        if let httpMethod = request.httpMethod, httpMethod != "GET" {
            components.append("-X \(httpMethod)")
        }

        let session = httpTransaction.session
        if let credentialStorage = session.configuration.urlCredentialStorage {
            let protectionSpace = URLProtectionSpace(
                host: host,
                port: url.port ?? 0,
                protocol: url.scheme,
                realm: host,
                authenticationMethod: NSURLAuthenticationMethodHTTPBasic
            )

            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
                for credential in credentials {
                    guard let user = credential.user, let password = credential.password else { continue }
                    components.append("-u \(user):\(password)")
                }
            } else {
                if let credential = httpTransaction.credential,
                    let user = credential.user,
                    let password = credential.password {
                    components.append("-u \(user):\(password)")
                }
            }
        }

        if session.configuration.httpShouldSetCookies {
            if
                let cookieStorage = session.configuration.httpCookieStorage,
                let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty
            {
                let string = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }
                components.append("-b \"\(string[..<string.index(before: string.endIndex)])\"")
            }
        }

        var headers: [AnyHashable: Any] = [:]
        if let additionalHeaders = session.configuration.httpAdditionalHeaders {
            for (field, value) in additionalHeaders where field != AnyHashable("Cookie") {
                headers[field] = value
            }
        }

        if let headerFields = request.allHTTPHeaderFields {
            for (field, value) in headerFields where field != "Cookie" {
                headers[field] = value
            }
        }

        for (field, value) in headers {
            let escapedValue = String(describing: value).replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(field): \(escapedValue)\"")
        }

        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")
        return components.joined(separator: " \\\n\t")
    }

    static func textRepresentationFor(httpTransaction: HttpTransaction) -> String {
        var responseString  = ""
        if let url = httpTransaction.url?.absoluteString {
            responseString.append("\n\nURL: \(url)")
        }
        if let method = httpTransaction.httpMethod?.uppercased() {
            responseString.append("\nMethod: \(method)")
        }
        if let scheme = httpTransaction.url?.scheme {
            responseString.append("\nProtocol Name: \(scheme)")
        }
        if let httpResponse = httpTransaction.httpResponse {
            responseString.append("\nResponse: \(httpResponse.statusCode)")
        } else if let error = httpTransaction.error {
            responseString.append("\nResponse: \(error.localizedDescription)")
        }
        responseString.append("\nSSL: \(httpTransaction.url?.scheme == "https" ? "Yes" : "No")")
        responseString.append("\nFetch Type: \(httpTransaction.resourceFetchTypeString)")
        if let metrics = httpTransaction.transactionMetrics {
            responseString.append("\nProxy Connection: \(metrics.isProxyConnection ? "Yes" : "No")")
            responseString.append("\nReused Connection: \(metrics.isReusedConnection ? "Yes" : "No")")

            // Timing
            let formatter = Formatter.dateFormatter
            if let domainLookupStartDate = metrics.domainLookupStartDate {
                responseString.append("\n\nDomain Lookup Start: \(formatter.string(from: domainLookupStartDate))")
            }
            if let domainLookupEndDate = metrics.domainLookupEndDate {
                responseString.append("\nDomain Lookup End: \(formatter.string(from: domainLookupEndDate))")
            }
            if let connectStartDate = metrics.connectStartDate {
                responseString.append("\nConnect Start: \(formatter.string(from: connectStartDate))")
            }
            if let connectEndDate = metrics.connectEndDate {
                responseString.append("\nConnect End: \(formatter.string(from: connectEndDate))")
            }
            if let secureConnecionStartDate = metrics.secureConnectionStartDate {
                responseString.append("\nSecure Connection Start: \(formatter.string(from: secureConnecionStartDate))")
            }
            if let secureConnectionEnd = metrics.secureConnectionEndDate {
                responseString.append("\nSecure Connection End: \(formatter.string(from: secureConnectionEnd))")
            }
            if let fetchStartDate = metrics.fetchStartDate {
                responseString.append("\nFetch Start: \(formatter.string(from: fetchStartDate))")
            }
            if let requestStartDate = metrics.requestStartDate {
                responseString.append("\nRequest Start: \(formatter.string(from: requestStartDate))")
            }
            if let requestEndDate = metrics.requestEndDate {
                responseString.append("\nRequest End: \(formatter.string(from: requestEndDate))")
            }
            if let responseStartDate = metrics.responseStartDate {
                responseString.append("\nResponse Start: \(formatter.string(from: responseStartDate))")
            }
            if let responseEndDate = metrics.responseEndDate {
                responseString.append("\nResponse End: \(formatter.string(from: responseEndDate))")
            }

            // Request
            responseString.append("\n\n---------- Request ----------")
            let requestHttpHeaders: [AnyHashable: Any]? = httpTransaction.request.allHTTPHeaderFields
            let formattedRequest = formattedTextForHeaders(headers: requestHttpHeaders, data: httpTransaction.body)
            responseString.append("\n\(formattedRequest)")


            // Response
            responseString.append("\n\n\n---------- Response ----------")
            let responseHttpHeaders: [AnyHashable: Any]? = httpTransaction.httpResponse?.allHeaderFields
            let formattedResponse = formattedTextForHeaders(headers: responseHttpHeaders, data: httpTransaction.responseData)
            responseString.append("\n\(formattedResponse)")
        }

        return responseString
    }

    static func formattedTextForHeaders(headers: [AnyHashable: Any]?, data: Data?) -> String {
        var formattedText = ""
        if let headers = headers {
            let requestHeaderKeys: [AnyHashable] = Array(headers.keys)
            requestHeaderKeys.forEach { (key) in
                if let value = headers[key] {
                    formattedText.append("\n\(key): \(value)")
                }
            }
        }
        if let requestData = data {
            if let jsonData = try? JSONSerialization.jsonObject(with: requestData, options: []) {
                formattedText.append("\n\n\(JSONStringify(value: jsonData))")
            }
            else {
                formattedText.append("\n\n\(String(decoding: requestData, as: UTF8.self))")
            }
        }
        return formattedText
    }
}
