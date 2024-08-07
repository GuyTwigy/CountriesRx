//
//  CountriesListVC.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit

class CountriesListVC: UIViewController {

    private var vm: CountriesListVM?
    private var countryList: [CountryData] = []
    private var notFilteredCountryList: [CountryData] = []
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.startAnimating()
        }
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    @IBOutlet weak var tblCountries: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        vm = CountriesListVM()
        vm?.delegate = self
    }
    
    private func setupTableView() {
        tblCountries.delegate = self
        tblCountries.dataSource = self
        tblCountries.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
    }
}

extension CountriesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        cell.setupCellContent(country: countryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CountryFlagVC(country: countryList[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension CountriesListVC: CountriesListVMDelegete {
    
}

extension CountriesListVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
}

