//
//  HomeViewTeste.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI
import CoreData

struct HomeViewTeste: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\StoryDataModel.text, order: .forward)], predicate: nil, animation: .default) private var storyData: FetchedResults<StoryDataModel>
    @Environment(\.managedObjectContext) var dbContext
    
    @State var firstData: StoryDataModel?
    @State var count = 0
    
    var body: some View {
        NavigationStack {
            HStack {
                Text(firstData?.showText ?? "")
            }
            List {
                ForEach(storyData) { data in
                    Text(data.showText)
                }.onDelete { indexes in
                    Task(priority: .high) {
                        await deleteData(indexes: indexes)
                    }
                }
            }
            .navigationTitle("Story Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Plus") {
                        Task(priority: .high) {
                            await storeData()
                        }
                    }
                }
            }
        }.onAppear {
            fetchData()
        }
    }
    
    private func deleteData(indexes: IndexSet) async {
        await dbContext.perform {
            for index in indexes {
                dbContext.delete(storyData[index])
            }
            do {
                try dbContext.save()
            } catch {
                print("error deleting objects")
            }
        }
    }
    
    private func storeData() async {
        count += 1
        await dbContext.perform {
            let newData = StoryDataModel(context: dbContext)

            newData.text = "Era uma vez... \(count)"
            newData.title = "Uma historia"
            
            do {
                try dbContext.save()
            } catch {
                print("Error savinda data")
            }
        }
    }
    
    private func fetchData() {
        let request: NSFetchRequest<StoryDataModel> = StoryDataModel.fetchRequest()
        if let list = try? self.dbContext.fetch(request) {
            firstData = list.first
        }
    }
}

struct HomeViewTeste_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewTeste()
            .environment(\.managedObjectContext, ApplicationData.preview.container.viewContext)
    }
}
