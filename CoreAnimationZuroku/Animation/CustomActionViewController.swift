//
//  CustomActionViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

/// When the switch is turned on, the image will be set. Custom action (animation) for a set of values to
/// the contents property. The transition animation will be played.
/// スイッチをONにすると画像がセットされます。contentsプロパティへの値のセットのアクション（アニメーション）をカスタムする実装サンプル。
/// 遷移アニメーションが再生されます。
class CustomActionViewController: UIViewController {

    private let sampleView = ImageLayerView()
    private let switchView = UISwitch()
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Custom Action"
        view.backgroundColor = .systemBackground

        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        sampleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        sampleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(false, animated: false)
        view.addSubview(switchView)
        switchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchView.topAnchor.constraint(equalTo: sampleView.bottomAnchor, constant: 20).isActive = true
        switchView.addTarget(self, action: #selector(switchViewValueChanged(_:)), for: .valueChanged)

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        label.numberOfLines = 0
        label.text = "When the switch is turned on, the image will be set. Custom action (animation) for a set of values to the contents property. The transition animation will be played."
    }

    @objc private func switchViewValueChanged(_ sender: UISwitch) {
        sampleView.subLayer.contents = sender.isOn ? UIImage(named: "caz")?.cgImage : nil
    }
}

extension CustomActionViewController {

    class ImageLayerView: UIView {

        let subLayer = CALayer()

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
//            subLayer.backgroundColor = UIColor.yellow.cgColor
            subLayer.style = ["backgroundColor": UIColor.yellow.cgColor]
            subLayer.actions = ["contents": MyAction()]
            subLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(subLayer)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            subLayer.frame = bounds
        }
    }
}

private class MyAction: CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        guard event == "contents", let layer = anObject as? CALayer else { return }
        let animation = CATransition()
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.type = .push
        animation.subtype = .fromRight
        layer.add(animation, forKey: "contents")
    }
}
