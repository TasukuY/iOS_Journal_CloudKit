//
//  EntryController.swift
//  Journal-CloudKit
//
//  Created by Tasuku Yamamoto on 5/2/22.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - Properties
    static let shared = EntryController()
    var entries: [Entry] = []
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - CRUD funcs
    func createEntry(with title: String, and body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        // Package the new entry into a CKRecord
        let entryRecord = CKRecord(entry: newEntry)
        // Saving the entryRecord to the cloud
        privateDB.save(entryRecord) { record, error in
            //Hnadling the error
            if let error = error {
                return completion(.failure(.throwError(error)))
            }
            //Unwrapping the record that was saved
            guard let record = record,
                  //Ensuring that we can init an Entry from the record
                  let savedEntry = Entry(ckRecord: record)
            else { return completion(.failure(.noRecord)) }
            // Add it to the SoT array
            self.entries.append(savedEntry)
            return completion(.success(savedEntry))
        }
    }//End of function create
    
    func fetchEntriesWith(completion: @escaping (_ result: Result<[Entry]?,EntryError>) -> Void) {
        // 3. init the requisite predicate for the query - it tells the predicate to just return everything
        let predicate = NSPredicate(value: true)
        // 2. init the requisite querty for the .perform methods
        let query = CKQuery(recordType: EntryConstants.recordType, predicate: predicate)
        // 1. perform a query on the database
        privateDB.perform(query, inZoneWith: nil) { records, error in
            //Handle the optional error
            if let error = error {
                return completion(.failure(.throwError(error)))
            }
            //unwrap the records
            guard let records = records else { return completion(.failure(.noRecord)) }
            //compact map through the found records return the non-nil Entry objects
            let fetchedEntries = records.compactMap { Entry(ckRecord: $0) }
            //set out SoT array
            self.entries = fetchedEntries
            return completion(.success(self.entries))
        }
        
//        privateDB.fetch(withQuery: query) { <#Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>#> in
//            <#code#>
//        }
        
    }//End of function fetch
    
}//End of class
