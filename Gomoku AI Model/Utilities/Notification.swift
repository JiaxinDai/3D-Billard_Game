import Foundation

let visPrefNotif = Notification.Name("vis-pref")

func post(_ notif: Notification.Name, _ object: Any?) {
    NotificationCenter.default.post(name: notif, object: object)
}

func post(_ notif: Notification.Name) {
    post(notif, nil)
}
