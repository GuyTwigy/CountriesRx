//
//  CountriesListVC.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit
import RxSwift
import RxCocoa

class CountriesListVC: UIViewController {

    private var vm: CountriesListVM?
    private var countryList: [CountryData] = []
    private var finishedScroll: Bool = true
    private var disposebag = DisposeBag()
    private var willAppearFirstTime: Bool = false
    
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
        bindTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if willAppearFirstTime {
            Task {
                await vm?.singleFetchCountries()
            }
        }
        willAppearFirstTime = true
    }
    
    private func setupTableView() {
        tblCountries.delegate = self
        tblCountries.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
    }
    
    @objc private func refreshData() {
        searchTextField.text = ""
        Task {
            await vm?.singleFetchCountries()
        }
    }
    
    func bindTableData() {
        vm?.countryList.bind(to: tblCountries.rx.items(cellIdentifier: "CountryCell", cellType: CountryCell.self)) { row, model, cell in
            cell.setupCellContent(country: model)
        }.disposed (by: disposebag)
        
        tblCountries.rx.modelSelected(CountryData.self).subscribe { [weak self] country in
            guard let self else {
                return
            }
            
            let vc = CountryFlagVC(country: country)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposebag)
        
        
        vm?.countryList.subscribe(onNext: { [weak self] countries in
            guard let self else { 
                return
            }
            
            
            self.countryList = countries
            self.endRefreshing(scrollView: self.tblCountries)
            noCountriesIndicationLbl.text = "No Countries Found for '\(searchTextField.text ?? "")'"
            self.noCountriesIndicationLbl.isHidden = !countries.isEmpty
            loader.stopAnimating()
        }).disposed(by: disposebag)
        
        Task {
            await vm?.fetchCountries()
        }
    }
}

extension CountriesListVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if finishedScroll {
            searchTextField.resignFirstResponder()
            finishedScroll = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        finishedScroll = true
    }
}

extension CountriesListVC: CountriesListVMDelegete {
    func countriesFetched(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Something went wrong, please try again", message: "\(error)")
                self.endRefreshing(scrollView: self.tblCountries)
                loader.stopAnimating()
            }
        }
    }
}

extension CountriesListVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            vm?.textFieldChanged(countries: countryList, text: text)
        }
    }
}
