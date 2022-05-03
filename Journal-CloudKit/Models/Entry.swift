//
//  Entry.swift
//  Journal-CloudKit
//
//  Created by Tasuku Yamamoto on 5/2/22.
//

import Foundation
import CloudKit

class Entry {
    
    //MARK: - Properties
    let title: String
    let body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    
}//End of class

extension Entry {
    
    convenience init?(ckRecord: CKRecord){
        guard let fetchedTitle = ckRecord[EntryConstants.titleKey] as? String,
              let fetchedBody = ckRecord[EntryConstants.bodyKey] as? String,
              let fetchedTimestamp = ckRecord[EntryConstants.timestampKey] as? Date
        else { return nil }
        self.init(title: fetchedTitle, body: fetchedBody, timestamp: fetchedTimestamp, ckRecordID: ckRecord.recordID)
    }
    
}//End of extension

extension CKRecord {
    
    convenience init(entry: Entry){
        self.init(recordType: EntryConstants.recordType, recordID: entry.ckRecordID)
        
        self.setValuesForKeys([
            EntryConstants.titleKey : entry.title,
            EntryConstants.bodyKey : entry.body,
            EntryConstants.timestampKey : entry.timestamp
        ])
        
    }
    
}//End of extension
