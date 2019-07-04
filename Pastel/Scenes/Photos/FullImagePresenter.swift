//
//  FullImagePresenter.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/29/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import os

protocol FullImageViewDelegate: class {
    /**
     **Show loading loader**.
     ``
     Called to show any loading action
     ``
     */
    func showLoader()
    /**
     **Hide loading loader**.
     ``
     Called to hide any loading action
     ``
     */
    func hideLoader()
    /**
     **Configure View**.
     ``
     Called to configure the view with an image after loading it
     ``
     - Parameter image: the returned image that downloaded from the object image url
     */
    func configViewWith(image: UIImage)
}

class FullImagePresenter {
    private weak var view: FullImageViewDelegate?
    private var photo: Photo!
    
    private let photoBaseURL = "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_\(FlickrImagesQuality.medium).jpg"

    /**
     **Presenter initializer**.
     ``
     Initialize the presenter with specific photo
     ``
     - Parameter photo: The photo that will be shown in it's original size
     */
    init(photo: Photo) {
        self.photo = photo
    }
    
    /**
     **Attach View**.
     ``
     Call this function to attach a view that implementing the `FullImageViewDelegate`
     ``
     - Parameter view: the view that implements the delegate
     */
    func attachView(view: FullImageViewDelegate) {
        os_log("FullImagePresenter.attachView(view: FullImageViewDelegate)", type: .debug)
        self.view = view
        viewDidAttach()
    }
    
    /**
     **View Did Attached**.
     ``
     Called when the view did attached to start loading the image
     ``
     */
    private func viewDidAttach() {
        os_log("FullImagePresenter.viewDidAttach()", type: .debug)
        loadImage()
    }
    
    /**
     **Load Image**.
     ``
     Called to start loading the image
     ``
     */
    private func loadImage() {
        os_log("FullImagePresenter.loadImage()", type: .debug)
        self.view?.showLoader()
        var urlStr = photoBaseURL
        urlStr = urlStr.replacingOccurrences(of: "{farm-id}", with: "\(photo.farm ?? 0)")
        urlStr = urlStr.replacingOccurrences(of: "{server-id}", with: photo.server ?? "")
        urlStr = urlStr.replacingOccurrences(of: "{id}", with: photo.id ?? "")
        urlStr = urlStr.replacingOccurrences(of: "{secret}", with: photo.secret ?? "")
        
        let url = URL(string: urlStr)
        let imageView = UIImageView()
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: { (_, _) in
        }) { (_) in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                self.view?.configViewWith(image: imageView.image!)
            }
        }
    }
}
