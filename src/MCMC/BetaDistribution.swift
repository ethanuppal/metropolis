// Copyright (C) 2023 Ethan Uppal. All rights reserved.

import Darwin

func factorial(_ n: Int) -> Int {
    var result = 1
    var i = 0
    while i < n {
        i += 1
        result *= i
    }
    return result
}

public struct BetaDistribution: ProbabilityFunction {
    public let a: Double
    public let b: Double
    private let normalizingConstant: Double
    public init(a: Int, b: Int) {
        self.a = Double(a)
        self.b = Double(b)
        self.normalizingConstant = Double(factorial(a - 1)) * Double(factorial(b - 1)) / Double(factorial(a + b - 1))
    }

    public var mean: Probability {
        return a / (a + b)
    }
    public var variance: Probability {
        return a * b / ((a + b) * (a + b) * (a + b + 1))
    }
    public var standardDeviation: Probability {
        return variance.squareRoot()
    }

    public func eval(_ theta: Probability) -> Probability {
        assert(
            (0 ... 1).contains(theta),
            "BetaDistribution: theta must be a valid probability"
        )
        return pow(theta, a - 1) * pow(1 - theta, b - 1) / normalizingConstant
    }
}
