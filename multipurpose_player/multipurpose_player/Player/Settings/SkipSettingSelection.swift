//
//  SkipSettingSelection.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/25.
//

import SwiftUI

struct SkipSettingSelection<RewindItem: SettingSelectionItemProtocol,
                            ForwardItem: SettingSelectionItemProtocol>: View {
    private var rewindItems: [RewindItem]
    @Binding private var rewindItem: RewindItem?
    private var forwardItems: [ForwardItem]
    @Binding private var forwardItem: ForwardItem?
    private var onSelectedRewindItemHandler: ((RewindItem) -> Void)?
    private var onSelectedForwardItemHandler: ((ForwardItem) -> Void)?
    
    init(rewindItems: [RewindItem],
         rewindItem: Binding<RewindItem?>,
         forwardItems: [ForwardItem],
         forwardItem: Binding<ForwardItem?>) {
        self.rewindItems = rewindItems
        self._rewindItem = rewindItem
        self.forwardItems = forwardItems
        self._forwardItem = forwardItem
    }
    
    var body: some View {
        List {
            Section(header: Text("巻戻し")) {
                ForEach(rewindItems, id: \.id) { item in
                    Button(action: {
                        if self.rewindItem?.id != item.id {
                            self.rewindItem = item
                            onSelectedRewindItemHandler?(item)
                        }
                    }) {
                        HStack {
                            ZStack {
                                if self.rewindItem?.id == item.id {
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
            Section(header: Text("早送り")) {
                ForEach(forwardItems, id: \.id) { item in
                    Button(action: {
                        if self.forwardItem?.id != item.id {
                            self.forwardItem = item
                            onSelectedForwardItemHandler?(item)
                        }
                    }) {
                        HStack {
                            ZStack {
                                if self.forwardItem?.id == item.id {
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
        }
        .listStyle(.plain)
        .navigationBarHidden(true)
    }
    
    func onSelectedRewindItem(handler: @escaping (RewindItem) -> Void) -> Self {
        var copy = self
        copy.onSelectedRewindItemHandler = handler
        return copy
    }
    func onSelectedForwardItem(handler: @escaping (ForwardItem) -> Void) -> Self {
        var copy = self
        copy.onSelectedForwardItemHandler = handler
        return copy
    }
}
