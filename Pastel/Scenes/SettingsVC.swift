//
//  SettingsVC.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/30/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import Kingfisher

class SettingsVC: UITableViewController {

    let cache = ImageCache.default

    @IBOutlet weak var sizeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                self.sizeLabel.text = "\(size / 1024 / 1024) MB"
                print("Disk cache size: ")
            case .failure(let error):
                print(error)
            }
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            cache.clearDiskCache {
                let alertController = UIAlertController(title: "Success", message: "Cached images removed successfully", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {[weak self](_) in
                    self?.tableView.reloadData()
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
