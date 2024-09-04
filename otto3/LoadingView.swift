//
//  LoadingView.swift
//  otto3
//
//  Created by Cade on 8/31/24.
//

import UIKit
import QuartzCore

class LoadingView: UIView {
    
    // Image for animation
    private let tireImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tire"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        addSubview(tireImageView)
        tireImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tireImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tireImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tireImageView.widthAnchor.constraint(equalToConstant: 100),
            tireImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        startAnimation()
    }
    
    // Animation for tire to rotate
    private func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1
        rotation.repeatCount = .infinity
        tireImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
