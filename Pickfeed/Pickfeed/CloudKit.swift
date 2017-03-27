//
//  CloudKit.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/27/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import Foundation
import CloudKit

class CloudKit {
    static let shared = CloudKit() //singleton
    let container = CKContainer.default()
    
    var privateDatabase : CKDatabase {
        return container.privateCloudDatabase
    }
}
