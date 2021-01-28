//
//  PokemonCollectionViewCell.swift
//  swift-test
//
//  Created by Haldun  Fadillioglu on 27.01.2021.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    static var identifier: String = "PokemonCollectionViewCell"
    
    var uilabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uilabel = UILabel(frame: CGRect(origin: .zero, size: frame.size))
        self.addSubview(uilabel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with name: String) {
        uilabel.text = name
    }
}
