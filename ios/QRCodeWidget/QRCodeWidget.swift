import WidgetKit
import SwiftUI

struct QRCodeEntry: TimelineEntry {
    let date: Date
    let image: UIImage?
}

struct QRCodeProvider: TimelineProvider {
    let appGroupId = "group.com.nonprofit.nonprofitapp"
    let imageKey = "qr_code_image"

    func placeholder(in context: Context) -> QRCodeEntry {
        QRCodeEntry(date: Date(), image: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (QRCodeEntry) -> Void) {
        let entry = QRCodeEntry(date: Date(), image: loadQRImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QRCodeEntry>) -> Void) {
        let entry = QRCodeEntry(date: Date(), image: loadQRImage())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadQRImage() -> UIImage? {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        guard let imagePath = userDefaults?.string(forKey: imageKey) else { return nil }
        return UIImage(contentsOfFile: imagePath)
    }
}

struct QRCodeWidgetEntryView: View {
    var entry: QRCodeProvider.Entry

    var body: some View {
        if let image = entry.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(4)
        } else {
            Image(systemName: "qrcode")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

struct QRCodeWidget: Widget {
    let kind: String = "QRCodeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QRCodeProvider()) { entry in
            QRCodeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Donation QR Code")
        .description("Shows the donation QR code for quick access.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}
