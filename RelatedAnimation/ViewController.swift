//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Margarita Slesareva on 07.02.2024.
//

import UIKit

private enum Metrics {
    static let squareSize: CGSize = .init(width: 100, height: 100)
    static let squareColor: UIColor = .systemBlue
    static let cornerRadius: CGFloat = 10
}

final class ViewController: UIViewController {
    
    private var viewIsLayedOutFirstTime = false

    private let squareView = UIView()
    private let slider = UISlider()
    private let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutMarginsDidChange()
        
        setupSubviewsIfNeeded()
    }
        
    private func setup() {
        addViews()
        configureViews()
        configureAnimator()
    }
    
    private func setupSubviewsIfNeeded() {
        guard !viewIsLayedOutFirstTime else {
            return
        }
        
        setFrame()
        addConstraints()
        
        viewIsLayedOutFirstTime = true
    }
    
    private func addViews() {
        [squareView, slider].forEach {
            view.addSubview($0)
        }
        
        slider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setFrame() {
        let origin = CGPoint(x: view.layoutMargins.left, y: Metrics.squareSize.height)
        squareView.frame = CGRect(origin: origin, size: Metrics.squareSize)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.layoutMargins.left),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height / 5),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.layoutMargins.right)
        ])
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        squareView.backgroundColor = Metrics.squareColor
        squareView.layer.cornerRadius = Metrics.cornerRadius
        
        slider.addTarget(self, action: #selector(updateAnimation), for: .valueChanged)
        slider.addTarget(self, action: #selector(animate), for: .touchUpInside)
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
    }
    
    private func configureAnimator() {
        animator.addAnimations {
            self.squareView.frame = CGRect(
                x: self.view.frame.width - self.squareView.frame.width * 1.5 - self.view.layoutMargins.right,
                y: self.squareView.frame.minY,
                width: self.squareView.frame.width * 1.5,
                height: self.squareView.frame.height * 1.5
            )
            self.squareView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.animator.pausesOnCompletion = true
        }
    }
    
    @objc private func updateAnimation() {
        animator.fractionComplete = CGFloat(slider.value)
    }
    
    @objc private func animate() {
        slider.setValue(slider.maximumValue, animated: true)
        animator.startAnimation()
    }
}
