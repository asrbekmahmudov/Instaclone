
import SwiftUI

struct SignInScreen: View {
    @ObservedObject var viewModel = SignInViewModel()
    
    @State var isLoading = false
    @State var email = ""
    @State var password = ""
    
    
    func doSignIn() {
        viewModel.apiSignIn(email: email, password: password, completion: {result in
            if !result{
                // when error, show dialog or toast
            }
        })
    }
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Utils.color1,Utils.color2]), startPoint: .bottom, endPoint: .top)
                
                VStack(spacing: 0){
                    Spacer()
                    
                    Text("app_name").foregroundColor(.white)
                        .font(Font.custom("Billabong", size: 45))
                    
                    TextField("", text: $email)
                        .frame(height: 50).padding(.leading,10)
                        .accentColor(.white)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4)).cornerRadius(8)
                        .padding(.top,10)
                        .placeholder(when: email.isEmpty) {
                            Text("email").foregroundColor(.white.opacity(0.5))
                                .frame(height: 50).padding(.leading,10)
                                .padding(.top,10)
                        }
                    
                    TextField("", text: $password)
                        .frame(height: 50).padding(.leading,10)
                        .accentColor(Color.green)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4)).cornerRadius(8)
                        .padding(.top,10)
                        .placeholder(when: password.isEmpty) {
                            Text("password").foregroundColor(.white.opacity(0.5))
                                .frame(height: 50).padding(.leading,10)
                                .padding(.top,10)
                        }
                    
                    Button(action: {
                        doSignIn()
                    }, label: {
                        Text("sign_in")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1.5)
                                    .foregroundColor(.white.opacity(0.4))
                            )
                    }).padding(.top,10)
                    Spacer()
                    
                    VStack{
                        
                        HStack{
                            Text("dont_have_account").foregroundColor(.white)
                            NavigationLink(
                                destination: SignUpScreen(),
                                label: {
                                    Text("sign_up").foregroundColor(.white).fontWeight(.bold)
                                })
                            
                        }
                    }.frame(maxWidth:.infinity, maxHeight: 70)
                    
                }.padding()
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
