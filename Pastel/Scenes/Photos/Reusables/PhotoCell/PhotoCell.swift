//
//  PhotoCell.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            var urlStr = photoBaseURL
            urlStr = urlStr.replacingOccurrences(of: "{farm-id}", with: "\(photo.farm ?? 0)")
            urlStr = urlStr.replacingOccurrences(of: "{server-id}", with: photo.server ?? "")
            urlStr = urlStr.replacingOccurrences(of: "{id}", with: photo.id ?? "")
            urlStr = urlStr.replacingOccurrences(of: "{secret}", with: photo.secret ?? "")

            let url = URL(string: urlStr)
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: { (_, _) in
            }) { (_) in
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
