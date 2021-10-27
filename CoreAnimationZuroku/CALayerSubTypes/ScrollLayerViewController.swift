//
//  ScrollLayerViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class ScrollLayerViewController: UIViewController {

    private let sampleText = """
THE GOLDEN BIRD

  A certain king had a beautiful garden, and in the garden stood a tree which bore golden apples. These apples were always counted, and about the time when they began to grow ripe it was found that every night one of them was gone. The king became very angry at this, and ordered the gardener to keep watch all night under the tree. The gardener set his eldest son to watch; but about twelve o’clock he fell asleep, and in the morning another of the apples was missing. Then the second son was ordered to watch; and at midnight he too fell asleep, and in the morning another apple was gone. Then the third son offered to keep watch; but the gardener at first would not let him, for fear some harm should come to him: however, at last he consented, and the young man laid himself under the tree to watch. As the clock struck twelve he heard a rustling noise in the air, and a bird came flying that was of pure gold; and as it was snapping at one of the apples with its beak, the gardener’s son jumped up and shot an arrow at it. But the arrow did the bird no harm; only it dropped a golden feather from its tail, and then flew away. The golden feather was brought to the king in the morning, and all the council was called together. Everyone agreed that it was worth more than all the wealth of the kingdom: but the king said, ‘One feather is of no use to me, I must have the whole bird.’
"""

    private var scrollLayer: CAScrollLayer = {
        let scrollLayer = CAScrollLayer()
        scrollLayer.scrollMode = .vertically
        return scrollLayer
    }()

    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(scroll(_:)))
        displayLink.preferredFramesPerSecond = 10
        return displayLink
    }()

    private var translation: CGFloat = 0.0
    private var moveDown = true
    private var wrapCount = 0
    private let label = UILabel()
    private let container = UIView()
    private var bottomOffset: CGFloat {
        return label.frame.size.height - container.bounds.size.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAScrollLayer"
        view.backgroundColor = .white

        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.layoutIfNeeded()

        label.backgroundColor = .black
        label.textColor = .white
        label.numberOfLines = 0
        label.text = sampleText
        label.font = .systemFont(ofSize: 24)
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        label.sizeToFit()

        scrollLayer.addSublayer(label.layer)
        scrollLayer.frame = container.bounds
        container.layer.addSublayer(scrollLayer)

        // start scroll
        displayLink.add(to: .current, forMode: .default)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayLink.invalidate()
    }

    @objc private func scroll(_ displayLink: CADisplayLink) {
        let newPoint = CGPoint(x: 0, y: translation)
        scrollLayer.scroll(newPoint)

        let isBottomTouched = newPoint.y == bottomOffset
        let isTopTouched = newPoint.y == 0
        if isBottomTouched {
            moveDown = false
            wrapCount += 1
        } else if isTopTouched {
            moveDown = true
            if wrapCount == 2 {
                // stop scroll
                print("stop")
                displayLink.invalidate()
            }
        }

        // nextNewPoint
        translation += moveDown ? 10 : -10
        translation = moveDown ? min(translation, bottomOffset) : max(translation, 0)
        print(translation)
    }
}
