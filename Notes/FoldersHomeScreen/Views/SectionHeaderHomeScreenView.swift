//
//  SectionHeaderHomeScreenView.swift
//  Notes
//
//  Created by Jayasurya on 15/04/23.
//

import UIKit

protocol TableViewSectionHeaderDelegate: AnyObject{
    func tableViewSectionHeader(_ sectionHeader: TableHeaderView, didSelectSectionAt section: Int)
}

class SectionHeaderHomeScreenView: TableHeaderView {

    
    weak var titleLbl: UILabel!
    weak var expandCollapseIndicatorImg: UIImageView!
    weak var delegate: TableViewSectionHeaderDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView?.backgroundColor = .clear
        initializeUI()
        setConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func initializeUI(){
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        lbl.textColor = UIColor.label
        lbl.backgroundColor = .clear
        self.titleLbl = lbl
        self.addSubview(titleLbl)
        
        
        let imgV = UIImageView()
        imgV.image = UIImage(systemName: "chevron.right.circle.fill")
        imgV.tintColor = UIColor.systemYellow
        imgV.backgroundColor = .clear
        imgV.tag = 1
        self.expandCollapseIndicatorImg = imgV
        self.addSubview(imgV)

    }
    
    private func setConstraints(){
        self.titleLbl.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(34)
            make.top.equalTo(self).offset(15)
            make.height.equalTo(30)
            make.bottom.equalTo(self).offset(-10)
        }
        
        self.expandCollapseIndicatorImg.snp.makeConstraints { make in
            make.centerY.equalTo(titleLbl)
            make.right.equalTo(self).inset(25)
            make.height.width.equalTo(22)
        }
    }

    @objc
    private func viewTapped(_ sender: UIGestureRecognizer){
        delegate?.tableViewSectionHeader(self, didSelectSectionAt: self.tag)
        
        if(self.expandCollapseIndicatorImg.tag == 1){
            
            UIView.animate(withDuration: 0.30, delay: 0.02, options: [.curveEaseOut]) {
                self.expandCollapseIndicatorImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }
            self.expandCollapseIndicatorImg.tag = 0
        }
        else{

            UIView.animate(withDuration: 0.30, delay: 0.02, options: [.curveEaseOut]) {
                self.expandCollapseIndicatorImg.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }
            self.expandCollapseIndicatorImg.tag = 1
        }
    }
}
