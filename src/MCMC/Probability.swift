// Copyright (C) 2023 Ethan Uppal. All rights reserved.

import Darwin

public typealias Probability = Double

public enum Constants {
    public static let root2 = pow(2, 0.5)
}
public enum ErrorFunction {
    // https://stackoverflow.com/a/40260471
    public static func erfinv(_ x: Double) -> Double {
        var tt1: Double
        var tt2: Double
        var lnx: Double
        var sgn: Double

        sgn = (x < 0) ? -1 : 1

        let xModified = (1 - x) * (1 + x)        // x = 1 - x*x;
        lnx = log(xModified)

        tt1 = 2 / (Double.pi * 0.147) + 0.5 * lnx
        tt2 = 1 / 0.147 * lnx

        return sgn * sqrt(-tt1 + sqrt(tt1 * tt1 - tt2))
    }
    public static func ercinv(_ x: Double) -> Double {
        return erfinv(1 - x)
    }
}

public struct NormalDistribution: ProposalAlgorithm {
    public let mean: Probability
    public let standardDeviation: Probability
    public init(mean: Probability, standardDeviation: Probability) {
        self.mean = mean
        self.standardDeviation = standardDeviation
    }

    public func inverse(_ area: Probability) -> Double {
        return self.mean + self.standardDeviation * -Constants.root2 * ErrorFunction.ercinv(2 * area)
    }

    public func randomDelta() -> Double {
        return self.inverse(.random(in: 0 ... 1))
    }
}
