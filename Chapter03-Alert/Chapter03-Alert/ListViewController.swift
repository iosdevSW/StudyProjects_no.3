//
//  ListViewController.swift
//  Chapter03-Alert
//
//  Created by 신상우 on 2021/11/13.
//

import UIKit

class ListViewController: UITableViewController{
    var delegate: MapAlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize.height = 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "\(indexPath.row)번째 옵션입니다."
        cell.textLabel?.font = .systemFont(ofSize: 13)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didselectRowAt(indexPath: indexPath)
    }
}
