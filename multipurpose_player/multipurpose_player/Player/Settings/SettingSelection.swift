//
//  SettingSelection.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import SwiftUI

struct SettingSelection<Item: SettingSelectionItemProtocol>: View {
    private var items: [Item]
    @Binding private var item: Item?
    private var onSelectedItemHandler: ((Item) -> Void)?
    
    init(items: [Item], item: Binding<Item?>) {
        self.items = items
        self._item = item
    }
    
    var body: some View {
        List(selection: $item) {
            ForEach(items, id: \.id) { item in
                Button(action: {
                    if self.item?.id != item.id {
                        self.item = item
                        onSelectedItemHandler?(item)
                    }
                }) {
                    HStack {
                        ZStack {
                            if self.item?.id == item.id {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                EmptyView()
                            }
                        }
                        .frame(width: 24, height: 24)
                        Text(item.title)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarHidden(true)
    }
    
    func onSelectedItem(handler: @escaping (Item) -> Void) -> Self {
        var copy = self
        copy.onSelectedItemHandler = handler
        return copy
    }
}

//struct SettingSelection_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingSelection()
//    }
//}
