//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import CollectionView
import Defaults
import JellyfinAPI
import SwiftUI

struct LibraryView: View {

    @Default(.Customization.Library.viewType)
    private var libraryViewType

    @Default(.Customization.Filters.libraryFilterDrawerButtons)
    private var filterDrawerButtonSelection

    @Default(.Customization.Filters.alphaPickerSelection)
    private var alphaPickerOrientation

    @EnvironmentObject
    private var router: LibraryCoordinator.Router

    @State private var showAlphaPicker = true
    
    @ObservedObject
    var viewModel: LibraryViewModel

    @ViewBuilder
    private var loadingView: some View {
        ProgressView()
    }

    @ViewBuilder
    private var noResultsView: some View {
        L10n.noResults.text
    }

    private func baseItemOnSelect(_ item: BaseItemDto) {
        if let baseParent = viewModel.parent as? BaseItemDto {
            if baseParent.collectionType == "folders" {
                router.route(to: \.library, .init(parent: item, type: .folders, filters: .init()))
            } else if item.type == .folder {
                router.route(to: \.library, .init(parent: item, type: .library, filters: .init()))
            } else {
                router.route(to: \.item, item)
            }
        } else {
            router.route(to: \.item, item)
        }
    }

    @ViewBuilder
    private var libraryItemsView: some View {
        if(alphaPickerOrientation == .disabled) {
            PagingLibraryView(viewModel: viewModel)
                .onSelect { item in
                    baseItemOnSelect(item)
                }
                .ignoresSafeArea()
        }
        else {
            if(alphaPickerOrientation == .right) {
                HStack(spacing: 0) {
                    PagingLibraryView(viewModel: viewModel)
                        .onSelect { item in
                            baseItemOnSelect(item)
                        }
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                    if(showAlphaPicker)
                    {
                        AlphaPickerView(viewModel: viewModel.filterViewModel)
                            .frame(width: 30)
                            .ignoresSafeArea()
                            .onAppear() {
                                let availableHeight = UIScreen.main.bounds.height
                                let requiredHeight = CGFloat(26) * 30
                                
                                showAlphaPicker = requiredHeight <= availableHeight
                            }
                    }
                }
            }
            else if(alphaPickerOrientation == .left) {
                HStack(spacing: 0) {
                    AlphaPickerView(viewModel: viewModel.filterViewModel)
                        .frame(width: 30)
                        .ignoresSafeArea()
                        .onAppear() {
                            let availableHeight = UIScreen.main.bounds.height
                            let requiredHeight = CGFloat(26) * 30
                            
                            showAlphaPicker = requiredHeight <= availableHeight
                        }
                    PagingLibraryView(viewModel: viewModel)
                        .onSelect { item in
                            baseItemOnSelect(item)
                        }
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.items.isEmpty {
                loadingView
            } else if viewModel.items.isEmpty {
                noResultsView
            } else {
                libraryItemsView
            }
        }
        .navigationTitle(viewModel.parent?.displayTitle ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .if(!filterDrawerButtonSelection.isEmpty) { view in
            view.navBarDrawer {
                ScrollView(.horizontal, showsIndicators: false) {
                    FilterDrawerHStack(viewModel: viewModel.filterViewModel, filterDrawerButtonSelection: filterDrawerButtonSelection)
                        .onSelect { filterCoordinatorParameters in
                            router.route(to: \.filter, filterCoordinatorParameters)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {

                if viewModel.isLoading && !viewModel.items.isEmpty {
                    ProgressView()
                }

                LibraryViewTypeToggle(libraryViewType: $libraryViewType)
            }
        }
    }
}
