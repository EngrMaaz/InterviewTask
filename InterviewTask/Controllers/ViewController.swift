//
//  ViewController.swift
//  InterviewTask
//
//  Created by HAPPY on 12/11/2020.
//

import UIKit
import CoreData

class ViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [DataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.configureTableView()
        if let locationsArray =         CoreDataManager.sharedManager.fetchAllValues(entity: "Location"), locationsArray.count > 0 {
            self.configureDataSource(locations: locationsArray)
        } else {
            self.getStatesAndCities()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        DispatchQueue.main.async {
            
            self.tableView.separatorStyle = .none
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 192
            
            self.tableView.register(UINib(nibName: StateCityTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: StateCityTableViewCell.identifier())
            
            self.tableView.reloadData()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StateCityTableViewCell.identifier(), for: indexPath) as! StateCityTableViewCell
        
        let data = dataSource[indexPath.row]
        
        cell.stateLabel.text = data.state
        cell.cityLabel.text = data.city
        
        return cell
    }
}



extension ViewController {
    
    private func getStatesAndCities() {
        
        self.showProgressHUD()
        NetworkManager.getStatesAndCities{ (response) in
            
            DispatchQueue.main.async {
                self.hideProgressHUD()
            }
            guard let response = response else { return }
            
            if let dataSource = DataModel.toModels(response), dataSource.count > 0 {
                self.saveDataInCoreData(locations: dataSource)
                
            } else {
                self.showAlert(message: "Someting went wrong")
            }
            
        }
    }
}

extension ViewController {
    private func saveDataInCoreData(locations: [DataModel]) {
        CoreDataManager.sharedManager.saveStatesAndCities(entityName: "Location", locations: locations) { (result) in
            switch result {
            case .success:
                
                guard let locationsArray =         CoreDataManager.sharedManager.fetchAllValues(entity: "Location") else {
                    self.showAlert(message: "Something went wrong while fetching result")
                    return
                }
                self.configureDataSource(locations: locationsArray)
            case .failure:
                print("Couldn't save data")
                DispatchQueue.main.async {
                    self.showAlert(message: "Data not saved")
                }
            }
        }
    }
    private func configureDataSource(locations: [NSManagedObject]) {
        for location in locations {
            self.dataSource.append(DataBaseHelper.shared.toLocation(contractData: location))
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
