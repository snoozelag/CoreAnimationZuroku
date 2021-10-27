//
//  LayerDelegateSampleViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

/// Providing a Layer’s Contents
/// Assign a delegate object to the layer and let the delegate draw the layer’s content. 
class LayerDelegateSampleViewController: UIViewController {

    private let sampleView = ImageView()
    private let drawView = DrawView()
    private let switchView = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Delegate Sample"
        view.backgroundColor = .systemBackground

        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        sampleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        sampleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        drawView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawView)
        drawView.topAnchor.constraint(equalTo: sampleView.bottomAnchor, constant: 11).isActive = true
        drawView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        drawView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        drawView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(true, animated: false)
        view.addSubview(switchView)
        switchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        switchView.addTarget(self, action: #selector(switchViewValueChanged(_:)), for: .valueChanged)
    }

    @objc private func switchViewValueChanged(_ sender: UISwitch) {
        sampleView.showsImage = sender.isOn
        drawView.drawType = sender.isOn ? .square : .circle
    }
}

private class ImageView: UIView {

    private let subLayer = CALayer()
    private let layerDelegate = LayerDelegate()

    var showsImage: Bool {
        get { layerDelegate.showsImage }
        set {
            // When the content selection changes, it will be reflected in the sublayers.
            if layerDelegate.showsImage != newValue {
                layerDelegate.showsImage = newValue
                subLayer.setNeedsDisplay()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subLayer.frame = bounds
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // This is used when the content of the layer changes dynamically.
        subLayer.contents = UIImage(named: "caz")?.cgImage
        subLayer.contentsScale = UIScreen.main.scale
        subLayer.delegate = layerDelegate
        layer.addSublayer(subLayer)
    }

    private class LayerDelegate: NSObject, CALayerDelegate {

        var showsImage: Bool = true

        // The displayLayer: method implementation is responsible for creating a bitmap and assigning it to the layer’s contents property.
        func display(_ layer: CALayer) {
            // By simply updating the properties of the layer object, Core Animation will implicitly create an animation object and schedule it to perform the animation.
            if showsImage {
                layer.opacity = 1
            } else {
                layer.opacity = 0
            }
        }
    }
}

private class DrawView: UIView {

    enum DrawType {
        case square
        case circle
    }

    private let subLayer = CALayer()
    private let layerDelegate = LayerDelegate()

    var drawType: DrawType {
        get { layerDelegate.drawType }
        set {
            if layerDelegate.drawType != newValue {
                // If the size of the parent view changes, it will be reflected in the sublayer.
                layerDelegate.drawType = newValue
                subLayer.setNeedsDisplay()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // This is used when the content of the layer changes dynamically.
        subLayer.delegate = layerDelegate
        layer.addSublayer(subLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subLayer.frame = bounds
        subLayer.setNeedsDisplay()
    }

    private class LayerDelegate: NSObject, CALayerDelegate {

        var drawType: DrawType = .square

        // NOTE: If displayLayer: is implemented, the layer will only call the displayLayer: method. The implementation should be drawLayer:inContext: or only one of the methods.
        func draw(_ layer: CALayer, in context: CGContext) {
            // By simply updating the properties of the layer object, Core Animation will implicitly create an animation object and schedule it to perform the animation.
            let lineWidth: CGFloat = 10
            context.setLineWidth(lineWidth)

            let halfLineWidth = lineWidth / 2
            let shortSideLength = min(layer.bounds.size.height, layer.bounds.size.width)
            let longSideLength = max(layer.bounds.size.height, layer.bounds.size.width)
            let squareRect = CGRect(x: longSideLength / 2 - shortSideLength / 2, y: 0, width: shortSideLength, height: shortSideLength).insetBy(dx: halfLineWidth, dy: halfLineWidth)

            switch drawType {
            case .square:
                context.addRect(squareRect)
                context.setStrokeColor(UIColor.blue.cgColor)
                context.setFillColor(UIColor.yellow.cgColor)
            case .circle:
                context.addEllipse(in: squareRect)
                context.setStrokeColor(UIColor.red.cgColor)
                context.setFillColor(UIColor.green.cgColor)
            }
            context.drawPath(using: .fillStroke)
        }
    }
}

