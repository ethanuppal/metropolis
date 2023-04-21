// Copyright (C) 2023 Ethan Uppal. All rights reserved.

import Darwin

public struct BernoulliDistribution: LikelihoodFunction {
    public let N: Double
    public let z: Double
    private let b: Double
    public init(N: Double, z: Double) {
        self.N = N
        self.z = z
        self.b = N - z
    }

    public func eval(_ theta: Probability) -> Probability {
        assert(
            (0 ... 1).contains(theta),
            "BernoulliDistribution: theta must be a valid probability"
        )
        return pow(theta, z) * pow(1 - theta, b)
    }
}
