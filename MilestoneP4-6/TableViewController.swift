//
//  ViewController.swift
//  MilestoneP4-6
//
//  Created by Mehmet Can Şimşek on 19.06.2022.
//

import UIKit

class TableViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButton))

    }

    
    @objc func shareButton() {
        let list = shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [] )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
    
    @objc func addButton() {
        let ac = UIAlertController(title: "Add Product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let alert = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let product = ac?.textFields?[0].text else { return }
            self?.submit(product)
        }
        ac.addAction(alert)
        present(ac, animated: true)
        
    }
    
    func submit(_ product: String) {
        let lowerProduct = product.uppercased()
        
     
          if isOriginal(word: lowerProduct) {
             if isReal(word: lowerProduct) {
                    shoppingList.insert(lowerProduct, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }else {
                    showErrorMessage(errorTitle: "Not Found", errorMessage: "Sorry, We can't found product")
                }
            }else {
                showErrorMessage(errorTitle: "Error", errorMessage: "This product is available in the list. Please add another product.")
            }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "webVC") as? WebViewController {
            vc.selectedShoppingList = shoppingList
            let index = indexPath.row
            vc.webIndex = index
            navigationController?.pushViewController(vc, animated: true) 
        }
    }
    
    
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func isOriginal(word: String) -> Bool {
        return !shoppingList.contains(word)
    }
    
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if word.count == 0 {
            showErrorMessage(errorTitle: "Error", errorMessage: "No product has been entered.")
            return false
        }else {
            return misspelledRange.location == NSNotFound
        }
    
    }
    
    
    
    
    
    
}

