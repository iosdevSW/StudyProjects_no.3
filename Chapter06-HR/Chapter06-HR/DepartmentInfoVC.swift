//
//  DepartmentInfoVC.swift
//  Chapter06-HR
//
//  Created by 신상우 on 2021/12/08.
//

import UIKit

class DepartmentInfoVC: UITableViewController {
    //부서 정보를 저장할 데이터 타입
    typealias DepartRecord = (departCd: Int, departTitle: String, departAddr: String)
    
    var departCd: Int! //부서 목록으로부터 넘겨 받을 부서 코드
    
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()
    
    var departInfo: DepartRecord!
    var empList: [EmployeeVO]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departInfo = self.departDAO.get(departCd: self.departCd)
        self.empList = self.empDAO.find(departCd: self.departCd)
        
        self.navigationItem.title = "\(self.departInfo.departTitle)"
    }
    
    @objc func changeState(_ sender: UISegmentedControl) {
        let empCd = sender.tag
        let stateCd = EmpStateType(rawValue: sender.selectedSegmentIndex)
        
        if self.empDAO.editState(empCd: empCd, stateCd: stateCd!) {
            let alert = UIAlertController(title: nil, message: "재직 상태가 변경되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            
            self.present(alert, animated: false)
        }
    }
    
    //MARK:- delegteMethod
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //섹션 뷰 설정
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = .systemFont(ofSize: 15, weight: UIFont.Weight(2.5))
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 0.71, alpha: 1.0)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        if section == 0 {
            textHeader.text = "부서 정보"
            icon.image = UIImage( imageLiteralResourceName: "depart")
        } else {
            textHeader.text = "사원 정보"
            icon.image = UIImage( imageLiteralResourceName: "employee")
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        view.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.0)
        
        view.addSubview(textHeader)
        view.addSubview(icon)
        
        return view
    }
    
    //섹션의 높이 설정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //섹션마다 row 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3 //section0은 부서 정보로 부서 코드, 부서 이름, 주소 세가지
        } else {
            return empList.count //section1은 사원 목록으로 사원 수 만큼
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
            
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "부서 코드"
                cell?.detailTextLabel?.text = "\(self.departInfo.departCd)"
            case 1:
                cell?.textLabel?.text = "부서명"
                cell?.detailTextLabel?.text = self.departInfo.departTitle
            case 2:
                cell?.textLabel?.text = "부서 주소"
                cell?.detailTextLabel?.text = self.departInfo.departAddr
            default :
                () //작성할 구문이 없을때 넣어주는 더미 코드
            }
            return cell!
        } else {
            let row = self.empList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
            cell?.textLabel?.text = "\(row.empName) (입사일: \(row.joinDate) )"
            cell?.textLabel?.font = .systemFont(ofSize: 12)
            
            let state = UISegmentedControl(items: ["재직중","휴직","퇴사"])
            state.frame.origin.x = self.view.frame.width - state.frame.width - 10
            state.frame.origin.y = 10
            state.selectedSegmentIndex = row.stateCd.rawValue
            
            state.tag = row.empCd
            state.addTarget(self, action: #selector(self.changeState(_:)), for: .valueChanged)
            
            cell?.contentView.addSubview(state)
            
            return cell!
        }
    }
}
