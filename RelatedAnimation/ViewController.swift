//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Margarita Slesareva on 07.02.2024.
//

import UIKit

private enum Metrics {
    static let squareHeight: CGFloat = 100
    static let squareColor: UIColor = .systemBlue
}

final class ViewController: UIViewController {
    
    private let squareView = UIView()
    private let slider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setFrame()
        addConstraints()
        configureViews()
    }
    
    private func addViews() {
        [squareView, slider].forEach {
            view.addSubview($0)
        }
        
        slider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setFrame() {
        squareView.frame = CGRect(
            x: squareView.layoutMargins.left,
            y: Metrics.squareHeight,
            width: Metrics.squareHeight,
            height:  Metrics.squareHeight
        )
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: slider.layoutMargins.left),
            slider.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -slider.layoutMargins.right)
        ])
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        squareView.backgroundColor = Metrics.squareColor
        squareView.layer.cornerRadius = 10
        
        slider.addTarget(self, action: #selector(squareRotate), for: .valueChanged)
        slider.minimumValue = Float(squareView.frame.origin.x)
        slider.maximumValue = Float(view.frame.width - squareView.layoutMargins.right - squareView.frame.width)
    }
    
    @objc private func squareRotate() {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.squareView.frame.origin.x = CGFloat(self.slider.value)
        }
        
        animator.startAnimation()
    }
}
