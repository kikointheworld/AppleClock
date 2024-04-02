//
//  CitySelectionViewController.swift
//  AppleClock
//
//  Created by 김선재 on 02.04.24.
//

import UIKit

struct Item {
    let title: String
    let timeZone: TimeZone
}

struct Section {
    let title: String
    let items: [Item]
    
}

class CitySelectionViewController: UIViewController {

    
    @IBOutlet weak var CityTableView: UITableView!
    
    var list = [Section]()
    
    func setupList() {
        var dict = [String: [TimeZone]]()
        
        for id in TimeZone.knownTimeZoneIdentifiers {
            guard let city = id.components(separatedBy: "/").last else {continue}
            
            var timeZoneList = [TimeZone(identifier: id)!]
            let key = city.chosung ?? "Unknown"
            
            if let list = dict[key] {
                timeZoneList.append(contentsOf: list)
            }
            
            dict[key] = timeZoneList
        }
        for (key, value) in dict {
            let items = value.sorted {
                guard let lhs = $0.city, let rhs = $1.city else {return false}
                return lhs < rhs
            }.map {
                Item(title: $0.city ?? $0.identifier, timeZone: $0)
            }
            
            let section = Section(title: key, items: items)
            list.append(section)
        }
        
        list.sort {$0.title < $1.title}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
        CityTableView.reloadData()

    }
    

}


extension CitySelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let target = list[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = target.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section].title
    }
    
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // 초성 목록
        let initialConsonants = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]

        // 알파벳 목록 (대문자만)
        let alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

        // 초성과 알파벳을 합친 배열
        let combinedArray = initialConsonants + alphabets

        return combinedArray
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return list.firstIndex(where: {$0.title.uppercased() == title.uppercased()}) ?? 0
    }
}
