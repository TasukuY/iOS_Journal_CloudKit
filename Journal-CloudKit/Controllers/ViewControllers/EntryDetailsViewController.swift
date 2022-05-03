//
//  EntryDetailsViewController.swift
//  Journal-CloudKit
//
//  Created by Tasuku Yamamoto on 5/2/22.
//

import UIKit

class EntryDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    //MARK: - Properties
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
        }
    }
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - IBActions
    
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
              let body = bodyTextView.text,
              !title.isEmpty,
              !body.isEmpty
        else { return }
      
        EntryController.shared.createEntry(with: title, and: body) { result in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    //MARK: - Helper Methods
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
    
}//End of class

extension EntryDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
