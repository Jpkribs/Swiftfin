//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

// Joe Kribs: joseph@kribs.net 02/06/2023
// Formats the Letters in the LetteredScrollbar

import Defaults
import SwiftUI

extension AlphaPickerView {
    
    struct AlphaPickerButton: View {
        
        @Default(.accentColor)
        private var accentColor
        
        private let letter: Character
        private let activated: Bool
        private let viewModel: FilterViewModel
        private var onSelect: () -> Void
        
        private init(
            letter: Character,
            activated: Bool,
            viewModel: FilterViewModel,
            onSelect: @escaping () -> Void
        ) {
            self.letter = letter
            self.activated = activated
            self.viewModel = viewModel
            self.onSelect = onSelect
        }
        
        var body: some View {
#if os(iOS)
            Button(action: {
                if let selectedLetterFilter = ItemLetterFilter(rawValue: letter) {
                    if viewModel.currentFilters.nameStartsWith != [selectedLetterFilter.filter] {
                        viewModel.currentFilters.nameStartsWith = [selectedLetterFilter.filter]
                    } else {
                        viewModel.currentFilters.nameStartsWith = []
                    }
                }
            })
            {
                Text(String(letter))
                    .font(.footnote.weight(.semibold))
                    .frame(width: 15, height: 15)
                    .foregroundColor(activated ? Color(UIColor.white) : accentColor)
                    .opacity(1.0)
                    .padding(.vertical, 1)
                    .fixedSize(horizontal: true, vertical: true)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 20, height: 20)
                            .foregroundColor(activated ? accentColor.opacity(0.5) : Color(UIColor.clear).opacity(0.0))
                    }
            }
#else
            Button(action: {
                if let selectedLetterFilter = LetterFilter(rawValue: letter) {
                    if viewModel.currentFilters.nameStartsWith != [selectedLetterFilter.filter] {
                        viewModel.currentFilters.nameStartsWith = [selectedLetterFilter.filter]
                    } else {
                        viewModel.currentFilters.nameStartsWith = []
                    }
                }
            })
            {
                Text(letter)
                    .font(.footnote.weight(.semibold))
                    .shadow(color: Color.black.opacity(activated ? 0.0 : 1.0), radius: 1, x: 1, y: 1)
                    .foregroundColor(activated ? Color.white : accentColor)
                    .padding(10)
                    .padding(.trailing, 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(width: 2, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 32.5, height: 32.5)
                                    .foregroundColor(activated ? accentColor.opacity(1.0) : Color(UIColor.clear).opacity(0.0))
                                    .padding(.trailing, 20)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
#endif
        }
    }
}

extension AlphaPickerView.AlphaPickerButton {
    init(letter: Character, activated: Bool, viewModel: FilterViewModel) {
        self.init(
            letter: letter,
            activated: activated,
            viewModel: viewModel,
            onSelect: {}
        )
    }

    func onSelect(_ action: @escaping () -> Void) -> Self {
        copy(modifying: \.onSelect, with: action)
    }
}
