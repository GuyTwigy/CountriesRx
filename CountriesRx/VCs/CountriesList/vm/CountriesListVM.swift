//
//  CountriesListVM.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
         
protocol CountriesListVMDelegete: AnyObject {
    
}

class CountriesListVM {
    
    weak var delegate: CountriesListVMDelegete?
}
