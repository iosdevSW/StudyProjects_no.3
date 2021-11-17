//
//  SideBarViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 신상우 on 2021/11/17.
//

import UIKit

class SideBarViewController: UITableViewController {
    //MARK: Properties
    let titles = [
        "메뉴 01",
        "메뉴 02",
        "메뉴 03",
        "메뉴 04",
        "메뉴 05"
    ]
    
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accountLabel = UILabel() //계정 정보를 표시할 레이블 객체
        accountLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)
        
        accountLabel.text = "ssw522b@naver.com"
        accountLabel.textColor = .white
        accountLabel.font = .boldSystemFont(ofSize: 15)
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        v.backgroundColor = .brown
        v.addSubview(accountLabel)
        
        self.tableView.tableHeaderView = v
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //재사용 큐로부터 테이블 셀을 꺼내 온다.
        let id = "menucell" // 재사용 큐 식별자
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id) //재사용 큐에 mencell키로 등록된 테이블 뷰 셀이 없다면 새로 추가한다.
        
        //타이틀과 이미지 대입
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        cell.textLabel?.font = .systemFont(ofSize: 14)
        
        return cell
    }
}
