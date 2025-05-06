import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedCafe: Cafe?
    @State private var cafeSearch: String = ""
    @State private var showCafeList: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Add title |", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Add content |", text: $content, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                    HStack {
                        TextField("Search Café", text: $cafeSearch)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: { showCafeList = true }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .sheet(isPresented: $showCafeList) {
                            CafePickerView(selectedCafe: $selectedCafe, searchText: $cafeSearch)
                        }
                    }
                    HStack(spacing: 16) {
                        Button(action: { showCafeList = true }) {
                            VStack {
                                if let cafe = selectedCafe {
                                    // Show a map preview or cafe name
                                    Text(cafe.name)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                } else {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("Add Cafe to View Map")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4])))
                        }
                        Button(action: { showImagePicker = true }) {
                            VStack {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("Add or edit Image")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4])))
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: $selectedImage)
                        }
                    }
                    Spacer(minLength: 24)
                    Button(action: {
                        // Handle upload post action here
                        dismiss()
                    }) {
                        Text("Upload Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// Placeholder for cafe picker
struct CafePickerView: View {
    @Binding var selectedCafe: Cafe?
    @Binding var searchText: String
    // You would pass in the list of cafes from your view model in a real implementation
    var body: some View {
        Text("Cafe Picker")
    }
}

// Placeholder for image picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    CreatePostView()
} 