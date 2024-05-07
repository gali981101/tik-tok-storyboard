//
//  SegmentedProgressView.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/26.
//

import UIKit

// MARK: - SegmentedProgressView

class SegmentedProgressView: UIView {
    
    // MARK: - Properties
    
    private let width: CGFloat
    
    private lazy var aPath: UIBezierPath = UIBezierPath()
    private lazy var segments: [UIView] = []
    private lazy var segmentPoints: [CGFloat] = []
    
    // MARK: - UIElement
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }()
    
    fileprivate lazy var trackLayer: CAShapeLayer = {
        let trackerLayer = CAShapeLayer()
        
        trackerLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackerLayer.lineWidth = 6
        trackerLayer.strokeEnd = 1
        trackerLayer.lineCap = .round
        
        return trackerLayer
    }()
    
    // MARK: - init
    
    required init(width: CGFloat) {
        self.width = width
        super.init(frame: .zero)
        handleDrawPaths()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Set up

extension SegmentedProgressView {
    
    fileprivate func handleDrawPaths() {
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.addLine(to: CGPoint(x: width, y: 0.0))
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.close()
        
        handleSetupTrackLayer()
        handleSetupShapeLayer()
    }
    
    fileprivate func handleSetupTrackLayer() {
        trackLayer.path = aPath.cgPath
        layer.addSublayer(trackLayer)
    }
    
    fileprivate func handleSetupShapeLayer() {
        shapeLayer.path = aPath.cgPath
        layer.addSublayer(shapeLayer)
    }
    
}

// MARK: - Helper Methods

extension SegmentedProgressView {
    
    func setProgress(_ progress: CGFloat) {
        shapeLayer.strokeEnd = progress
    }
    
    func pauseProgress() {
        let newSegment = handleCreateSegment()
        
        addSubview(newSegment)
        
        newSegment.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3).isActive = true
        
        segments.append(newSegment)
        segmentPoints.append(shapeLayer.strokeEnd)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.handlePositionSegment(newSegment: newSegment)
        }
    }
    
    func handleRemoveLastSegment() {
        segments.last?.removeFromSuperview()
        segmentPoints.removeLast()
        segments.removeLast()
        shapeLayer.strokeEnd = segmentPoints.last ?? 0
    }
    
    private func handleCreateSegment() -> UIView {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 4).isActive = true
        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        return view
    }
    
    private func handlePositionSegment(newSegment: UIView) {
        let positionPath = CGPoint(x: shapeLayer.strokeEnd * frame.width, y: 0)
        newSegment.constraintToLeft(paddingLeft: positionPath.x)
        newSegment.backgroundColor = UIColor.white
    }
    
}














