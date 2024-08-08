//
//  CountryFlagVC.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit

class CountryFlagVC: UIViewController {

    var vm: CountryFlagVM?
    private var country: CountryData?
    
    @IBOutlet weak var countryFlag: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let country {
            vm = CountryFlagVM(country: country)
        }
        setupContent()
    }
    
    init(country: CountryData?) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            countryName.text = country?.name?.common
            countryFlag.text = country?.flag
            countryFlag.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            countryFlag.adjustsFontSizeToFitWidth = true
            let maxSize = min(countryFlag.bounds.size.width, countryFlag.bounds.size.height)
            countryFlag.font = countryFlag.font.withSize(maxSize)
            countryFlag.baselineAdjustment = .alignCenters
            countryFlag.textAlignment = .center
            countryFlag.isHidden = false
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        backButtonPressed()
    }
}
