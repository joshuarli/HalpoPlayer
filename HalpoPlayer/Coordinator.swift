//
//  Coordinator.swift
//  halpoplayer
//
//  Created by paul on 14/07/2023.
//

import SwiftUI

class Coordinator: ObservableObject {
	var viewingAlbum: String?
	@Published var path = NavigationPath()
	func albumTapped(albumId: String, scrollToSong: String?) {
		path.append(Destination.albumView(albumId: albumId, scrollToSong: scrollToSong))
	}
	func downloadsTapped() {
		path.append(Destination.downloads)
	}
	func goToLogin() {
		path.append(Destination.login)
	}
	func goToSearch() {
		path.append(Destination.search)
	}
	func albumTappedOffline(album: Album) {
		path.append(Destination.albumViewOffline(album: album))
	}
	func goToPlaylist(playlist: GetPlaylistsResponse.Playlist) {
		path.append(Destination.playlist(playlist: playlist))
	}
	func goToArtist(artistId: String, artistName: String) {
		path.append(Destination.artist(artistId: artistId, artistName: artistName))
	}
	func selectPlaylist(song: Song) {
		path.append(Destination.playlistSelect(song: song))
	}
}

enum Destination: Hashable {
	case downloads
	case login
	case albumView(albumId: String, scrollToSong: String?)
	case albumViewOffline(album: Album)
	case search
	case playlist(playlist: GetPlaylistsResponse.Playlist)
	case artist(artistId: String, artistName: String)
	case playlistSelect(song: Song)
}

class ViewFactory {
	@ViewBuilder
	class func viewForDestination(_ destination: Destination) -> some View {
		switch destination {
		case .albumView(let albumId, let scrollToSong):
			AlbumDetailView(albumId: albumId, scrollToSong: scrollToSong)
		case .downloads:
			DownloadsView()
		case .login:
			let account = AccountHolder.shared.account
			LoginView(address: account?.address ?? "",
					  otherAddress: account?.otherAddress ?? "",
					  username: account?.username ?? "",
					  password: account?.password ?? "")
		case .search:
			SearchView()
		case .albumViewOffline(let album):
			OfflineAlbumView(album: album)
		case .playlist(let playlist):
			PlaylistView(playlist: playlist)
		case .artist(let id, let artistName):
			ArtistView(artistId: id, artistName: artistName)
		case .playlistSelect(let song):
			PlaylistsView(song)
		}
	}
}
