import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        ScrollView {
            Text("All resources")
                .font(.title)
                .bold()
            ChildView()
            
            VStack(alignment: .leading) {
                ForEach(network.resources) { resource in
                    HStack(alignment:.top) {
                        Text("\(resource.id)")
                        
                        VStack(alignment: .leading) {
                            Text(resource.data)
                                .bold()
                        }
                    }
                    .frame(width: 300, alignment: .leading)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.6667672396, green: 0.7527905703, blue: 1, alpha: 0.2662717301)))
                    .cornerRadius(20)
                }
            }
            
        }
        .padding(.vertical)
        .task {
            do {
                try await network.getResources()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
