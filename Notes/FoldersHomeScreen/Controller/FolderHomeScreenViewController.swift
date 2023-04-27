//
//  FolderHomeScreenViewController.swift
//  Notes
//
//  Created by Jayasurya on 13/04/23.
//

import UIKit
import SnapKit


class FolderHomeScreenViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    var folderHomeScreenVM = FolderHomeScreenViewModel()

    let smartFolder = FolderType.smartFolder
    let newFolder = FolderType.defaultFolder

    weak var saveAction: UIAlertAction?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.folderHomeScreenVM.getFolderNames()
        view.backgroundColor = view.isLightTheme ? UIColor.secondarySystemBackground : UIColor.systemBackground
        setupNavBar()
        setUpToolBar()
        setUpTable()
        setSearchBArController()
    }

    private func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .heavy),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        
        self.title = "Folders"
        

        navigationController?.navigationBar.topItem?.rightBarButtonItem = editButtonItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.systemYellow
        ], for: .normal)
    }
    
    private func setUpTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.backgroundColor = .clear

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SectionHeaderHomeScreenView.self, forHeaderFooterViewReuseIdentifier: String(describing: SectionHeaderHomeScreenView.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private func setSearchBArController(){
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = UIColor.systemYellow

        self.navigationItem.searchController = searchController
    }
    

    

    

    
    private func setUpToolBar(){
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.tintColor = UIColor.systemYellow
        self.navigationController?.toolbar.barTintColor = view.isLightTheme ? UIColor.secondarySystemBackground : UIColor.systemBackground
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let createFolder = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), menu: menuForCreateFolders())
        let createNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(btnActionCreateNote(_:)))
        self.setToolbarItems([createFolder, flexibleSpace, createNote], animated: true)
    }
    
    
    
    @objc
    private func btnActionCreateNote(_ barBtn: UIBarButtonItem){
        
    }

    
    @objc
    private func tapFirst(){
    
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(editing){
            navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.systemYellow
            ], for: .normal)
        }
        else{
            navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.systemYellow
            ], for: .normal)
        }
    }

    

}

extension FolderHomeScreenViewController: UITableViewDragDelegate{
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        
        dragItem.localObject = self.folderHomeScreenVM.folderNames[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = self.folderHomeScreenVM.folderNames.remove(at: sourceIndexPath.row)
        self.folderHomeScreenVM.folderNames.insert(mover, at: destinationIndexPath.row)
    }
    
}

extension FolderHomeScreenViewController: UITableViewDelegate
{

}

extension FolderHomeScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return self.folderHomeScreenVM.folderNames.count
        }
        else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitleView = SectionHeaderHomeScreenView(reuseIdentifier: String(describing: SectionHeaderHomeScreenView.self))
        headerTitleView.tag = section
        headerTitleView.delegate = self
        
        if(section == 0){
            headerTitleView.titleLbl.text = "iCloud"
            if(self.folderHomeScreenVM.folderNames.count > 0){
                headerTitleView.expandCollapseIndicatorImg.tag = 0
                headerTitleView.expandCollapseIndicatorImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }
            else{
                headerTitleView.expandCollapseIndicatorImg.tag = 1
                headerTitleView.expandCollapseIndicatorImg.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }

        }
        else if(self.folderHomeScreenVM.backUpTags.count > 0){
            headerTitleView.titleLbl.text = "Tags"

            if(self.folderHomeScreenVM.tags.count > 0){
                headerTitleView.expandCollapseIndicatorImg.tag = 0
                headerTitleView.expandCollapseIndicatorImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }
            else{
                headerTitleView.expandCollapseIndicatorImg.tag = 1
                headerTitleView.expandCollapseIndicatorImg.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }
        }
        else{
            return nil
        }
        
        return headerTitleView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = cell.isLightTheme ? UIColor.systemBackground : UIColor.secondarySystemBackground
            cell.selectionStyle = .none
            let folder = self.folderHomeScreenVM.folderNames[indexPath.row]
            
            
            var content = cell.defaultContentConfiguration()
            content.text = folder.folderName
            
            if(folder.typeEnum == .smartFolder){
                content.image = UIImage(systemName: "gearshape")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal)
            }
            else{
                content.image = UIImage(systemName: "folder")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal)
            }
            cell.contentConfiguration = content

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = cell.isLightTheme ? UIColor.systemBackground : UIColor.secondarySystemBackground
            cell.selectionStyle = .none
            
            var content = cell.defaultContentConfiguration()
            content.text = "Hi"
            content.image = UIImage(systemName: "folder")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal)
            cell.contentConfiguration = content
            
            return cell
        }
    }
}

extension FolderHomeScreenViewController: TableViewSectionHeaderDelegate
{
    func tableViewSectionHeader(_ sectionHeader: TableHeaderView, didSelectSectionAt section: Int){
        if let header = sectionHeader as? SectionHeaderHomeScreenView{
            
            if(section == 0){
                let idxPaths = (0..<self.folderHomeScreenVM.folderNames.count).map{
                    IndexPath(row: $0, section: section)
                }
                
                if(header.expandCollapseIndicatorImg.tag == 1){
                    self.folderHomeScreenVM.folderNames = self.folderHomeScreenVM.backUpFolderNames
                    
                    self.tableView.insertRows(at: idxPaths, with: .fade)
                }
                else{
                    self.folderHomeScreenVM.folderNames = []
                    self.tableView.deleteRows(at: idxPaths, with: .fade)
                }
            }
            else{
                
            }
        }
    }
    
    
}

//Folder creations
extension FolderHomeScreenViewController{
    
    func menuForCreateFolders() -> UIMenu{
        let action: (_ action: UIAction) -> () = {[weak self] action in
            guard let self = self else {return}
            if(action.identifier.rawValue == FolderType.smartFolder.rawValue){
                print("Smart Folder")
            }
            else{
                creatingNewFolder()
            }
        }
        
        let newSmartFolderCreateAction = UIAction(title: "New Smart Folder", image: UIImage(systemName: "gearshape"), identifier: UIAction.Identifier(FolderType.smartFolder.rawValue), handler: action)
        let newFolderCreateAction = UIAction(title: "New Folder", image: UIImage(systemName: "folder"), identifier: UIAction.Identifier(FolderType.defaultFolder.rawValue), handler: action)
        return UIMenu(children:[newFolderCreateAction,newSmartFolderCreateAction])
    }
    
    func creatingNewFolder(){
        let newFolderInputFieldVC = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {_ in
            print("canceled")
        })
        cancelAction.setValue(UIColor.systemYellow, forKey: "titleTextColor")
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let name = newFolderInputFieldVC.textFields?.first?.text{
                self.folderHomeScreenVM.createFolderNames(name: name, type: .defaultFolder)
                self.tableView.reloadData()
            }
        }
        saveAction.isEnabled = false
        saveAction.setValue(UIColor.systemYellow, forKey: "titleTextColor")
        self.saveAction = saveAction
        
        newFolderInputFieldVC.addAction(cancelAction)
        newFolderInputFieldVC.addAction(saveAction)
        newFolderInputFieldVC.addTextField{textField in
            textField.placeholder = "Name"
            textField.delegate = self
        }
        
        self.present(newFolderInputFieldVC, animated: true)
    }
    
}



extension FolderHomeScreenViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text!
        if(text.count > 0){
            self.saveAction?.isEnabled = true
        }
        else{
            self.saveAction?.isEnabled = false
        }
    }
}

extension UIView{
    
    var isLightTheme: Bool {
        get{
            if (self.traitCollection.userInterfaceStyle == .dark){
                return false
            }
            else{
                return true
            }
        }
    }
}

