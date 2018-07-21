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
        SwiftyProxy.registerSessionConfiguration(conf)

        let session = URLSession(configuration: conf)
        let url = URL(string: "https://httpbin.org/status/undefined")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = "GET"
        let dataTask = session.dataTask(with: request)
        dataTask.resume()


        let url2 = URL(string: "https://httpbin.org/ip")!
        var request2 = URLRequest(url: url2)
        request2.addValue("application/json", forHTTPHeaderField: "accept")
        request2.httpMethod = "GET"
        let dataTask2 = session.dataTask(with: request2)
        dataTask2.resume()
    }

}

