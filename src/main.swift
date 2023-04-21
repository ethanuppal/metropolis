// Copyright (C) 2023 Ethan Uppal. All rights reserved.

print("Bayesian Analysis")
print("using Markov chain Monte Carlo")
print("==============================")
print()

let flips = 2
let heads = 1
print("Observations")
print("------------")
print("  - \(flips) coin flips")
print("  - \(heads) head(s)")
print()

let a = 1
let b = 1
let prior = BetaDistribution(a: a, b: b)
print("Prior")
print("-----")
print("  We use an uninformed prior: beta(a=\(a), b=\(b))")
print()

let likelihoodFunction = BernoulliDistribution(
    N: Double(flips),
    z: Double(heads)
)
print("Likelihood")
print("----------")
print("  P(data|θ) = bernoulli(N=\(flips), z=\(heads))")
print()

let burnin = 3000
let steps = 10000

let seed = Probability.random(in: 0 ... 1)

let proposalAlgorithm = NormalDistribution(
    mean: 0,
    standardDeviation: 0.2
)

let metropolis = Metropolis(
    prior: prior,
    likelihoodFunction: likelihoodFunction,
    seed: seed,
    proposalAlgorithm: proposalAlgorithm
)

metropolis.run(steps: steps, burninPeriod: burnin)
let (mean, standardDeviation) = metropolis.samples.sampleStatistics()

print("Metropolis")
print("----------")
print("  We perform the metropolis algorithm to estimate the central tendency of the posterior distribution.")
print("  Random seed: \(seed)")
print("  Steps: \(steps)")
print("  Burn-in Period: \(burnin)")
print("  Est. Mean: \(mean)")
print("  Est. StdDev: \(standardDeviation)")
print()

let posterior = BetaDistribution(a: a + heads, b: b + flips - heads)
print("Actual")
print("------")
print("  P(θ|data) = beta(a=\(a + heads), b=\(b + flips - heads))")
print("  Act. Mean:", posterior.mean, "(\(((mean - posterior.mean) / posterior.mean * 100).rounded())% error)")
print("  Act. StdDev:", posterior.standardDeviation, "(\(((standardDeviation - posterior.standardDeviation) / posterior.standardDeviation * 100).rounded())% error)")

import CoreGraphics

let histogram = PlaygroundGraphics.Graph(
    form: .histogram(
        data: metropolis.samples.map { CGFloat($0) },
        bucket: 0.1,
        outlineBars: true
    ),
    nX: 5,
    nY: 4
)

let graphics = PlaygroundGraphics { rect, ctx in
    ctx.setFillColor(gray: 255, alpha: 255)
    ctx.fill(rect)

    let frame = CGRect(
        x: 20,
        y: 20,
        width: rect.width - 60,
        height: 400
    )
    histogram.draw(in: frame, ctx: ctx)
}

graphics.present()
