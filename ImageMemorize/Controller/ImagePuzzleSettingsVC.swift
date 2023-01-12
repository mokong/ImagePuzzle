//
//  ImagePuzzleSettingsVC.swift
//  ImageMemorize
//
//  Created by MorganWang on 10/01/2023.
//

import UIKit

class ImagePuzzleSettingsVC: ImagePuzzlePuzzleBaseVC {
    
    // MARK: - properties
    fileprivate lazy var headerView: ImagePuzzleSettingsHeaderView = ImagePuzzleSettingsHeaderView(frame: .zero)
    fileprivate lazy var tableView: UITableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
    fileprivate var dataList: [ImagePuzzleSettingsRowItem] = []
    
    // MARK: - view life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tempBtn = UIButton(type: UIButton.ButtonType.custom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tempLabel = UILabel()
        tempLabel.font = UIFont.custom.courierFont
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        self.title = "设置"
        setupSubviews()
        setupData()
    }
    
    // MARK: - init
    fileprivate func setupSubviews() {
        view.backgroundColor = UIColor.custom.fifth

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.custom.fifth
        tableView.register(ImagePuzzleSettingsCell.self, forCellReuseIdentifier: ImagePuzzleSettingsCell.reuseIdentifer())
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.custom.primary
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: kScreenWidth, height: 176.0)
        tableView.tableHeaderView = headerView

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupData() {
        dataList = ImagePuzzleSettingsRowItem.settingsList()
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    fileprivate func handleSwitch(_ isEnabledSwitch: Bool, item: ImagePuzzleSettingsRowItem) {
        // save value to lcoal, refresh after back to home page
        ImagePuzzleConst.saveEnableTint(isEnabledSwitch)
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
        let webVC = ImagePuzzlePuzzleBaseWebVC()
        webVC.title = "隐私政策"
        webVC.urlStr = "https://www.yuque.com/morgan-wang/ygyt1g/cchwo7c1505k82u1"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK: - other
    

    
}

extension ImagePuzzleSettingsVC: UITableViewDelegate, UITableViewDataSource {
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
        var cell = tableView.dequeueReusableCell(withIdentifier: ImagePuzzleSettingsCell.reuseIdentifer(), for: indexPath) as? ImagePuzzleSettingsCell
        if cell == nil {
            cell = ImagePuzzleSettingsCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: ImagePuzzleSettingsCell.reuseIdentifer())
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
