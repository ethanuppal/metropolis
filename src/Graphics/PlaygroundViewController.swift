// Copyright (C) 2023 Ethan Uppal. All rights reserved.

// Copyright (C) 2023 Ethan Uppal. All rights reserved.

import UIKit

class PlaygroundView: UIView {
    var drawFunction: PlaygroundGraphics.DrawFunction = { _,_  in }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(drawFunction: @escaping PlaygroundGraphics.DrawFunction) {
        super.init(frame: .zero)
        self.drawFunction = drawFunction
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        self.drawFunction(rect, ctx)
        super.draw(rect)
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        setNeedsDisplay()
    }
}
