//
//  ViewController.swift
//  SwiftyProxy
//
//  Created by Samir Guerdah on 07/20/2018.
//  Copyright (c) 2018 Samir Guerdah. All rights reserved.
//

import UIKit
import SwiftyProxy

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        





        self.view.backgroundColor = UIColor.white

        let conf = URLSessionConfiguration.default
        let session = URLSession(configuration: conf)
        let url = URL(string: "https://httpbin.org/ip")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = "GET"
        NSURLConnection(request: request, delegate: self, startImmediately: true)
    }

}

