// Copyright (C) 2023 Ethan Uppal. All rights reserved.

import CoreGraphics
import PlaygroundSupport

public protocol PlaygroundGraphicsDrawable {
        func draw(in frame: CGRect, ctx: CGContext)
    }

public class PlaygroundGraphics {
    public typealias DrawFunction = (CGRect, CGContext) -> ()

    private let playgroundPage: PlaygroundPage
    private let drawFunction: DrawFunction
    private let viewController: PlaygroundViewController

    public init(playgroundPage: PlaygroundPage = .current, drawFunction: @escaping DrawFunction) {
        self.playgroundPage = playgroundPage
        self.drawFunction = drawFunction
        self.viewController = PlaygroundViewController()

        setup()
    }

    public func present() {
        self.playgroundPage.liveView = self.viewController
    }

    public func finish() {
        self.playgroundPage.finishExecution()
    }

    private func setup() {
        self.playgroundPage.needsIndefiniteExecution = true
        self.viewController.setDrawFunction(drawFunction)
    }
}
