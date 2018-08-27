//
//  Emitter.swift
//  Cold Collection
//
//  Created by Carter Brown on 8/8/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit

class Emitter {
    
    static func get(with image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    
    static func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        
        // Configure cell
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 2
        cell.lifetime = 55
        cell.velocity = CGFloat(25)
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi/4
        cell.scale = 0.5
        cell.scaleRange = 0.4
        
        cells.append(cell)
        
        return cells
    }
}
