//
//  CountryFlagVC.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit

class CountryFlagVC: UIViewController {

    private var country: CountryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    init(country: CountryData?) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
