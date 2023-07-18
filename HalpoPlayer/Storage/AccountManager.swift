//
//  Account.swift
//  halpoplayer
//
//  Created by paul on 13/07/2023.
//

import Foundation

class AccountHolder: ObservableObject {
	static let shared = AccountHolder()
	var offline = false
	@Published var account: Account? {
		didSet {
			guard account != nil else { return }
			SubsonicClient.shared.account = account
			Task {
				if try await SubsonicClient.shared.authenticate() {
					let data = try JSONEncoder().encode(account)
					UserDefaults.standard.set(data, forKey: "UserAccount")
//					let albums = try await SubsonicClient.shared.getAlbumList()
//					DispatchQueue.main.async {
//						Database.shared.albums = albums.subsonicResponse.albumList.album
//					}
				}
			}
		}
	}
	init() {
		if let accountData = UserDefaults.standard.data(forKey: "UserAccount") {
			account = try? JSONDecoder().decode(Account.self, from: accountData)
			SubsonicClient.shared.account = account
		}
	}
}
