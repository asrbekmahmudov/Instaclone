
import SwiftUI
import SDWebImageSwiftUI

struct HomeProfileScreen: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewModel = ProfileViewModel()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var showActionSheet = false
    @State private var isImagePickerDisplay = false
    @State private var showingAlert = false
    
    @State var level = 1
    @State var columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: UIScreen.width - 20), spacing: 10), count: 1)
    
    init() {
        columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: level)
    }
    
    func postSize() -> CGFloat {
        //        if level == 1 {
        //            return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
        //        } else if level == 2 {
        //            return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
        //        }
        return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
    }
    
    
    func listStyle(type: Int){
        level = type
        columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: level)
    }
    
    func uploadImage() {
        let uid = (session.session?.uid)!
        viewModel.apiUploadMyImage(uid: uid, image: selectedImage!, post: viewModel.items)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing: 0){
                    ZStack{
                        VStack{
                            if !viewModel.imgUser.isEmpty {
                                WebImage(url: URL(string:viewModel.imgUser))
                                    .resizable()
                                    .clipShape(Circle())
                                    .scaledToFill()
                                    .frame(height:70)
                                    .frame(width:70)
                                    .padding(.all, 2)
                            } else {
                                Image("ic_person")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(height:70)
                                    .frame(width:70)
                                    .padding(.all, 2)
                                
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 37)
                            .stroke(Utils.color2, lineWidth: 2))
                        
                        
                        HStack{
                            Spacer()
                            VStack{
                                Spacer()
                                Button(action: {
                                    showActionSheet = true
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.white)
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                    }
                                    .frame(width: 22, height: 22)
                                })
                                .actionSheet(isPresented: $showActionSheet) {
                                    ActionSheet(
                                        title: Text("Actions"),
                                        buttons: [
                                            .cancel { print(self.showActionSheet) },
                                            .default(Text("Pick Photo")){
                                                self.sourceType = .photoLibrary
                                                self.isImagePickerDisplay.toggle()
                                            },
                                            .default(Text("Take Photo")){
                                                self.sourceType = .camera
                                                self.isImagePickerDisplay.toggle()
                                            },
                                        ]
                                    )
                                }
                                .sheet(isPresented: self.$isImagePickerDisplay, onDismiss: uploadImage) {
                                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                                }
                            }
                        }.frame(height:77)
                            .frame(width:77)
                        
                    }
                    
                    Text(viewModel.displayName)
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                        .padding(.top, 15)
                    
                    Text(viewModel.email)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                        .padding(.top, 3)
                    
                    HStack{
                        VStack{
                            Text(String(viewModel.items.count))
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .fontWeight(.medium)
                            Text("Posts")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3, maxHeight: 60)
                        
                        VStack{}.frame(maxWidth: 1, maxHeight: 25)
                            .background(Color.gray.opacity(0.5))
                        
                        VStack{
                            Text(String(viewModel.followers.count))
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .fontWeight(.medium)
                            Text("Followers")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3, maxHeight: 60)
                        
                        VStack{}.frame(maxWidth: 1, maxHeight: 25)
                            .background(Color.gray.opacity(0.5))
                        
                        VStack{
                            Text(String(viewModel.following.count))
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .fontWeight(.medium)
                            Text("Following")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3, maxHeight: 60)
                    }.padding(.top, 10)
                    
                    HStack {
                        Button(action: {
                            self.level = 1
                            self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 1)
                        }, label: {
                            Image(systemName: level == 1 ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2")
                                .resizable().frame(width: 20, height: 17)
                        }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                        Button(action: {
                            self.level = 2
                            self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 2)
                        }, label: {
                            Image(systemName: level == 2 ? "rectangle.grid.2x2.fill" : "rectangle.grid.2x2")
                                .resizable().frame(width: 20, height: 17)
                        }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                        Button(action: {
                            self.level = 3
                            self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 3)
                        }, label: {
                            Image(systemName: level == 3 ? "rectangle.grid.3x2.fill" : "rectangle.grid.3x2")
                                .resizable().frame(width: 20, height: 17)
                        }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                    }.padding(.top, 10).padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVGrid(columns: columns,spacing: 10){
                            ForEach(viewModel.items, id:\.self){ item in
                                if let uid = session.session?.uid! {
                                    MyPostCell(uid:uid,viewModel: viewModel,post: item, length: postSize())
                                }
                            }
                        }
                    }.padding(.top, 10)
                }.padding(.all, 20)
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showingAlert = true
            }, label: {
                Image(systemName: "pip.exit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            })
                                        .alert(isPresented: $showingAlert) {
                                            let title = "Signout"
                                            let message = "Do you want to signout?"
                                            return Alert(title: Text(title), message: Text(message), primaryButton: .destructive(Text("Confirm"), action: {
                                                viewModel.apiSignOut()
                                            }), secondaryButton: .cancel())
                                        }
            )
            .navigationBarTitle("Profile",displayMode: .inline)
        }.onAppear{
            let uid = (session.session?.uid)!
            viewModel.apiPostList(uid: uid)
            viewModel.apiLoadUser(uid: uid)
            viewModel.apiLoadFollowing(uid: uid)
            viewModel.apiLoadFollowers(uid: uid)
            
        }
    }
}

struct HomeProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeProfileScreen()
    }
}
