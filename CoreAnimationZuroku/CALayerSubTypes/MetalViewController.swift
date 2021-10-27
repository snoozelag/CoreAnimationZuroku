//
//  MetalViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit
import MetalKit

class MetalViewController: UIViewController {

    private var device: MTLDevice!
    private var commandQueue: MTLCommandQueue!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAMetalLayer"
        view.backgroundColor = .white

        device = MTLCreateSystemDefaultDevice()
        commandQueue = device.makeCommandQueue()

        let metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.frame = view.bounds
        view.layer.addSublayer(metalLayer)

        let drawable = metalLayer.nextDrawable()!
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = drawable.texture
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 1, alpha: 1)

        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.endEncoding()

        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

