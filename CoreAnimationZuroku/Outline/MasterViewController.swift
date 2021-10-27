//
//  MasterViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit
import SwiftUI

class SubtitleCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        accessoryType = .disclosureIndicator
    }
}

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CoreAnimationZuroku"

        tableView.register(SubtitleCell.self, forCellReuseIdentifier: "SubtitleCell")
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    private func showDetail(_ detail: UIViewController) {
        let navigationController = UINavigationController(rootViewController: detail)
        navigationController.viewControllers = [detail]
        showDetailViewController(navigationController, sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 8
        case 2:
            return 5
        default:
            preconditionFailure()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Providing a Layer’s Contents"
        case 1:
            return "CALayer SubTypes"
        case 2:
            return "Layers And Animations"
        default:
            preconditionFailure()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath) as! SubtitleCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "CALayerDelegate"
                cell.detailTextLabel?.text = ""
            case 1:
                cell.textLabel?.text = "CALayer Subclass"
                cell.detailTextLabel?.text = ""
            default:
                preconditionFailure()
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "CAEmitterLayer"
                cell.detailTextLabel?.text = ""
            case 1:
                cell.textLabel?.text = "CAGradientLayer"
                cell.detailTextLabel?.text = ""
            case 2:
                cell.textLabel?.text = "CAMetalLayer"
                cell.detailTextLabel?.text = ""
            case 3:
                cell.textLabel?.text = "CAReplicatorLayer"
                cell.detailTextLabel?.text = ""
            case 4:
                cell.textLabel?.text = "CAScrollLayer"
                cell.detailTextLabel?.text = ""
            case 5:
                cell.textLabel?.text = "CAShapeLayer"
                cell.detailTextLabel?.text = ""
            case 6:
                cell.textLabel?.text = "CATextLayer"
                cell.detailTextLabel?.text = ""
            case 7:
                cell.textLabel?.text = "CATransformLayer"
                cell.detailTextLabel?.text = ""
            default:
                preconditionFailure()
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Contents Gravity"
                cell.detailTextLabel?.text = ""
            case 1:
                cell.textLabel?.text = "Contents with Shadow"
                cell.detailTextLabel?.text = ""
            case 2:
                cell.textLabel?.text = "Animatable KeyPaths"
                cell.detailTextLabel?.text = ""
            case 3:
                cell.textLabel?.text = "Custom Action"
                cell.detailTextLabel?.text = ""
            case 4:
                cell.textLabel?.text = "Chain Animations, Pause, Resume"
                cell.detailTextLabel?.text = ""
            default:
                preconditionFailure()
            }
        default:
            preconditionFailure()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                showDetail(LayerDelegateSampleViewController())
            case 1:
                showDetail(LayerSubclassSampleViewController())
            default:
                preconditionFailure()
            }
        case 1:
            switch indexPath.row {
            case 0:
                showDetail(EmitterViewController())
            case 1:
                showDetail(GradientViewController())
            case 2:
                showDetail(MetalViewController())
            case 3:
                showDetail(ReplicatorViewController())
            case 4:
                showDetail(ScrollLayerViewController())
            case 5:
                showDetail(ShapeViewController())
            case 6:
                showDetail(TextViewController())
            case 7:
                showDetail(TransformViewController())
            default:
                preconditionFailure()
            }
        case 2:
            switch indexPath.row {
            case 0:
                showDetail(GravityViewController())
            case 1:
                showDetail(ContentsShadowViewController())
            case 2:
                showDetail(AnimatableKeyPathViewController())
            case 3:
                showDetail(CustomActionViewController())
            case 4:
                showDetail(ChainAnimationsViewController())
            default:
                preconditionFailure()
            }
        default:
            preconditionFailure()
        }
    }
}
