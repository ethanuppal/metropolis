// Copyright (C) 2023 Ethan Uppal. All rights reserved.

import UIKit

public extension PlaygroundGraphics {
    public struct Graph: PlaygroundGraphicsDrawable {
        public enum Form {
            case histogram(data: [CGFloat], bucket: CGFloat, mergeTop: Bool = true, outlineBars: Bool = false)
        }

        public let form: Form
        public let nX: Int
        public let nY: Int
        public let color: CGColor

        public init(form: Form, nX: Int, nY: Int, color: CGColor = .init(red: 0, green: 255, blue: 0, alpha: 255)) {
            self.form = form
            self.nX = nX
            self.nY = nY
            self.color = color
        }

        public func draw(in frame: CGRect, ctx: CGContext) {
            switch self.form {
            case .histogram(data: let data, bucket: let bucket, let mergeTop, let outlineBars):
                drawHistogram(frame: frame, ctx: ctx, data: data, bucket: bucket, mergeTop: mergeTop, outlineBars: outlineBars)
            }
        }

        public func drawHistogram(frame: CGRect, ctx: CGContext, data: [CGFloat], bucket: CGFloat, mergeTop: Bool, outlineBars: Bool) {
            assert(!data.isEmpty, "Cannot draw histogram from empty data.")

            // https://stackoverflow.com/questions/6801856/nsattributedstring-add-text-alignment#15389684
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center

            UIGraphicsPushContext(ctx)

            let graphFrame = frame.inset(by: .init(top: 0, left: 50, bottom: 50, right: 0))

            // Draw bars

            let min = data.min()!
            let max = data.max()!
            let range = max - min

            // Inefficient but works
            var buckets = [Int]()
            var bucketX = min
            while mergeTop ? (bucketX < max) : (bucketX <= max) {
                let count = data.filter { $0 >= bucketX && $0 < bucketX + bucket }.count
                buckets.append(count)
                bucketX += bucket

                if mergeTop && bucketX >= max {
                    buckets[buckets.count - 1] += data.filter { $0 >= bucketX }.count
                }
            }
            let maxCount = CGFloat(buckets.max()!)

            let rectWidth = graphFrame.width / CGFloat(buckets.count)
            var rectX = graphFrame.minX
            let rectHeightScaler = (1 / maxCount) * graphFrame.height
            ctx.setFillColor(self.color)
            ctx.setStrokeColor(CGColor(gray: 0, alpha: 255))
            for count in buckets {
                let rectHeight = CGFloat(count) * rectHeightScaler
                let barRect = CGRect(x: rectX, y: graphFrame.maxY, width: rectWidth, height: -rectHeight)
                ctx.addRect(barRect)
                ctx.fillPath()
                if outlineBars {
                    ctx.stroke(barRect)
                    ctx.strokePath()
                }
                rectX += rectWidth
            }

            // Draw axes

            ctx.addLines(between: [
                .init(x: graphFrame.minX, y: graphFrame.minY),
                .init(x: graphFrame.minX, y: graphFrame.maxY),
                .init(x: graphFrame.maxX, y: graphFrame.maxY)
            ])
            ctx.strokePath()

            // Label x axis
            for i in 0 ..< nX {
                let xLabel = ((min + range * CGFloat(i) / CGFloat(nX - 1)) * 100).rounded() / 100
                let font = UIFont.systemFont(ofSize: 20)
                let string = NSAttributedString(string: "\(xLabel)", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                string.draw(at: CGPoint(x: graphFrame.minX + CGFloat(i) * graphFrame.width / CGFloat(nX - 1) - string.size().width / 2, y: graphFrame.maxY + 5))
            }

            // Label y axis

            var yStrings = [NSAttributedString]()
            for i in 1 ... nY {
                let yLabel = Int(maxCount) - Int(maxCount) * i / nY
                let font = UIFont.systemFont(ofSize: 20)
                let string = NSAttributedString(string: "\(yLabel)", attributes: [NSAttributedString.Key.font: font])
                yStrings.append(string)
            }
            let maxYWidth = yStrings.map { $0.size().width }.max()!
            for i in 0 ..< nY {
                yStrings[i].draw(at: CGPoint(x: graphFrame.minX - maxYWidth - 10, y: CGFloat(i) * graphFrame.height / CGFloat(nY) + 10))
            }

            UIGraphicsPopContext()
        }
    }
}
