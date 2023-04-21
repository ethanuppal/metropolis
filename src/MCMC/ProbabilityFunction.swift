// Copyright (C) 2023 Ethan Uppal. All rights reserved.

public protocol ProbabilityFunction {
    func eval(_ theta: Probability) -> Probability
}

public typealias LikelihoodFunction = ProbabilityFunction
