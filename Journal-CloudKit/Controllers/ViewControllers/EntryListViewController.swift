//
//  EntryListViewController.swift
//  Journal-CloudKit
//
//  Created by Tasuku Yamamoto on 5/2/22.
//

import UIKit

class EntryListViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var entryListTableView: UITableView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryListTableView.reloadData()
    }
    
    //MARK: - IBActions
    @IBAction func addEntryButtonTapped(_ sender: Any) {
    }

    //MARK: - Helper Methods
    func setupViews(){
        entryListTableView.delegate = self
        entryListTableView.dataSource = self
        EntryController.shared.fetchEntriesWith { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entries):
                    guard let entries = entries else { return }
                    EntryController.shared.entries = entries
                    self.entryListTableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditEntry" {
            guard let indexPath = entryListTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? EntryDetailsViewController
            else { return }
            
            let entryToSend = EntryController.shared.entries[indexPath.row]
            destination.entry = entryToSend
        }
    }

}//End of class

extension EntryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entryListTableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entryToDisplay = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entryToDisplay.title
        cell.detailTextLabel?.text = entryToDisplay.timestamp.formatDate()
        
        return cell
    }

}//End of extension
