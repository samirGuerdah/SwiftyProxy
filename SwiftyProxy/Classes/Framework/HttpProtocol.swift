//  Created by Samir Guerdah on 09/11/2017.

import Foundation

class SwiftyConfiguration: URLSessionConfiguration {}

open class SwiftyProxy: URLProtocol, URLSessionDataDelegate {

    var session: URLSession!
    var currentTask: URLSessionDataTask!
    var currentRequest: URLRequest!
    var currentData = Data()
    var taskMetrics: URLSessionTaskMetrics?
    var currentError: Error?
    var currentResponse: HTTPURLResponse?
    var credential: URLCredential?

    var currentHttpTask: HttpTransaction!

    @objc public static func registerSessionConfiguration(_ configuration: URLSessionConfiguration) {
        configuration.protocolClasses = [SwiftyProxy.self] as [AnyClass] + configuration.protocolClasses!
    }

    @objc public static func enable() {
        URLProtocol.registerClass(SwiftyProxy.self);

        var floatingButtonAlreadyAdded = false
        UIApplication.shared.windows.forEach { (window) in
            if window is FloatingButtonWindow {
                floatingButtonAlreadyAdded = true
            }
        }
        if !floatingButtonAlreadyAdded {
            _ = FloatingButtonVC()
        }
    }

    override public init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        let configuration = SwiftyConfiguration.default
        configuration.protocolClasses?.removeFirst()
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        currentTask = session.dataTask(with: request)
        currentRequest = request
    }

    override open class func canInit(with request: URLRequest) -> Bool {
        guard let scheme = request.url?.scheme, (scheme.contains("http") || scheme.contains("https")) else {
            return false
        }
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        initCurrentHttpTask()
        currentTask.resume()
    }

    override open func stopLoading() {
        session.invalidateAndCancel()
    }

    // MARK: URLSessionDelegate
    public func urlSession(_ session: URLSession,
                                dataTask: URLSessionDataTask,
                                didReceive response: URLResponse,
                                completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        DispatchQueue.main.async {
            completionHandler(.allow)
            self.currentResponse = response as? HTTPURLResponse
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.currentError = error
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
        }

        updateCurrentHttpTask()
        session.invalidateAndCancel()
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        currentData.append(data)
        updateCurrentHttpTask()
        self.client?.urlProtocol(self, didLoad: data)
    }

    public func urlSession(_ session: URLSession,
                                didReceive challenge: URLAuthenticationChallenge,
                                completionHandler:
    @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let secTrust = challenge.protectionSpace.serverTrust {
                self.credential = URLCredential(trust: secTrust)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, self.credential)
            }
        }
    }

    public func urlSession(_ session: URLSession,
                                task: URLSessionTask,
                                didFinishCollecting metrics: URLSessionTaskMetrics) {
        self.taskMetrics = metrics
        updateCurrentHttpTask()
    }

    // MARK: ...
    func updateCurrentHttpTask() {
        let requestData = Data(reading: currentRequest.httpBodyStream)
        self.currentHttpTask.updateWith(metrics: self.taskMetrics,
                                        error: self.currentError,
                                        responseData: self.currentData,
                                        requestData: requestData,
                                        httpResponse: self.currentResponse,
                                        credential: self.credential)
        HttpTransactionIntercepter.shared.registerOrUpdateWithTask(self.currentHttpTask)
    }

    func initCurrentHttpTask() {
        let identifier = String(describing: Unmanaged<AnyObject>
            .passUnretained(self.currentRequest as AnyObject).toOpaque())
        let requestData = Data(reading: currentRequest.httpBodyStream)
        self.currentHttpTask = HttpTransaction(identifier: identifier,
                                               task: self.currentTask,
                                               request: self.currentRequest,
                                               session: self.session,
                                               metrics: self.taskMetrics,
                                               error: self.currentError,
                                               responseData: self.currentData,
                                               requestData: requestData,
                                               httpResponse: self.currentResponse,
                                               credential: self.credential)
        HttpTransactionIntercepter.shared.registerOrUpdateWithTask(self.currentHttpTask)
    }
}
