//
//  DataExtension.swift
//  Chuck
//
//  Created by Samir on 19/07/2018.
//

import Foundation

extension Data {
    init?(reading input: InputStream?) {
        self.init()
        guard let input = input else { return nil }
        input.open()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        input.close()
    }
}
