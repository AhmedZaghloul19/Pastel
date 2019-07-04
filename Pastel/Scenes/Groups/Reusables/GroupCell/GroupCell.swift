//
//  GroupCell.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import Kingfisher

class GroupCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var membersIcon: UIImageView!
    @IBOutlet weak var eighteenPlusView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var membersKeywordLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var group: Group! {
        didSet {
            var urlStr = groupBaseURL
            urlStr = urlStr.replacingOccurrences(of: "{icon-farm}", with: "\(group.iconfarm ?? 0)")
            urlStr = urlStr.replacingOccurrences(of: "{icon-server}", with: group.iconserver ?? "")
            urlStr = urlStr.replacingOccurrences(of: "{nsid}", with: group.nsid ?? "")
            
            let url = URL(string: urlStr)
//            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: { (_, _) in
            }) { (_) in
            }
            self.eighteenPlusView?.isHidden = !(group.isEighteenPlus ?? false)
            self.nameLabel?.text = group.name ?? ""
            self.membersCountLabel?.text = group.members ?? "0"
            self.membersKeywordLabel?.text = group.membersKeyword
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
    }
}

