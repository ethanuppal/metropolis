// Copyright (C) 2023 Ethan Uppal. All rights reserved.

public extension Numeric {
    func squared() -> Self {
        return self * self
    }
}
public extension Array where Element: FloatingPoint {
    func sampleStatistics() -> (mean: Element, standardDeviation: Element) {
        let mean = reduce(Element.zero, +) / Element(count)
        let sampleVariance = reduce(Element.zero) { $0 + ($1 - mean).squared() } / Element(count - 1)
        return (mean, sampleVariance.squareRoot())
    }
}
