//
//  CountriesListVMTests.swift
//  CountriesRxTests
//
//  Created by Guy Twig on 11/08/2024.
//

import XCTest
@testable import CountriesRx
import RxSwift
import RxCocoa

@MainActor
class CountriesListVMTests: XCTestCase {
    
    var vm: CountriesListVM?
    
    override func setUpWithError() throws {
        vm = CountriesListVM()
    }
    
    override func tearDownWithError() throws {
        vm = nil
        vm?.countryModifiedList.removeAll()
        vm?.savedList.removeAll()
        vm?.notFilteredCountryList.removeAll()
    }
    
    func test_CountriesListVMTests_handleResultOfCountries_inSavedCountryButNotInList() {
        //Given
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.savedList = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                        Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString())
        ]
        
        //When
        vm?.handleResultOfCountries(countriesResult: countriesArray)
        
        //Then
        XCTAssertEqual(vm?.countryModifiedList.count ?? 0, 4)
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Pirat" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Argentina" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Brazil" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Israel" })) != nil))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common == "Italy" }) ?? false))))
    }
    
    func test_CountriesListVMTests_handleResultOfCountries_savedListEmpty() {
        //Given
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.savedList = []
        
        //When
        vm?.handleResultOfCountries(countriesResult: countriesArray)
        
        //Then
        XCTAssertEqual(vm?.countryModifiedList.count ?? 0, 4)
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Pirat" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Argentina" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Brazil" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Israel" })) != nil))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common == "Italy" }) ?? false))))
    }
    
    func test_CountriesListVMTests_handleResultOfCountries_sameOnSavedAndCountryArray() {
        //Given
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.savedList = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString())
        ]
        
        //When
        vm?.handleResultOfCountries(countriesResult: countriesArray)
        
        //Then
        XCTAssertEqual(vm?.countryModifiedList.count ?? 0, 4)
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Pirat" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Argentina" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Brazil" })) != nil))
        XCTAssertTrue(((vm?.countryModifiedList.contains( where: { $0.name?.common == "Israel" })) != nil))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common == "Italy" }) ?? false))))
    }
    
    func test_CountriesListVMTests_handleResultOfCountries_emptyCountryArrWithSaved() {
        //Given
        let countriesArray: [CountryData] = []
        vm?.savedList = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString())
        ]
        
        //When
        vm?.handleResultOfCountries(countriesResult: countriesArray)
        
        //Then
        XCTAssertEqual(vm?.countryModifiedList.count ?? 0, 0)
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common ==  "Pirat" }) ?? false))))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common ==  "Argentina" }) ?? false))))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common ==  "Brazil" }) ?? false))))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common ==  "Israel" }) ?? false))))
        XCTAssertTrue(((!(vm?.countryModifiedList.contains( where: { $0.name?.common == "Italy" }) ?? false))))
    }
    
    func test_CountriesListVMTests_singleFetchCountriesSuccess() async throws {
        // Given
        vm?.countryModifiedList.removeAll()
        vm?.savedList.removeAll()
        
        let expectation = expectation(description: "Fetch countries and update list")
        
        // When
        vm?.dataService.fetchCountries()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] countries in
                guard let self else {
                    XCTFail("Failed when trying to subscribe")
                    return
                }
                
                self.vm?.handleResultOfCountries(countriesResult: countries)
                
                // Then
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Fetching countries failed with error: \(error)")
            })
            .disposed(by: vm?.disposeBag ?? DisposeBag())
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
        XCTAssertFalse(vm?.countryModifiedList.isEmpty ?? true)
        XCTAssertGreaterThan(vm?.countryModifiedList.count ?? 0, 0)
        XCTAssertNotEqual(vm?.countryModifiedList.count ?? 0, 0)
        print("vm?.countryModifiedList.count: \(vm?.countryModifiedList.count ?? 0)")
    }
    
    func test_CountriesListVMTests_fourCallsfetchCountriesSuccess() async throws {
        // Given
        vm?.countryModifiedList.removeAll()
        vm?.savedList.removeAll()
        
        let expectation = expectation(description: "Fetch countries four times and update list")
        
        // When
        if let fetch1 = vm?.dataService.fetchCountries().asObservable(),
           let fetch2 = vm?.dataService.fetchCountries().asObservable(),
           let fetch3 = vm?.dataService.fetchCountries().asObservable(),
           let fetch4 = vm?.dataService.fetchCountries().asObservable() {
            
            Observable.zip(fetch1, fetch2, fetch3, fetch4)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] result1, result2, result3, result4 in
                    guard let self else {
                        return
                    }
                    
                    print("result1: num of countries \(result1.count)")
                    print("result2: num of countries \(result2.count)")
                    print("result3: num of countries \(result3.count)")
                    print("result4: num of countries \(result4.count)")
                    
                    self.vm?.handleResultOfCountries(countriesResult: result1)
                    
                    // Then
                    expectation.fulfill()
                    
                    XCTAssertFalse(result1.isEmpty)
                    XCTAssertGreaterThan(result1.count, 0)
                    XCTAssertNotEqual(result1.count, 0)
                    print("result1: \(result1.count)")
                    
                    XCTAssertFalse(result2.isEmpty)
                    XCTAssertGreaterThan(result2.count, 0)
                    XCTAssertNotEqual(result2.count, 0)
                    print("result2: \(result2.count)")
                    
                    XCTAssertFalse(result3.isEmpty)
                    XCTAssertGreaterThan(result3.count, 0)
                    XCTAssertNotEqual(result3.count, 0)
                    print("result3: \(result3.count)")
                    
                    XCTAssertFalse(result4.isEmpty)
                    XCTAssertGreaterThan(result4.count, 0)
                    XCTAssertNotEqual(result4.count, 0)
                    print("result4: \(result4.count)")
                }, onError: { error in
                    XCTFail("Fetching countries failed with error: \(error)")
                })
                .disposed(by: vm?.disposeBag ?? DisposeBag())
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
        XCTAssertFalse(vm?.countryModifiedList.isEmpty ?? true)
        XCTAssertGreaterThan(vm?.countryModifiedList.count ?? 0, 0)
        XCTAssertNotEqual(vm?.countryModifiedList.count ?? 0, 0)
        print("vm?.countryModifiedList.count: \(vm?.countryModifiedList.count ?? 0)")
    }
    
    func test_CountriesListVMTests_textFieldChanged_text_i() async throws {
        //Givev
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇩🇪", name: NameDetails(common: "Germany"), identifierInt: "105", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇳", name: NameDetails(common: "India"), identifierInt: "106", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.notFilteredCountryList = countriesArray
        
        //When
        vm?.textFieldChanged(countries: countriesArray, text: "i")
        
        //Then
        let expectedResult = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇳", name: NameDetails(common: "India"), identifierInt: "106", objectIdString: Utils.generate24HexDigitString())
        ]
        
        XCTAssertEqual(vm?.countryModifiedList.count, expectedResult.count)
        XCTAssertEqual(vm?.countryModifiedList.first, expectedResult.first)
        XCTAssertEqual(vm?.countryModifiedList.last, expectedResult.last)
    }
    
    func test_CountriesListVMTests_textFieldChanged_text_ra() async throws {
        //Givev
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇩🇪", name: NameDetails(common: "Germany"), identifierInt: "105", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇳", name: NameDetails(common: "India"), identifierInt: "106", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.notFilteredCountryList = countriesArray
        
        //When
        vm?.textFieldChanged(countries: countriesArray, text: "ra")
        
        //Then
        let expectedResult = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
        ]
        
        XCTAssertEqual(vm?.countryModifiedList.count, expectedResult.count)
        XCTAssertEqual(vm?.countryModifiedList.first, expectedResult.first)
        XCTAssertEqual(vm?.countryModifiedList.last, expectedResult.last)
    }
    
    func test_CountriesListVM_textFieldChanged_emptyText() {
        // Given
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇩🇪", name: NameDetails(common: "Germany"), identifierInt: "105", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇳", name: NameDetails(common: "India"), identifierInt: "106", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.notFilteredCountryList = countriesArray
        
        // When
        vm?.textFieldChanged(countries: countriesArray, text: "")
        
        // Then
        XCTAssertEqual(vm?.countryModifiedList.count, countriesArray.count)
        XCTAssertEqual(vm?.countryModifiedList.first, countriesArray.first)
        XCTAssertEqual(vm?.countryModifiedList.last, countriesArray.last)
    }
    
    func test_CountriesListVM_filterCountries() {
        // Given
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇩🇪", name: NameDetails(common: "Germany"), identifierInt: "105", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇳", name: NameDetails(common: "India"), identifierInt: "106", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.notFilteredCountryList = countriesArray
        
        // When
        let filteredCountries = vm?.filterCountries(searchText: "is")
        
        // Then
        XCTAssertEqual(filteredCountries?.count, 1)
        XCTAssertEqual(filteredCountries?.first?.name?.common, "Israel")
    }
    
    func test_CountriesListVM_resetCountriesList() {
        // Given
        let countriesArray = [
            CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString:                          Utils.generate24HexDigitString()),
            CountryData(flag: "🏴‍☠️", name: NameDetails(common: "Pirat"), identifierInt: "101", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇧🇷", name: NameDetails(common: "Brazil"), identifierInt: "102", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇦🇷", name: NameDetails(common: "Argentina"), identifierInt: "103", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇹", name: NameDetails(common: "Italy"), identifierInt: "104", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇩🇪", name: NameDetails(common: "Germany"), identifierInt: "105", objectIdString: Utils.generate24HexDigitString()),
            CountryData(flag: "🇮🇳", name: NameDetails(common: "India"), identifierInt: "106", objectIdString: Utils.generate24HexDigitString())
        ]
        vm?.notFilteredCountryList = countriesArray
        
        // When
        let resetCountries = vm?.resetCountriesList()
        
        // Then
        XCTAssertEqual(resetCountries?.count, countriesArray.count)
        XCTAssertEqual(resetCountries, countriesArray)
        XCTAssertEqual(resetCountries?.first, countriesArray.first)
        XCTAssertEqual(resetCountries?.last, countriesArray.last)
    }
}
