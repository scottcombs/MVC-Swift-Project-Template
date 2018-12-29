//___FILEHEADER___

import Cocoa

// THINGS TO DO:
// 1) TURN OFF APP Sandbox in Entitlements
// 2) SET Document Identifiers for Document Type and UTI to be the same

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func application(_ application: NSApplication, open urls: [URL]) {
		// Handle launching files from the Finder
		for url in urls {
			do{
				let doc = Document()
				doc.makeWindowControllers()
				try doc.read(from: url, ofType: "___VARIABLE_documentExtension___")
				doc.fileURL = url
				doc.model?.windowController?.showWindow(self)
			}catch{ }
		}
	}

	func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
		// App will not create an empty file automatically
		return false
	}

	@IBAction func openDocument(_ sender: Any?){
		// First Responder to open a file
		let panel : NSOpenPanel = NSOpenPanel()
		panel.canChooseFiles = true
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.showsHiddenFiles = false
		panel.allowedFileTypes = ["___VARIABLE_documentExtension___"]
		panel.title = "Open File"

		panel.begin { (response) in
			if response == NSApplication.ModalResponse.OK {
				do{
					let doc = Document()
					doc.makeWindowControllers()
					try doc.read(from: panel.url!, ofType: "___VARIABLE_documentExtension___")
					doc.fileURL = panel.url!
					doc.model?.windowController?.showWindow(self)
				}catch{}
			}
		}
	}
}

