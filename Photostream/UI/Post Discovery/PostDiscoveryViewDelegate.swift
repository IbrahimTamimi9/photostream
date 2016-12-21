//
//  PostDiscoveryViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostDiscoveryViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var condition: Bool = false
        
        switch sceneType {
        case .grid:
            condition = indexPath.row == presenter.postCount - 10
            
        case .list:
            condition = indexPath.section == presenter.postCount - 10
        }
        
        guard condition else {
            return
        }
        
        presenter.loadMorePosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard sceneType == .grid else {
            return
        }
        
        presenter.presentPostDiscovery(initialPostIndex: indexPath.row)
    }
}

extension PostDiscoveryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sceneType {
        case .grid:
            return gridLayout.itemSize
            
        case .list:
            let item = presenter.post(at: indexPath.section) as? PostListCollectionCellItem
            prototype.configure(with: item, isPrototype: true)
            let size = CGSize(width: listLayout.itemSize.width, height: prototype.dynamicHeight)
            return size
        }
    }
}

extension PostDiscoveryViewController: PostListCollectionCellDelegate {
    
    func didTapPhoto(cell: PostListCollectionCell) {
        guard let index = collectionView![cell]?.section else {
            return
        }
        
        presenter.likePost(at: index)
    }
    
    func didTapHeart(cell: PostListCollectionCell) {
        guard let index = collectionView![cell]?.section,
            let post = presenter.post(at: index) else {
                return
        }
        
        cell.toggleHeart(liked: post.isLiked) { [unowned self] in
            self.presenter.toggleLike(at: index)
        }
    }
    
    func didTapComment(cell: PostListCollectionCell) {
        guard let index = collectionView![cell]?.section else {
            return
        }
        
        presenter.presentCommentController(at: index, shouldComment: true)
    }
    
    func didTapCommentCount(cell: PostListCollectionCell) {
        guard let index = collectionView![cell]?.section else {
            return
        }
        
        presenter.presentCommentController(at: index)
    }
    
    func didTapLikeCount(cell: PostListCollectionCell) {
        
    }
}

extension PostDiscoveryViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollHandler.isScrollable {
            if scrollHandler.isScrollingUp {
                scrollEventListener?.didScrollUp(
                    with: scrollHandler.offsetDelta,
                    offsetY: scrollHandler.currentOffsetY )
            } else if scrollHandler.isScrollingDown {
                scrollEventListener?.didScrollDown(
                    with: scrollHandler.offsetDelta,
                    offsetY: scrollHandler.currentOffsetY)
            }
            scrollHandler.update()
        }
    }
}