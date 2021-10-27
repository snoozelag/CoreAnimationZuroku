//
//  SplitViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.topViewController?.navigationItem.leftBarButtonItem = displayModeButtonItem
        preferredDisplayMode = .allVisible
        delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController: UIViewController) -> Bool {

        if let navigationController = secondaryViewController as? UINavigationController, navigationController.topViewController is DetailViewController {
            return true
        } else {
            return false
        }
    }
}
