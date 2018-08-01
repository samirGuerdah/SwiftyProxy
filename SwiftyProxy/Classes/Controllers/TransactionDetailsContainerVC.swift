//  Created by Samir Guerdah on 15/11/2017.

import UIKit

class TransactionDetailsContainerVC: UIViewController, UIScrollViewDelegate {

    enum SelectionType: Int {
        case overview
        case request
        case response
    }

    // MARK: Properties
    var scrollView = UIScrollView(frame: .zero)
    var segmentedControl = UISegmentedControl(items: ["Overview", "Request", "Response"])
    let headerView = UIView(frame: .zero)

    /// Data properties
    var httpTransaction: HttpTransaction
    var selectionType = SelectionType.overview

    /// Child controllers
    let overviewVC: TransactionDetailsOverviewVC
    let requestVC: TransactionDetailsVC
    let responseVC: TransactionDetailsVC

    // MARK: Inits
    init(httpTransaction: HttpTransaction) {
        self.httpTransaction = httpTransaction
        self.overviewVC = TransactionDetailsOverviewVC(httpTransaction: httpTransaction)
        self.requestVC = TransactionDetailsVC(httpHeaders: httpTransaction.request.allHTTPHeaderFields,
                                             data: httpTransaction.body)
        self.responseVC = TransactionDetailsVC(httpHeaders: httpTransaction.httpResponse?.allHeaderFields,
                                               data: httpTransaction.responseData)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View life cycle
    override func loadView() {
        view = UIView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.white
        view.addSubview(scrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUINavigationBar()
        setupUI()
        setNavBarTitle()
        registerToTransactionUpdateNotification()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 3 * view.bounds.width, height: scrollView.bounds.height)
        headerView.topAnchor.constraint(equalTo: view.topAnchor,
                                        constant: topLayoutGuide.length).isActive = true
    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        if let type = SelectionType(rawValue: page) {
            selectionType = type
            segmentedControl.selectedSegmentIndex = page
        }
    }

    func updateScrollViewOffset() {
        var xOffset: CGFloat
        switch selectionType {
        case .overview: xOffset = 0
        case .request: xOffset = scrollView.bounds.width
        case .response: xOffset = scrollView.bounds.width * 2
        }
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }

    // MARK: Navigation bar
    func shareButtonItem() -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action,
                                   target: self, action: #selector(share))
        return item
    }

    func setNavBarTitle() {
        if let httpMethod = httpTransaction.httpMethod, let path =  httpTransaction.url?.path {
            title = "\(httpMethod) \(path)"
        }
    }

    func setupUINavigationBar() {
        self.navigationItem.rightBarButtonItem = shareButtonItem()
    }

    // MARK: User actions
    @IBAction func share(_ sender: AnyObject) {
        let shareActionSheet  = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
        shareActionSheet.addAction(UIAlertAction(title: "Share as curl command", style: .default, handler: { _ in
            self.shareAsCurl()
        }))
        shareActionSheet.addAction(UIAlertAction(title: "Share as text", style: .default, handler: { _ in
            self.shareAsText()
        }))
        shareActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(shareActionSheet, animated: true, completion: nil)
    }

    @IBAction func selectSegmentType(sender: UISegmentedControl) {
        guard let selectionType = SelectionType(rawValue: sender.selectedSegmentIndex) else {
            fatalError()
        }
        self.selectionType = selectionType
        updateScrollViewOffset()
    }

    // MARK: Private
    func shareAsCurl() {
        let curlRepresentation = HttpTransactionShareFormatter
        .cURLRepresentationFor(httpTransaction: self.httpTransaction)
        let activityViewController = UIActivityViewController(activityItems: [curlRepresentation],
                                                              applicationActivities: nil)
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    func shareAsText() {
        let textRepresentation = HttpTransactionShareFormatter.textRepresentationFor(httpTransaction: self.httpTransaction)
        let activityViewController = UIActivityViewController(activityItems: [textRepresentation],
                                                              applicationActivities: nil)
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        self.present(activityViewController, animated: true, completion: nil)
    }

    // MARK: Notification
    func registerToTransactionUpdateNotification() {
        /// register to notification data update
        NotificationCenter.default.addObserver(self, selector: #selector(httpTransactionDataDidChange(_:)),
                                               name: HttpTransactionIntercepter.URLProtocolDataDidUpdateNotification,
                                               object: nil)
    }

    @objc func httpTransactionDataDidChange(_ notification: Notification) {
        if let transaction = HttpTransactionIntercepter.shared
            .httpTransactioWithIdentifier(self.httpTransaction.identifier) {
            self.httpTransaction = transaction

            self.overviewVC.updateWithTransaction(transaction)
            self.requestVC.updateWithHttpheaders(transaction.request.allHTTPHeaderFields, data: transaction.body)
            self.responseVC.updateWithHttpheaders(transaction.httpResponse?.allHeaderFields,
                                                  data: transaction.responseData)
        }
    }
}

/// UI Setup
extension TransactionDetailsContainerVC {
// swiftlint:disable:next function_body_length
    func setupUI() {
        let marginGuide = view.layoutMarginsGuide

        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // Header View
        headerView.backgroundColor = UIColor.white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }

        // Segmented control
        segmentedControl.addTarget(self, action: #selector(selectSegmentType(sender:)),
                                   for: UIControlEvents.valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        headerView.addSubview(segmentedControl)

        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        /// Overview
        self.addChildViewController(overviewVC)
        scrollView.addSubview(overviewVC.view)
        overviewVC.didMove(toParentViewController: self)
        overviewVC.view.translatesAutoresizingMaskIntoConstraints = false
        overviewVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        overviewVC.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        overviewVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        overviewVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true

        /// Request
        self.addChildViewController(requestVC)
        scrollView.addSubview(requestVC.view)
        requestVC.didMove(toParentViewController: self)
        requestVC.view.translatesAutoresizingMaskIntoConstraints = false
        requestVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        requestVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true
        requestVC.view.leadingAnchor.constraint(equalTo: overviewVC.view.trailingAnchor).isActive = true
        requestVC.view.widthAnchor.constraint(equalTo: overviewVC.view.widthAnchor, multiplier: 1).isActive = true

        /// Response
        self.addChildViewController(responseVC)
        scrollView.addSubview(responseVC.view)
        responseVC.didMove(toParentViewController: self)
        responseVC.view.translatesAutoresizingMaskIntoConstraints = false
        responseVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        responseVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true
        responseVC.view.leadingAnchor.constraint(equalTo: requestVC.view.trailingAnchor).isActive = true
        responseVC.view.widthAnchor.constraint(equalTo: requestVC.view.widthAnchor, multiplier: 1).isActive = true
    }
}
