import SwiftUI

struct SampleRecipes: View {
    @StateObject private var recipeBox = RecipeBox(recipes: load("recipeData.json"))
    @State private var selectedSidebarItem: SidebarItem? = SidebarItem.all
    @State private var selectedRecipeId: Recipe.ID?
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedSidebarItem, recipeBox: recipeBox)
        } content: {
            ContentListView(selection: $selectedRecipeId, selectedSidebarItem: selectedSidebarItem ?? SidebarItem.all)
        } detail: {
            DetailView(recipeId: $selectedRecipeId)
        }
        .environmentObject(recipeBox)
    }
}

struct SampleRecipes_Previews: PreviewProvider {
    static var previews: some View {
        SampleRecipes().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
