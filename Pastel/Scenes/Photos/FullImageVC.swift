//
//  FullImageVC.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/29/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import os

class FullImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: FullImagePresenter!
    var doubleTapGestureRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0

        self.presenter.attachView(view: self)
        setupTappingGestureRecognizer()
        setupPanGestureRecognizer()
    }
    
    // Sets up the gesture recognizer for pan to dismiss view
    func setupPanGestureRecognizer() {
        os_log("FullImageVC.setupPanGestureRecognizer()", type: .debug)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imageViewDragged(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func imageViewDragged(_ sender: UIPanGestureRecognizer) {
        os_log("FullImageVC.imageViewDragged(_ sender: UIPanGestureRecognizer)", type: .debug)
        // convert y-position to downward pull progress (percentage)
        
        let translation = sender.translation(in: imageView)
        
        switch sender.state {
        case .changed:
            self.imageView.frame.origin = CGPoint(x: translation.x, y: translation.y)
        case .cancelled:
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.frame.origin = CGPoint(x: 0, y: 0)
            })
        case .ended:
            let velocity = sender.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.imageView.frame.origin = CGPoint(
                            x: self.imageView.frame.origin.x,
                            y: self.imageView.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.frame.origin = CGPoint(x: 0, y: 0)
                })
            }
        default:
            break
        }
    }
    
    // Sets up the gesture recognizer for double taps to auto-zoom
    func setupTappingGestureRecognizer() {
        os_log("FullImageVC.setupTappingGestureRecognizer()", type: .debug)
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc func handleDoubleTap() {
        os_log("FullImageVC.handleDoubleTap()", type: .debug)
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scrollView.maximumZoomScale, center: doubleTapGestureRecognizer.location(in: doubleTapGestureRecognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        os_log("FullImageVC.zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect", type: .debug)
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    // MARK: IBActions
    @IBAction func dismissTapped() {
        os_log("FullImageVC.dismissTapped()", type: .debug)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FullImageVC: FullImageViewDelegate {
    func showLoader() {
        os_log("FullImageVC.showLoader()", type: .debug)
        self.activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        os_log("FullImageVC.hideLoader()", type: .debug)
        self.activityIndicator.stopAnimating()
    }
    
    func configViewWith(image: UIImage) {
        os_log("FullImageVC.configViewWith(image: UIImage)", type: .debug)
        self.imageView.image = image
        self.view.layoutIfNeeded()
    }    
}

extension FullImageVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
