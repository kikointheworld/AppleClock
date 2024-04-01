//
//  WorldClockViewController.swift
//  AppleClock
//
//  Created by 김선재 on 02.04.24.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var worldClockTableView: UITableView!
    
    var list = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier:"Europe/Paris")!,
        TimeZone(identifier:"Europe/Paris")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
    }
    


}

extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorldClockTableTableViewCell.self), for: indexPath) as! WorldClockTableTableViewCell
        
        return cell
    }
}
