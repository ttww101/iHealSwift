import UIKit

class ViewControllerTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var vcInstance:ViewController?
    var allDataList:[NewPageObject] = [NewPageObject]()
    var cateDataList:[NewPageObject] = [NewPageObject]()
    var showDataList:[NewPageObject] = [NewPageObject]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (vcInstance != nil) {
            if (self.vcInstance!.isFiltering()) {
                return self.showDataList.count
            } else {
                return self.cateDataList.count
            }
        } else {
            return self.cateDataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewControllerTVC", for: indexPath) as! ViewControllerTableViewCell
        
        
        if (self.vcInstance != nil) {
            
            if (self.vcInstance!.isFiltering()) {
                
                cell.cateTitleNameLabel.text = self.showDataList[indexPath.row].titleName
                cell.cateSubTitleNameLabel.text = self.showDataList[indexPath.row].subTitleName
                
                cell.cateImageView.tag = indexPath.row
                downloadImage(abbs: nil, url: self.showDataList[indexPath.row].imageUrl) { (image) in
                    if (cell.cateImageView.tag == indexPath.row) {
                        cell.cateImageView.image = image
                    }
                }
                
                if (self.showDataList[indexPath.row].isAttention) {
                    cell.cateAttentionBtn.backgroundColor = cell.mainColor
                    cell.cateAttentionBtn.layer.borderColor = cell.subColor.cgColor
                    cell.cateAttentionBtn.setTitleColor(cell.subColor, for: UIControl.State.normal)
                } else {
                    cell.cateAttentionBtn.backgroundColor = cell.subColor
                    cell.cateAttentionBtn.layer.borderColor = cell.mainColor.cgColor
                    cell.cateAttentionBtn.setTitleColor(cell.mainColor, for: UIControl.State.normal)
                }
                
                cell.cateAttentionBtn.tag = indexPath.row
                cell.cateAttentionBtn.addTarget(self, action: #selector(attentionClick(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.cateDetailBtn.tag = indexPath.row
                cell.cateDetailBtn.addTarget(self, action: #selector(detailClick(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.cateSelectBtn.tag = indexPath.row
                cell.cateSelectBtn.addTarget(self, action: #selector(detailClick(sender:)), for: UIControl.Event.touchUpInside)
                
            } else {
                
                cell.cateTitleNameLabel.text = self.cateDataList[indexPath.row].titleName
                cell.cateSubTitleNameLabel.text = self.cateDataList[indexPath.row].subTitleName
                
                cell.cateImageView.tag = indexPath.row
                downloadImage(abbs: nil, url: self.cateDataList[indexPath.row].imageUrl) { (image) in
                    if (cell.cateImageView.tag == indexPath.row) {
                        cell.cateImageView.image = image
                    }
                }
                
                if (self.cateDataList[indexPath.row].isAttention) {
                    cell.cateAttentionBtn.backgroundColor = cell.mainColor
                    cell.cateAttentionBtn.layer.borderColor = cell.subColor.cgColor
                    cell.cateAttentionBtn.setTitleColor(cell.subColor, for: UIControl.State.normal)
                } else {
                    cell.cateAttentionBtn.backgroundColor = cell.subColor
                    cell.cateAttentionBtn.layer.borderColor = cell.mainColor.cgColor
                    cell.cateAttentionBtn.setTitleColor(cell.mainColor, for: UIControl.State.normal)
                }
                
                cell.cateAttentionBtn.tag = indexPath.row
                cell.cateAttentionBtn.addTarget(self, action: #selector(attentionClick(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.cateDetailBtn.tag = indexPath.row
                cell.cateDetailBtn.addTarget(self, action: #selector(detailClick(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.cateSelectBtn.tag = indexPath.row
                cell.cateSelectBtn.addTarget(self, action: #selector(detailClick(sender:)), for: UIControl.Event.touchUpInside)
                
            }
            
        } else {
            
            cell.cateTitleNameLabel.text = self.cateDataList[indexPath.row].titleName
            cell.cateSubTitleNameLabel.text = self.cateDataList[indexPath.row].subTitleName
            
            cell.cateImageView.tag = indexPath.row
            downloadImage(abbs: nil, url: self.cateDataList[indexPath.row].imageUrl) { (image) in
                if (cell.cateImageView.tag == indexPath.row) {
                    cell.cateImageView.image = image
                }
            }
            
            if (self.cateDataList[indexPath.row].isAttention) {
                cell.cateAttentionBtn.backgroundColor = cell.mainColor
                cell.cateAttentionBtn.layer.borderColor = cell.subColor.cgColor
                cell.cateAttentionBtn.setTitleColor(cell.subColor, for: UIControl.State.normal)
            } else {
                cell.cateAttentionBtn.backgroundColor = cell.subColor
                cell.cateAttentionBtn.layer.borderColor = cell.mainColor.cgColor
                cell.cateAttentionBtn.setTitleColor(cell.mainColor, for: UIControl.State.normal)
            }
            
            cell.cateAttentionBtn.tag = indexPath.row
            cell.cateAttentionBtn.addTarget(self, action: #selector(attentionClick(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.cateDetailBtn.tag = indexPath.row
            cell.cateDetailBtn.addTarget(self, action: #selector(detailClick(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.cateSelectBtn.tag = indexPath.row
            cell.cateSelectBtn.addTarget(self, action: #selector(detailClick(sender:)), for: UIControl.Event.touchUpInside)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func detailClick(sender:UIButton) {
        if (self.vcInstance != nil) {
            if (self.vcInstance!.isFiltering()) {
                
                let overWebVC = OverWebViewController()
                UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                    
                    let accObj = DiscussAccordingObject()
                    accObj.accordingTitle = self.showDataList[sender.tag].titleName
                    accObj.accordingSubTitle = self.showDataList[sender.tag].subTitleName
                    accObj.accordingImageUrl = self.showDataList[sender.tag].imageUrl
                    accObj.accordingUrl = self.showDataList[sender.tag].pageUrl
                    
                    overWebVC.loadTitleUrl(abbs: nil, accordingObj: accObj)
                    
                })
                
            } else {
                
                let overWebVC = OverWebViewController()
                UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                    
                    let accObj = DiscussAccordingObject()
                    accObj.accordingTitle = self.cateDataList[sender.tag].titleName
                    accObj.accordingSubTitle = self.cateDataList[sender.tag].subTitleName
                    accObj.accordingImageUrl = self.cateDataList[sender.tag].imageUrl
                    accObj.accordingUrl = self.cateDataList[sender.tag].pageUrl
                    
                    overWebVC.loadTitleUrl(abbs: nil, accordingObj: accObj)
                    
                })
                
            }
        }
    }
    
    @objc func attentionClick(sender:UIButton) {
        
        if (self.vcInstance != nil) {
            if (self.vcInstance!.isFiltering()) {
                if (self.vcInstance!.userInfo.userNickname.count > 0) {
                    if (self.vcInstance!.userInfo.userEmail.count > 0) {
                        if (self.showDataList[sender.tag].isAttention) {
                            startIndicator(abbs: nil, currentVC: self.vcInstance!) { (indicatorView) in
                                
                                getUserAttentionsFrom(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, didGetCallback: { (attentionArray) in
                                    let indexTemp = attentionArray.firstIndex(where: { (attentionObj) -> Bool in
                                        return attentionObj.userEmail == self.vcInstance!.userInfo.userEmail
                                    })
                                    if let index = indexTemp {
                                        let attIndexTemp = attentionArray[index].accordingUrlArray.index(of: self.showDataList[sender.tag].pageUrl)
                                        if let attIndex = attIndexTemp {
                                            attentionArray[index].accordingUrlArray.remove(at: attIndex)
                                            
                                            sendUserAttentionTo(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, attentionObject: attentionArray[index], didSendCallback: {
                                                
                                                
                                            })
                                            
                                        }
                                    }
                                    
                                    self.showDataList[sender.tag].isAttention = false
                                    if let cateIndex = self.cateDataList.firstIndex(where: { (obj) -> Bool in
                                        return obj.menuId == self.showDataList[sender.tag].menuId
                                    }) {
                                        self.cateDataList[cateIndex].isAttention = false
                                    }
                                    if let cateIndex = self.allDataList.firstIndex(where: { (obj) -> Bool in
                                        return obj.menuId == self.showDataList[sender.tag].menuId
                                    }) {
                                        self.allDataList[cateIndex].isAttention = false
                                    }
                                    self.reloadData()
                                    
                                    stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                                        
                                    })
                                    
                                })
                                
                            }
                            
                        } else {
                            startIndicator(abbs: nil, currentVC: self.vcInstance!) { (indicatorView) in
                                
                                getUserAttentionsFrom(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, didGetCallback: { (attentionArray) in
                                    let indexTemp = attentionArray.firstIndex(where: { (attentionObj) -> Bool in
                                        return attentionObj.userEmail == self.vcInstance!.userInfo.userEmail
                                    })
                                    if let index = indexTemp {
                                        attentionArray[index].accordingUrlArray.append(self.showDataList[sender.tag].pageUrl)
                                        
                                        sendUserAttentionTo(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, attentionObject: attentionArray[index], didSendCallback: {
                                            
                                            
                                            
                                            
                                        })
                                        
                                    } else {
                                        
                                        let attentionNew = AttentionObject()
                                        
                                        attentionNew.userNickname = self.vcInstance!.userInfo.userNickname
                                        attentionNew.userEmail = self.vcInstance!.userInfo.userEmail
                                        attentionNew.userImageUrl = self.vcInstance!.userInfo.userImageUrl
                                        attentionNew.accordingUrlArray.append(self.showDataList[sender.tag].pageUrl)
                                        
                                        sendUserAttentionTo(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, attentionObject: attentionNew, didSendCallback: {
                                            
                                        })
                                        
                                    }
                                    
                                    self.showDataList[sender.tag].isAttention = true
                                    if let cateIndex = self.cateDataList.firstIndex(where: { (obj) -> Bool in
                                        return obj.menuId == self.showDataList[sender.tag].menuId
                                    }) {
                                        self.cateDataList[cateIndex].isAttention = true
                                    }
                                    if let cateIndex = self.allDataList.firstIndex(where: { (obj) -> Bool in
                                        return obj.menuId == self.showDataList[sender.tag].menuId
                                    }) {
                                        self.allDataList[cateIndex].isAttention = true
                                    }
                                    self.reloadData()
                                    
                                    stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                                        
                                    })
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                }
                
            } else {
                
                if (self.vcInstance!.userInfo.userNickname.count > 0) {
                    if (self.vcInstance!.userInfo.userEmail.count > 0) {
                        if (self.cateDataList[sender.tag].isAttention) {
                            startIndicator(abbs: nil, currentVC: self.vcInstance!) { (indicatorView) in
                                
                                getUserAttentionsFrom(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, didGetCallback: { (attentionArray) in
                                    let indexTemp = attentionArray.firstIndex(where: { (attentionObj) -> Bool in
                                        return attentionObj.userEmail == self.vcInstance!.userInfo.userEmail
                                    })
                                    if let index = indexTemp {
                                        let attIndexTemp = attentionArray[index].accordingUrlArray.index(of: self.cateDataList[sender.tag].pageUrl)
                                        if let attIndex = attIndexTemp {
                                            attentionArray[index].accordingUrlArray.remove(at: attIndex)
                                            
                                            sendUserAttentionTo(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, attentionObject: attentionArray[index], didSendCallback: {
                                                
                                                
                                                
                                            })
                                            
                                        }
                                        
                                    }
                                    
                                    self.cateDataList[sender.tag].isAttention = false
                                    if let cateIndex = self.allDataList.firstIndex(where: { (obj) -> Bool in
                                        return obj.menuId == self.cateDataList[sender.tag].menuId
                                    }) {
                                        self.allDataList[cateIndex].isAttention = false
                                    }
                                    self.reloadData()
                                    
                                    stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                                        
                                    })
                                    
                                })
                                
                            }
                            
                            
                        } else {
                            startIndicator(abbs: nil, currentVC: self.vcInstance!) { (indicatorView) in
                                getUserAttentionsFrom(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, didGetCallback: { (attentionArray) in
                                    let indexTemp = attentionArray.firstIndex(where: { (attentionObj) -> Bool in
                                        return attentionObj.userEmail == self.vcInstance!.userInfo.userEmail
                                    })
                                    if let index = indexTemp {
                                        attentionArray[index].accordingUrlArray.append(self.cateDataList[sender.tag].pageUrl)
                                        
                                        sendUserAttentionTo(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, attentionObject: attentionArray[index], didSendCallback: {
                                            
                                            
                                            
                                        })
                                        
                                    } else {
                                        
                                        let attentionNew = AttentionObject()
                                        
                                        attentionNew.userNickname = self.vcInstance!.userInfo.userNickname
                                        attentionNew.userEmail = self.vcInstance!.userInfo.userEmail
                                        attentionNew.userImageUrl = self.vcInstance!.userInfo.userImageUrl
                                        attentionNew.accordingUrlArray.append(self.cateDataList[sender.tag].pageUrl)
                                        
                                        sendUserAttentionTo(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, attentionObject: attentionNew, didSendCallback: {
                                            
                                        })
                                        
                                    }
                                    
                                    self.cateDataList[sender.tag].isAttention = true
                                    if let cateIndex = self.allDataList.firstIndex(where: { (obj) -> Bool in
                                        return obj.menuId == self.cateDataList[sender.tag].menuId
                                    }) {
                                        self.allDataList[cateIndex].isAttention = true
                                    }
                                    self.reloadData()
                                    
                                    stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                                        
                                    })
                                    
                                })
                            }
                            
                            
                        }
                        
                    }
                }
                
            }
            
        }
        
    }

}
