//
//  CountryCell.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 8
            cellView.clipsToBounds = true
            cellView.layer.masksToBounds = false
            cellView.layer.shadowRadius = 4
            cellView.layer.shadowOpacity = 0.5
            cellView.layer.shadowOffset = CGSize(width: 2, height: 4)
            cellView.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }
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
