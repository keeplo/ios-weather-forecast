//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainWeatherTableViewController: UITableViewController {
    private let weatherDataViewModel: WeatherDataViewModel
    private let headerView: MainTableViewHeaderView = MainTableViewHeaderView()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "MM/dd(EEE) HH시"
        return formatter
    }()
        
    init(weatherDataViewModel: WeatherDataViewModel) {
        self.weatherDataViewModel = weatherDataViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(image: UIImage(named: "BackGroundImage"))
        backgroundImageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = backgroundImageView
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.className)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = headerView.calculateHeaderHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherDataViewModel.setUpWeatherData {
            DispatchQueue.main.async {
                self.reloadHeaderView()
                self.tableView.reloadData()
            }
        }
    }
}

extension MainWeatherTableViewController {
    private func reloadHeaderView() {
        let range = (min: weatherDataViewModel.currentMinimumTemperature,
                     max: weatherDataViewModel.currentMaximumTemperature)
        headerView.configureTexts(weatherDataViewModel.currentAddress,
                                  temperatureRange: "최소 \(range.min)º 최대 \(range.max)º",
                                  temperature: "\(weatherDataViewModel.currentTemperature)º")
    }
}

// MARK: - TableView DataSource
extension MainWeatherTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataViewModel.intervalWeatherInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className,
                                                       for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let intervalData = weatherDataViewModel.intervalWeatherInfos[indexPath.row]
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: intervalData.date))
//        cell.separatorInset = UIEdgeInsets.zero
        cell.configureTexts(date,
                       temperature: "\(intervalData.mainInformation.temperature)º")
        
        return cell
    }
}
