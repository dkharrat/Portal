//
//  PortalCollectionView.swift
//  PortalView
//
//  Created by Argentino Ducret on 4/4/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import UIKit

internal struct CollectionRenderer<
    MessageType,
    RouteType,
    CustomComponentRendererType: UIKitCustomComponentRenderer
    >: UIKitRenderer
    
    where CustomComponentRendererType.MessageType == MessageType, CustomComponentRendererType.RouteType == RouteType {
    
    typealias CustomComponentRendererFactory = () -> CustomComponentRendererType
    typealias ActionType = Action<RouteType, MessageType>
    
    let properties: CollectionProperties<ActionType>
    let style: StyleSheet<EmptyStyleSheet>
    let layout: Layout
    let rendererFactory: CustomComponentRendererFactory
    
    func render(with layoutEngine: LayoutEngine, isDebugModeEnabled: Bool) -> Render<ActionType> {
        let collectionView = PortalCollectionView(
            layoutEngine: layoutEngine,
            rendererFactory: rendererFactory
        )

        collectionView.isDebugModeEnabled = isDebugModeEnabled
        let changeSet = CollectionChangeSet.fullChangeSet(properties: properties, style: style, layout: layout)
        
        return collectionView.apply(changeSet: changeSet, layoutEngine: layoutEngine)
    }
    
}

extension PortalCollectionView: MessageForwarder {
    
    func apply(
        changeSet: CollectionChangeSet<ActionType>,
        layoutEngine: LayoutEngine) -> Render<ActionType> {
        
        apply(changeSet: changeSet.properties)
        apply(changeSet: changeSet.baseStyleSheet)
        layoutEngine.apply(changeSet: changeSet.layout, to: self)
        
        return Render<ActionType>(view: self, mailbox: getMailbox(), executeAfterLayout: .none)
    }
    
}

fileprivate extension PortalCollectionView {
    
    // swiftlint:disable cyclomatic_complexity
    fileprivate func apply(changeSet: [CollectionProperties<ActionType>.Property]) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }

        for propertiy in changeSet {
            switch propertiy {
                
            case .items(let items):
                setItems(items: items)
                reloadData()
                
            case .itemsSize(let itemsSize):
                layout.itemSize = CGSize(width: CGFloat(itemsSize.width), height: CGFloat(itemsSize.height))
                
            case .minimumInteritemSpacing(let minimumInteritemSpacing):
                layout.minimumInteritemSpacing = CGFloat(minimumInteritemSpacing)
                
            case .minimumLineSpacing(let minimumLineSpacing):
                layout.minimumLineSpacing = CGFloat(minimumLineSpacing)
                
            case .scrollDirection(let scrollDirection):
                switch scrollDirection {
                
                case .horizontal:
                    layout.scrollDirection = .horizontal
                
                case .vertical:
                    layout.scrollDirection = .vertical
                }
                
            case .sectionInset(let sectionInset):
                layout.sectionInset = UIEdgeInsets(
                    top: CGFloat(sectionInset.top),
                    left: CGFloat(sectionInset.left),
                    bottom: CGFloat(sectionInset.bottom),
                    right: CGFloat(sectionInset.right)
                )
                
            case .showsHorizontalScrollIndicator(let showsHorizontalScrollIndicator):
                self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
                
            case .showsVerticalScrollIndicator(let showsVerticalScrollIndicator):
                self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            }
        }

        collectionViewLayout = layout
    }
    // swiftlint:enable cyclomatic_complexity
    
}
