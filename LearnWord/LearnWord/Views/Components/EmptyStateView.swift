import SwiftUI
 
 struct EmptyStateView: View {
     
    let option: Bool
     
    var body: some View {
        ContentUnavailableView("No Result",
                               systemImage: "magnifyingglass" ,
                               description: option ? Text("Please purchase this word package from the store") : Text("Please add your own words")
        )
        
    }
}

#Preview {
    EmptyStateView(option: true)
    EmptyStateView(option: false)
}
