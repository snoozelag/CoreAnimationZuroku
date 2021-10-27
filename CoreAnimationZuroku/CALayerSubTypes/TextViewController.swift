//
//  TextViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class TextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CATextLayer"
        view.backgroundColor = .lightGray

        let string = """
CATextLayer
A layer that provides simple
text layout and rendering of
 plain or attributed strings.
"""
        let fontSize: CGFloat = 18
        let font = UIFont(name: "Copperplate-Light", size: fontSize)!

        let textLayer = CATextLayer()
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.string = string
        textLayer.frame = CGRect(origin: .zero, size: string.size(OfFont: font))
        textLayer.position = view.center
        textLayer.font = font // Or "Copperplate-Light" as CFTypeRef
        textLayer.fontSize = fontSize // If you don't set the fontSize property, it won't be reflected.
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale

        view.layer.addSublayer(textLayer)
    }
}

extension String {

    // https://stackoverflow.com/a/56189950
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
