//
//  Notification.swift
//  CastPod
//
//  Created by William Yeung on 6/30/21.
//

import Foundation

extension Notification.Name {
    static let shouldDismissPlayerDetailView = Notification.Name("shouldDismissPlayerDetailView")
    static let shouldShowHideEpisodeDescription = Notification.Name("shouldShowHideEpisodeDescription")
    static let shouldReloadFavorites = Notification.Name("shouldReloadFavorites")
    static let shouldUnfavoritePodcast = Notification.Name("shouldUnfavoritePodcast")
    static let shouldReloadDownloads = Notification.Name("shouldReloadDownloads")
    static let shouldUpdateDownloadProgress = Notification.Name("shouldUpdateDownloadProgress")
}
