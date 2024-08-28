//
//  ShopHome.swift
//  mymx
//
//  Created by ice on 2024/6/17.
//

import SwiftUI
import NukeUI

struct ShopView: View {
    private let imageUrl = MockData().imageUrl
    @ObservedObject var viewModel: ShopVM
    
    @State private var selectedType = GoodsTypeModel.goodsTypes[0]
    
    @State private var scrollID: String?
    
    @State private var bannerHeight: Float = 0.0
    @State private var itemHeight: Float = 0.0
    @State private var scrollOffset: CGFloat = 0
    
    @State private var lastTapTime = 0.0
    @State private var showSearch = false
    @State private var searchKey = ""
    @State private var showCart = false
    let screenWidth = UIScreen.main.bounds.size.width

    
    var body: some View{
        VStack(spacing: 0){
            ZStack{
                HStack(spacing: 0){
                    ScrollView(){
                        VStack(spacing: 0){
                            ForEach(viewModel.goodsTypes){ goodsType in
                                ZStack(alignment: .leading)
                                {
                                    Rectangle()
                                        .foregroundStyle(selectedType == goodsType ? .lightBg : .white.opacity(0.0001))
                                    Text(goodsType.name)
                                        .font(selectedType == goodsType ? .headline : .subheadline)
                                        .foregroundStyle(selectedType == goodsType ? .darkBg : Color.gray)
                                        .padding(.leading)
                                    
                                    if let count = viewModel.typeCountDict[goodsType]{
                                        if(count > 0){
                                            Text("\(count)")
                                                .foregroundStyle(.white)
                                                .font(.caption)
                                                .padding(4)
                                                .background(.button)
                                                .clipShape(Circle())
                                                .padding(.leading, 60)
                                                .padding(.bottom, 30)
                                        }
                                    }
                                }
                                .frame(height: 76)                            .onTapGesture(perform: {
                                    self.selectedType = goodsType
                                    self.lastTapTime = Date().timeIntervalSince1970
                                    withAnimation{
                                        if(goodsType.type == 100){
                                            self.scrollID = "banner"
                                        }else{
                                            if let goodsModel = viewModel.typeFirstDict[goodsType.type]{
                                                self.scrollID = goodsModel._id
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                    .frame(width: .minimum(180, .maximum(88, screenWidth / 6)))
                    .background(Color.categoryBg)
                    .scrollIndicators(.hidden)
                    
                    ScrollView{
                        LazyVStack(alignment: .leading, spacing: 0){
                            
                            ZStack(alignment: .bottom){
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .overlay{
                                        GeometryReader{ geo in
                                            LazyImage(url: URL(string: imageUrl)){state in
                                                state.image?
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                            .onAppear(perform: {
                                                let frame = geo.frame(in: .scrollView)
                                                self.bannerHeight = Float( frame.origin.x * 2 + geo.size.height)
                                                self.itemHeight = 112 + Float(frame.origin.x)
                                                print(bannerHeight)
                                                print(itemHeight)
                                            })
                                        }
                                    }
                                Text("猫寻小布偶")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.3))
                            }
                            .clipShape(.rect(cornerRadius: 16))
                            .padding(.horizontal)
                            .padding(.top)
                            .id("banner")
                            
                            ForEach(viewModel.goodsList, id: \._id) {goods in
                                GoodsRow(goods: goods, cartDict: $viewModel.cartDict, addToCart: {param1, param2 in
                                    viewModel.addToCart(goods: param1, count: param2)
                                })
                                .padding(.horizontal)
                                .padding(.top)
                            }
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 6)
                                .padding(.top)
                        }
                        .background(
                            GeometryReader { inner in
                                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: inner.frame(in: .scrollView).origin.y)
                            }
                        )
                        
                    }
                    .frame(maxWidth: .infinity)
                    .scrollPosition(id: $scrollID)
                    .id("goodsScrollView")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { newOffset in
                        //                        print("Scroll offset: \(newOffset)")
                        if Date().timeIntervalSince1970 - self.lastTapTime < 0.5{
                            return
                        }
                        let potentialIndex = (0 - Float(newOffset) - bannerHeight) / itemHeight + 1
                        if potentialIndex.isFinite {
                            var index = Int(potentialIndex)
                            print(index)
                            if index < 0{
                                index = 0
                            }
                            
                            if index < viewModel.goodsList.count{
                                let goodsType = viewModel.goodsList[index].typeModel
                                if(goodsType != selectedType){
                                    selectedType = goodsType
                                    print("scroll to \(goodsType.name)")
                                }
                            }
                        } else {
                            print("Invalid index: \(potentialIndex)")
                        }
                    }
                }
                
                if showSearch{
                    VStack(spacing: 0){
                        HStack{
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                TextField("商品关键字", text: $searchKey)
                                    .foregroundStyle(.secondary)
                                    .submitLabel(.search)
                                    .onSubmit {
                                        
                                    }
                            }
                            .padding()
                            .background(.inputBg)
                            .clipShape(.rect(cornerRadius: 10))
                            
                            Image(systemName: "xmark")
                                .onTapGesture {
                                    showSearch = false
                                }
                        }
                        .padding()
                        
                        ScrollView{
                            LazyVStack(alignment: .leading, spacing: 0){
                                ScrollView(.horizontal){
                                    HStack(spacing: 16){
                                        ForEach(viewModel.searchHints, id: \.key){ key in
                                            Text(key.key)
                                                .foregroundStyle(.secondary)
                                                .padding(.horizontal)
                                                .padding(.vertical, 6)
                                                .background(.inputBg)
                                                .clipShape(.rect(cornerRadius: 10))
                                                .onTapGesture {
                                                    self.searchKey = key.value
                                                }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                ForEach(viewModel.goodsList.filter({
                                    !searchKey.isEmpty && $0.name.contains(searchKey)
                                }), id: \._id) {goods in
                                    GoodsRow(goods: goods, cartDict: $viewModel.cartDict, addToCart: {param1, param2 in
                                        viewModel.addToCart(goods: param1, count: param2)
                                    })
                                    .padding(.horizontal)
                                    .padding(.top)
                                }
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(height: 6)
                                    .padding(.top)
                            }
                        }
                    }
                    .background(Color.searchBg)
                    .transition(.moveFromTopAndFade)
                }
                
                if showCart{
                    Rectangle()
                        .foregroundStyle(.black.opacity(0.5))
                        .onTapGesture {
                            showCart = false
                        }
                    VStack{
                        Spacer()
                        VStack(spacing: 0){
                            HStack{
                                Button(action: {
                                    viewModel.clearCart()
                                    showCart = false
                                }, label: {
                                    Text("清空购物车")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .padding(.vertical, 8)
                                })
                                
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Text("分享购物车")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .padding(.vertical, 8)
                                })
                            }
                            .padding(.horizontal)
                            .background(.regularMaterial)
                            Divider()
                            ScrollView(){
                                VStack(spacing: 0){
                                    Rectangle()
                                        .foregroundStyle(.clear)
                                        .frame(height: 0)
                                        .padding(.bottom)
                                    ForEach(viewModel.goodsList.filter({
                                        viewModel.cartDict[$0] != nil &&   viewModel.cartDict[$0]! > 0
                                    }), id: \._id){ goods in
                                        GoodsRow(rowHeight: 80, goods: goods, cartDict: $viewModel.cartDict, addToCart: { p1, p2 in
                                            viewModel.addToCart(goods: p1, count: p2)
                                        })
                                        .onTapGesture {
                                            withAnimation{
                                                scrollID = goods._id
                                            }
                                        }
                                        .padding(.bottom)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .frame(height: 330)
                            
                        }
                        .background(.lightBg)
                        .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 16))
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.spring(duration: 2), value: showCart)
                }
            }
            
            Divider()
            HStack(spacing: 0){
                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.button)
                    .padding(.leading)
                    .padding(.leading, 6)
                    .onTapGesture {
                        toggleCart()
                    }
                Text("\(viewModel.goodsCount)")
                    .foregroundStyle(.white)
                    .font(.custom("cartCount", size: 14))
                    .padding(viewModel.goodsCount > 9 ? 5: 7)
                    .background(.button)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(.white, lineWidth: 1)
                    )
                    .frame(minWidth: 32)
                    .frame(minHeight: 32)
                    .padding(.leading, -12)
                    .padding(.trailing, 8)
                    .padding(.bottom, 24)
                    .opacity(viewModel.goodsCount > 0 ? 1 : 0)
                    .onTapGesture {
                        toggleCart()
                    }
                VStack(alignment: .leading){
                    HStack(alignment: .bottom, spacing: 4){
                        Text("¥")
                            .font(.subheadline)
                        Text("\(Float(viewModel.goodsAmount) / 100.0, specifier: "%g")")
                            .font(.title3)
                            .bold()
                    }.foregroundStyle(.price)
                    Text("5 公里闪送，满100包邮")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                
                NavigationLink(destination: PreviewOrderView(goodsList: viewModel.cartToGoodsIds(), goodsAmount: viewModel.goodsAmount), label: {
                    
                    Text("去结算")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(10)
                        .background(.button)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal)
                })
                .opacity(viewModel.goodsCount == 0 ? 0.6 : 1)
                .disabled(viewModel.goodsCount == 0)
            }
            .frame(maxWidth: .infinity)
            .background(.lightBg)
        }
        .navigationTitle("猫寻小店")
        .toolbar(content: {
            Button(action: {
                if showSearch {
                    showSearch.toggle()
                }else{
                    withAnimation{
                        showSearch.toggle()
                    }
                }
            }, label: {
                Image("ic_magnifying")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            })
            
            
            Button(action: {
                
            }, label: {
                HStack(spacing: 2){
                    Image("ic_order")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                    Text("订\n单")
                        .lineLimit(2)
                        .font(.custom("order", size: 10))
                        .foregroundStyle(.orderGray)
                }
            })
        })
        .toolbarBackground(Color("shopColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear(perform: {
            if(viewModel.goodsList.isEmpty){
                viewModel.getGoodsList()
            }
        })
    }
    
    func toggleCart(){
        if showCart {
            showCart.toggle()
        }else{
            withAnimation(.easeOut(duration: 0.3)) {
                showCart.toggle()
            }
        }
    }
    
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    ShopView(viewModel: ShopVM())
}
