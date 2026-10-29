import PhotosUI
import SwiftData
import SwiftUI

struct AddMealView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = AnalyzeViewModel()
    @State private var showCamera = false
    @State private var photoItem: PhotosPickerItem?
    @State private var showSaved = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    imagePreview

                    HStack(spacing: 12) {
                        Button {
                            showCamera = true
                        } label: {
                            Label("Fotoğraf Çek", systemImage: "camera")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))

                        PhotosPicker(selection: $photoItem, matching: .images) {
                            Label("Galeri", systemImage: "photo")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    if viewModel.result == nil {
                        Button {
                            Task { await viewModel.analyze() }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView().frame(maxWidth: .infinity)
                            } else {
                                Text("Kaloriyi Hesapla").frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.image == nil || viewModel.isLoading)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }

                    if let result = viewModel.result {
                        ResultView(analysis: result)

                        Picker("Öğün", selection: $viewModel.mealType) {
                            ForEach(MealType.allCases) { type in
                                Text(type.title).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)

                        Button {
                            viewModel.save(in: modelContext)
                            photoItem = nil
                            showSaved = true
                        } label: {
                            Label("Öğüne Kaydet", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(result.items.isEmpty)
                    }
                }
                .padding()
            }
            .navigationTitle("Öğün Ekle")
            .toolbar {
                if viewModel.image != nil {
                    Button("Temizle") {
                        viewModel.reset()
                        photoItem = nil
                    }
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker { viewModel.setImage($0) }
                    .ignoresSafeArea()
            }
            .onChange(of: photoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        viewModel.setImage(image)
                    }
                }
            }
            .alert("Kaydedildi", isPresented: $showSaved) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text("Öğün günlüğüne eklendi.")
            }
        }
    }

    @ViewBuilder
    private var imagePreview: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.15))
                .frame(height: 220)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "fork.knife").font(.largeTitle)
                        Text("Yemeğinin fotoğrafını ekle")
                    }
                    .foregroundStyle(.secondary)
                }
        }
    }
}

#Preview {
    AddMealView()
        .modelContainer(for: MealEntry.self, inMemory: true)
}
