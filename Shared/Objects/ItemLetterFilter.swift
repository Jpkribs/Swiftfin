//
// jellyfin-sdk-swift is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation
import JellyfinAPI

public enum ItemLetterFilter: Character, Codable, CaseIterable {
    case letter_A = "A"
    case letter_B = "B"
    case letter_C = "C"
    case letter_D = "D"
    case letter_E = "E"
    case letter_F = "F"
    case letter_G = "G"
    case letter_H = "H"
    case letter_I = "I"
    case letter_J = "J"
    case letter_K = "K"
    case letter_L = "L"
    case letter_M = "M"
    case letter_N = "N"
    case letter_O = "O"
    case letter_P = "P"
    case letter_Q = "Q"
    case letter_R = "R"
    case letter_S = "S"
    case letter_T = "T"
    case letter_U = "U"
    case letter_V = "V"
    case letter_W = "W"
    case letter_X = "X"
    case letter_Y = "Y"
    case letter_Z = "Z"

    var filter: ItemFilters.Filter {
        .init(displayTitle: String(rawValue), id: String(rawValue), filterName: String(rawValue))
    }
}
