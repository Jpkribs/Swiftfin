//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Defaults
import SwiftUI

struct AlphaPickerView: View {
    
    @ObservedObject
    var viewModel: FilterViewModel
    private var onSelect: (FilterCoordinator.Parameters) -> Void
    
    init(viewModel: FilterViewModel, onSelect: @escaping (FilterCoordinator.Parameters) -> Void) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(ItemLetterFilter.allCases, id: \.self) { letter in
                    AlphaPickerButton(letter: letter.rawValue, activated: viewModel.currentFilters.nameStartsWith.contains {
                        $0.displayTitle == String(letter.rawValue)
                    }, viewModel: viewModel)
                    .onSelect {
                        onSelect(.init(
                            title: L10n.letter,
                            viewModel: viewModel,
                            filter: \.nameStartsWith,
                            selectorType: .single
                        ))
                    }
                }
            }
            .frame(width: 10)
        }
    }
}

extension AlphaPickerView {
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        self.onSelect = { _ in }
    }

    func onSelect(_ action: @escaping (FilterCoordinator.Parameters) -> Void) -> Self {
        copy(modifying: \.onSelect, with: action)
    }
}

