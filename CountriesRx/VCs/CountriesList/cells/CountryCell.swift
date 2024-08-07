//
//  CountryCell.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var flagLbl: UILabel!
    @IBOutlet weak var countryNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagLbl.text = ""
        countryNameLbl.text = ""
    }
    
    func setupCellContent(country: CountryData) {
        flagLbl.text = country.flag ?? "🏴‍☠️"
        countryNameLbl.text = country.name?.common ?? "No Country Name Found"
    }
}
