import Foundation

/// An implementation of a Newton-Raphson optimization algorithm to calculate an internal rate of return at a minimum precision of 1e-7 using a maximum of 25 iterations
func xirr(presentValue: Double, cashFlows: [(pmt: Double, t: Double)], irrStartingGuess: Double) -> Double? {
    let maxIterations: Int = 25
    let precision: Double = 1e-7
    var irrStartingGuess: Double = irrStartingGuess
    var irrEndingGuess: Double
    var iterations = 0
    
    while iterations < maxIterations {
        /// The output of a net present value function (function implemented is the negative of the given present value, plus the cash flows discounted to present time by the internal rate of return interest rate
        let npv: Double = -presentValue + cashFlows.reduce(0, { (accumulation, cashFlow: (pmt: Double, t: Double)) in
            return accumulation + (cashFlow.pmt / Double(pow(Float(1.0 + irrStartingGuess), Float(cashFlow.t))))
        })
        /// The first derivative of a net present value function
        let ddx: Double = cashFlows.reduce(0, { (accumulation, cashFlow: (pmt: Double, t: Double)) in
            return accumulation + (-cashFlow.t * cashFlow.pmt / Double(pow(Float(1.0 + irrStartingGuess), Float(cashFlow.t+1.0))))
        })
        irrEndingGuess = irrStartingGuess - npv/ddx
        if abs(irrEndingGuess - irrStartingGuess) <= precision {
            return irrEndingGuess
        }
        irrStartingGuess = irrEndingGuess
        iterations += 1
    }
    return nil
    
}
