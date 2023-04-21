// Copyright (C) 2023 Ethan Uppal. All rights reserved.

public class Metropolis {
    private let prior: ProbabilityFunction
    private let likelihoodFunction: LikelihoodFunction
    private var current: Probability
    private var currentLikelihood: Probability {
        return likelihoodFunction.eval(current)
    }
    private let proposalAlgorithm: ProposalAlgorithm
    public private(set) var samples = [Double]()

    public init(prior: ProbabilityFunction, likelihoodFunction: LikelihoodFunction, seed: Probability, proposalAlgorithm: ProposalAlgorithm) {
        self.prior = prior
        self.likelihoodFunction = likelihoodFunction
        self.current = seed
        self.proposalAlgorithm = proposalAlgorithm
    }

    public func run(steps: Int, burninPeriod: Int) {
        for i in 0 ..< steps {
            performStep(use: i >= burninPeriod)
        }
    }

    private func performStep(use: Bool) {
        current = proposeStep()
        if use {
            samples.append(current)
        }
    }

    private func posteriorRatio(proposal: Probability) -> Probability {
        return (prior.eval(proposal) * likelihoodFunction.eval(proposal)) / (prior.eval(current) * currentLikelihood)
    }

    private func proposeStep() -> Probability {
        var proposal = current + proposalAlgorithm.randomDelta()
        if !(0 ... 1).contains(proposal) {
            return current
        } else {
            let ratio = posteriorRatio(proposal: proposal)

            if ratio >= 1 {
                // If proposal probability is greater, move there definitely
                return proposal
            } else if Double.random(in: 0 ... 1) <= ratio {
                // Otherwise move there with probability Pproposed / Pcurrent
                return proposal
            } else {
                return current
            }
        }
    }
}
