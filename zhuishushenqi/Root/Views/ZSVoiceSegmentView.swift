//
//  ZSVoiceSegmentView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit
import SnapKit

enum SegmentType {
    case bottom
    case bigselect
}

protocol ZSVoiceSegmentProtocol {
    func titlesForSegment(segmentView:ZSVoiceSegmentView) ->[String]
    func didSelect(segment:ZSVoiceSegmentView, at index:Int)
}

class ZSVoiceSegmentView: UIView {
    
    var collectionView:UICollectionView!
    
    var delegate:ZSVoiceSegmentProtocol?
    
    var selectedIndex = 0
    
    var type:SegmentType = .bottom { didSet { change(type: type) } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 30)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.qs_registerCellClass(ZSVoiceSegmentCell.self)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = self.bounds
    }
    
    private func change(type:SegmentType) {
        self.collectionView.reloadData()
    }
}

extension ZSVoiceSegmentView:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rows = self.delegate?.titlesForSegment(segmentView: self) {
            return rows.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.qs_dequeueReusableCell(ZSVoiceSegmentCell.self, for: indexPath)
        cell.backgroundColor = type == .bigselect ? UIColor.clear:UIColor.white
        
        cell.selectedView.isHidden = (indexPath.item != selectedIndex) || (type == .bigselect)
        
        if let rows = self.delegate?.titlesForSegment(segmentView: self) {
            cell.titleLabel.text = rows[indexPath.row]
        }
        cell.titleLabel.font = (type == .bigselect && indexPath.item == selectedIndex) ? UIFont.systemFont(ofSize: 20):UIFont.systemFont(ofSize: 15)
        cell.titleLabel.textColor = type == .bigselect ? UIColor.white:UIColor.gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type == .bigselect {
            return CGSize(width: 48, height: 30)
        }
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if type == .bigselect {
            return 0.01
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        if type == .bottom {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        collectionView.reloadData()
    }
}

class ZSVoiceSegmentCell: UICollectionViewCell {
    
    var selectedView:UIView!
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        selectedView.frame = CGRect(x: 0, y: self.bounds.height - 2, width: self.bounds.width, height: 2)
    }
    
    private func setupSubviews() {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(titleLabel)
        
        selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        contentView.addSubview(selectedView)
    }
}
