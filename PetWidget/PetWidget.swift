import WidgetKit
import SwiftUI
import Alamofire

// MARK: - 兼容 URL / 本地资源名 的头像视图（Swift 6 友好）
struct WidgetAvatarImage: View {
    let avatar: String

    var body: some View {
        if let url = URL(string: avatar),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    Image("bunny").resizable().scaledToFit()
                }
            }
        } else {
            Image(avatar.isEmpty ? "bunny" : avatar)
                .resizable()
                .scaledToFit()
        }
    }
}

// MARK: - Swift 6：避免 Task(@Sendable) 捕获非 Sendable completion
private final class CompletionBox<Entry: TimelineEntry>: @unchecked Sendable {
    let completion: (Timeline<Entry>) -> Void

    init(_ completion: @escaping (Timeline<Entry>) -> Void) {
        self.completion = completion
    }
}

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    petList: [PetModel(name: "我的爱宠", avatar: "bunny", description: "可爱的爱宠...")])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(),
                               petList: [PetModel(name: "我的爱宠", avatar: "bunny", description: "可爱的爱宠...")]))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let box = CompletionBox<SimpleEntry>(completion)

        Task {
            do {
                let currentDate = Date()
                let petList = (try await fetchData()).data ?? []

                let entry = SimpleEntry(date: currentDate, petList: petList)
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

                box.completion(timeline)
            } catch {
                let entry = SimpleEntry(date: Date(),
                                        petList: [PetModel(name: "Error", avatar: "bunny", description: "Error fetching data")])
                let timeline = Timeline(entries: [entry], policy: .never)
                box.completion(timeline)
            }
        }
    }

    // MARK: Fetching JSON Data
    func fetchData() async throws -> BaseResult<[PetModel]> {
        var token = ""
        if let sharedDefaults = UserDefaults(suiteName: "group.pet.zzz.loveoss"),
           let sharedData = sharedDefaults.string(forKey: "token") {
            token = sharedData
        }

        let headers: HTTPHeaders = [
            // 你原来是 "Authentication"，如果后端实际是 Authorization 这里记得对齐
            "Authentication": "Bearer " + token
        ]

        return try await AF.request(Urls.GET_PET_LIST, headers: headers)
            .validate()
            .serializingDecodable(BaseResult<[PetModel]>.self)
            .value
    }
}

// ⚠️ Widget entry 不需要 Codable（去掉更少并发/Sendable 的麻烦）
struct SimpleEntry: TimelineEntry {
    var date: Date
    var petList: [PetModel]
    var title: String?
}

struct PetWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if let pet = entry.petList.randomElement() {
            ZStack {
                switch widgetFamily {
                case .systemMedium:
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                WidgetAvatarImage(avatar: pet.avatar)
                                    .scaledToFill()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing)

                        VStack(alignment: .leading) {
                            Spacer(minLength: 0)

                            HStack {
                                Text(pet.name)
                                    .font(.title2)
                                Spacer(minLength: 0)
                                if let emoji = pet.familyModel.cn.split(separator: " ").last {
                                    Text(emoji)
                                }
                            }
                            .frame(maxWidth: .infinity)

                            Spacer(minLength: 0)

                            // ✅ SwiftUI 的日期格式（替代全局 DateFormatter 并发隐患）
                            Text(pet.birthDate, format: .dateTime.year().month().day())

                            Spacer(minLength: 0)

                            Text(pet.description)
                                .font(.subheadline)
                                .minimumScaleFactor(0.7)

                            Spacer(minLength: 0)
                        }
                    }

                case .systemLarge:
                    WidgetAvatarImage(avatar: pet.avatar)
                        .scaledToFill()
                        .padding(-20)

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(pet.name)
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                        .padding(.trailing)
                    }

                default:
                    WidgetAvatarImage(avatar: pet.avatar)
                        .scaledToFill()
                        .padding(-20)
                }
            }
            .widgetURL(URL(string: "https://zzz.pet/loveoss/note?selectedPet=\(pet.id)"))
        }
    }
}

struct PetWidget: Widget {
    let kind: String = "PetWidgetOss"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PetWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget oss")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PetWidget()
} timeline: {
    SimpleEntry(date: .now, petList: [])
}
