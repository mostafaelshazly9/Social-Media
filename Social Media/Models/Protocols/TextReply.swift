//
//  TextReply.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/3/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

protocol TextReply {
    var id:String { get set }
    var parentID:String { get set }
    var poster:String { get set }
    var text:String { get set }
    var date:Double { get set }
}
