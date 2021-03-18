//
//  ReflectionTransition.swift
//  firstEntry
//
//  Created by user on 18.03.2021.
//

import UIKit

class ReflectionTransition{
    private var sourceBase: Double
    private var targetBase: Double
    
    private var sourceDif: Double
    private var targetDif: Double
    
    public init(sourcePairOfLimits source: (min: Double, max: Double), targetPairOfLimits target: (min: Double, max: Double)){
        (sourceBase, sourceDif) = {
            var dif = source.max - source.min
            dif = dif > 0 ? dif : -dif
            let base = min(source.max, source.min)
            return (base, dif)
        }()
        
        (targetBase, targetDif) = {
            var dif = target.max - target.min
            dif = dif > 0 ? dif : -dif
            let base = min(target.max, target.min)
            return (base, dif)
        }()
    
    }
    public func getTargetValue(_ sourceValue: Double) -> Double?{
        let dif = sourceValue - sourceBase
        if dif > sourceDif || dif < 0{
            return nil
        }
        let koef = dif / sourceDif
        return targetBase + koef * targetDif
    }
}
