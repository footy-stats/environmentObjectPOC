import SwiftUI

struct ChildView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        Text(network.resources.first?.data ?? "No User")
        Button("Update User", action: {
            print("BUTTON HIT")
            Task {
                do {
                    try await network.updateResources()
                    try await network.getResources()
                } catch {
                    print("Request failed with error: \(error)")
                }
            }
        })
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView()
            .environmentObject(Network())
    }
}
