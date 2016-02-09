//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Thang H Tong on 2/2/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var title: String
    var filePathUrl: NSURL
    
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}