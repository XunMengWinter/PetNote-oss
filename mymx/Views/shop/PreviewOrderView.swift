//
//  PreviewOrderView.swift
//  mymx
//
//  Created by ice on 2024/8/3.
//
import SwiftUI
import MapKit


struct PreviewOrderView: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject private var viewModel = PostOrderVM()
    
    let goodsList: [GoodsId]
    let goodsAmount: Int
    
    @State private var takeWay = 2
    @State private var note = ""
    @State private var payWay = "wechatpay"
    
    @State private var showTopTips: Bool = false
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    private let takeWays = [
        TakeWay(name: " 🛍︎  到店自取（\(GlobalParams.shopOpenTime)）", value: 0),
        TakeWay(name: " 🛵  外卖配送（仅限地图蓝色区域内）", value: 1),
        TakeWay(name: " 📦  快递到家（约1～3天送达）", value: 2)
    ]
    
    private let payWays = [
        PayWay(id: "wechatpay", name: "微信支付", image: "ic_wechat_pay", hexColor: "23ac38", whiteImage: "ic_wechat_pay_white"),
        PayWay(id: "alipay", name: "支付宝", image: "ic_alipay", hexColor: "00a0e9", whiteImage: "ic_alipay_white"),
        PayWay(id: "applepay", name: "Apple Pay", image: "ic_apple_pay", hexColor: "000", whiteImage: "ic_apple_pay_white")
    ]
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 0) {
                    MapView()
                        .frame(height: 250)
                    Text("配送方式")
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    Divider()
                    VStack(alignment: .leading, spacing: 0){
                        ForEach(takeWays) { item in
                            HStack{
                                Image(systemName: takeWay == item.value ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(takeWay == item.value ? .green : Color(hex: "999"))
                                Text(item.name)
                                    .foregroundStyle(.darkBg)
                                    .fontWeight(takeWay == item.value ? .medium : .regular)
                                    .opacity(takeWay == item.value ? 1 : 0.667)
                                Spacer(minLength: 0)
                            }
                            .padding(.leading)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                self.takeWay = item.value
                                postOrder()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .background(.lightBg)
                    Divider()
                    
                    Text("收货信息")
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    Divider()
                    
                    NavigationLink(destination: EmptyView(), label: {
                        HStack{
                            Image(systemName: "location")
                            Text("Winter, 10086, 浙江省 杭州市 西湖区 猫与猫寻")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .font(.callout)
                        .padding()
                    })
                    .background(.lightBg)
                    Divider()
                    
                    Text("优惠券")
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    Divider()
                    NavigationLink(destination: CouponView()) {
                        HStack {
                            Image(systemName: "checkmark.square.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.green)
                            Text(" \((Float(2000) / 100.0), specifier: "%g")元优惠券")
                                .fontWeight(.medium)
                                .foregroundStyle(Color(hex: "daa520"))
                            Spacer()
                            Text("已为您选择最佳优惠")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.callout)
                        }
                        .padding()
                        .background(.lightBg)
                        
                        Divider()
                    }
                    Text("备注")
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    Divider()
                    TextField("选填", text: $note)
                        .padding()
                        .frame(minHeight: 100)
                        .submitLabel(.done)
                        .background(.lightBg)
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("* 营业时间：\(GlobalParams.shopOpenTime)")
                        Text("* 外卖配送+10元，邮寄+6元")
                        Text("* 满100元，运费立减")
                        HStack(spacing: 0){
                            Text("* 非营业时间如需配送，请联系 ")
                            //  Clickable telphone number
                            Link("15557128842", destination: URL(string: "tel:15557128842")!)
                                .underline()
                        }
                    }
                    .padding()
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 120)
                    
                    Text("查看历史订单")
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 120)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .background(.orderBg)
            .dismissKeyboardOnScroll()
            
            VStack(spacing: 0){
                Spacer()
                Divider()
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        Menu{
                            Picker(selection: $payWay, label: EmptyView()){
                                ForEach(payWays) { item in
                                    HStack(spacing: 0){
                                        Image("\(item.image)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 16)
                                        Text(" \(item.name)")
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 0){
                                if let payWayItem = payWays.first(where: {$0.id == self.payWay}) {
                                    Text("使用 ")
                                    Image("\(payWayItem.image)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 16)
                                    Text("\(payWayItem.id == "applepay" ? "" : payWayItem.name)，更换支付方式 ")
                                    Image(systemName: "chevron.right")
                                }
                                Spacer()
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 6)
                        }
                        
                        HStack(alignment: .firstTextBaseline){
                            Text("¥")
                                .font(.title3)
                                .bold()
                            Text("\(Float(self.goodsAmount) / 100.0, specifier: "%g")")
                                .font(.title)
                                .bold()
                            Text(" 已优惠¥\(Float(2000) / 100.0, specifier: "%g")")
                                .font(.callout)
                        }
                        .foregroundColor(.priceDarkRed)
                        .padding(.bottom, 6)
                    }
                    .padding(.leading)
                    
                    Button(action: {
                        payOrder()
                    }, label: {
                        if let payWayItem = payWays.first(where: {$0.id == self.payWay}) {
                            
                            HStack{
                                Image(payWayItem.whiteImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 26)
                                Text("确认付款")
                                
                            }
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .frame(minHeight: 68)
                            .foregroundStyle(.white)
                            .background(Color(hex: payWayItem.hexColor))
                        }
                    })
                    .disabled(viewModel.loading)
                }
                .frame(maxWidth: .infinity)
                .background(.lightBg)
                .opacity(0.9)
            }
            .ignoresSafeArea(.keyboard)
        }
        .background(.lightBg)
        .navigationTitle("提交订单")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.errorMsg), dismissButton: .default(Text("确定")))
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                if viewModel.loading{
                    ProgressView()
                }
            })
        })
        .onAppear(perform: {
            postOrder()
        })
    }
    
    func getOrderRequest() -> OrderRequestModel{
        let order = OrderRequestModel(goodsIds: self.goodsList, goodsAmount: self.goodsAmount, takeWay: self.takeWay, note: self.note, payWay: self.payWay)
        return order
    }
    
    func postOrder(){
    }
    
    func payOrder(){
    }
    
}

struct PayWay: Identifiable, Hashable{
    let id: String
    let name: String
    let image: String
    let hexColor: String
    let whiteImage: String
}

struct TakeWay: Identifiable, Hashable {
    var id: Int { value }
    var name: String
    var value: Int
}

#Preview {
    PreviewOrderView(goodsList: [], goodsAmount: 0)
        .environmentObject(ModelData())
}
