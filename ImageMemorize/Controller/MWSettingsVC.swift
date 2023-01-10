//
//  MWSettingsVC.swift
//  ImageMemorize
//
//  Created by Horizon on 10/01/2023.
//

import UIKit

class MWSettingsVC: MWPuzzleBaseVC {
    
    // MARK: - properties
    fileprivate lazy var headerView: MWSettingsHeaderView = MWSettingsHeaderView(frame: .zero)
    fileprivate lazy var tableView: UITableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
    fileprivate var dataList: [MWSettingsRowItem] = []
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置"
        setupSubviews()
        setupLayouts()
        setupData()
    }
    
    // MARK: - init
    fileprivate func setupSubviews() {
        view.backgroundColor = UIColor.custom.fifth
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.custom.fifth
        tableView.register(MWSettingsCell.self, forCellReuseIdentifier: MWSettingsCell.reuseIdentifer())
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.custom.primary
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: kScreenWidth, height: 176.0)
        tableView.tableHeaderView = headerView
    }
    
    fileprivate func setupLayouts() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupData() {
        dataList = MWSettingsRowItem.settingsList()
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    fileprivate func handleSwitch(_ isEnabledSwitch: Bool, item: MWSettingsRowItem) {
        // save value to lcoal, refresh after back to home page
        MWPuzzleConst.saveEnableTint(isEnabledSwitch)
        NotificationCenter.default.post(name: NSNotification.Name(kRefreshMainVCNote), object: nil)
    }
    
    fileprivate func handleCustomImageAction() {
        
    }
    
    fileprivate func handleRecommendApps() {
        // 分享 APP
        view.makeToastActivity(self.view.center)
        
        let url = URL(string: kAppStoreUrl)
        let array: [Any] = ["拼图", url as Any]
        let activityVC = UIActivityViewController(activityItems: array, applicationActivities: nil)
        
        view.hideToastActivity()
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { (type, completed, items, error) in
            if completed {
                print("分享成功")
            }
            else {
                print("分享失败")
            }
        }
    }
    
    fileprivate func handleMoveToPrivacyPage() {
        let webVC = MWPuzzleBaseWebVC()
        webVC.title = "隐私政策"
        webVC.urlStr = "https://www.yuque.com/morgan-wang/ygyt1g/cchwo7c1505k82u1"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK: - other
    

    
}

extension MWSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MWSettingsCell.reuseIdentifer(), for: indexPath) as? MWSettingsCell
        if cell == nil {
            cell = MWSettingsCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: MWSettingsCell.reuseIdentifer())
        }
        if indexPath.row < dataList.count {
            let item = dataList[indexPath.row]
            cell?.update(item.type.rawValue)
            cell?.showSwitch = item.showSwitch
            if item.showSwitch {
                cell?.rightSwitch.isOn = item.isSwitchOn
            }
            cell?.switchValueChangedCallback = { [weak self] switchView in
                self?.handleSwitch(switchView.isOn, item: item)
            }
        }
        if let cell = cell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < dataList.count else {
            return
        }
        let item = dataList[indexPath.row]
        switch item.type {
        case .customImage:
            handleCustomImageAction()
        case .recommendApps:
            handleRecommendApps()
        case .privacy:
            handleMoveToPrivacyPage()
        default:
            break
        }
    }
    
}
