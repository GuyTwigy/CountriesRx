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
    @IBOutlet weak var noCountriesIndicationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addRefreshControl(to: tblCountries, action: #selector(refreshData))
        vm = CountriesListVM()
        vm?.delegate = self
    }
    
    private func setupTableView() {
        tblCountries.delegate = self
        tblCountries.dataSource = self
        tblCountries.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
    }
    
    private func filterCountries(with searchText: String) -> [CountryData] {
        let filteredList = notFilteredCountryList.filter { country in
            return country.name?.common?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return filteredList
    }
    
    private func resetCountriesList() -> [CountryData] {
        return notFilteredCountryList
    }
    
    @objc private func refreshData() {
        searchTextField.text = ""
        Task {
            await vm?.fetchCountries()
        }
    }
}

extension CountriesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        cell.setupCellContent(country: countryList[indexPath.row])
        cell.selectionStyle = .none
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
    func countriesFetched(countries: [CountryData]?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Something went wrong, please try again", message: "\(error)")
                self.tblCountries.reloadData()
                self.endRefreshing(scrollView: self.tblCountries)
            } else if let countries {
                self.countryList.removeAll()
                self.notFilteredCountryList.removeAll()
                self.countryList = countries
                self.notFilteredCountryList = countries
                self.tblCountries.reloadData()
                self.endRefreshing(scrollView: self.tblCountries)
            }
            self.loader.stopAnimating()
        }
    }
}

extension CountriesListVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            countryList = filterCountries(with: searchText)
        } else {
            countryList = resetCountriesList()
        }
        noCountriesIndicationLbl.text = "No Countries Found for '\(textField.text ?? "")'"
        noCountriesIndicationLbl.isHidden = !countryList.isEmpty
        tblCountries.reloadData()
    }
}

