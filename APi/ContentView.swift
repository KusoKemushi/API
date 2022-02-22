//
//  ContentView.swift
//  APi
//
//  Created by Student on 2/16/22.
//

import SwiftUI

struct ContentView: View {
    @State private var elements = [Element]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView{
            List (elements) {element in
                NavigationLink(
                    destination: VStack {
                        Text(element.name)
                        Text(element.symbol)
                    },
                    label: {
                        HStack {
                            Text(element.symbol)
                            Text(element.name)
                        }
                    })
            }
            .navigationTitle("Periodic elements")
        }
        .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("LoadingError"), message: Text("There was a problem loading the data"), dismissButton: .default(Text("ok")))
        })
    }
    


    func queryAPI() {
        let apiKey = "?rapidapi-key=4e879ce7a5mshe1c550f5faffffdp1ace78jsn17d02b548c06"
        let query = "https://periodictable.p.rapidapi.com\(apiKey)"
        if let url = URL(string: query){
            if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data:data)
                    let contents = json.arrayValue
                    for item in contents{
                        let name = item["name"].stringValue
                        let symbol = item["symbol"].stringValue
                        let element = Element(name: name, symbol: symbol)
                        elements.append(element)
                    }
                    return
                }
            }
            showingAlert = true
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    struct Element: Identifiable {
        let id = UUID()
        var name: String
        var symbol: String
    }
