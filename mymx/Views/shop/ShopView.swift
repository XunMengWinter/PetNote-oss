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

    var body: some View {
        VStack(spacing: 0) {

            ZStack {
                // ① 主体：左分类 + 右商品列表
                ShopMainSplitView(
                    imageUrl: imageUrl,
                    viewModel: viewModel,
                    selectedType: $selectedType,
                    scrollID: $scrollID,
                    bannerHeight: $bannerHeight,
                    itemHeight: $itemHeight,
                    lastTapTime: $lastTapTime
                )

                // ② 浮层：Search + Cart
                ShopOverlaysView(
                    viewModel: viewModel,
                    showSearch: $showSearch,
                    searchKey: $searchKey,
                    showCart: $showCart,
                    scrollID: $scrollID
                )
            }

            Divider()

            // ③ 底部结算栏
            ShopBottomBarView(viewModel: viewModel) {
                toggleCart()
            }
            .background(.lightBg)
        }
        .navigationTitle("猫寻小店")
        .toolbar {
            Button {
                if showSearch {
                    showSearch.toggle()
                } else {
                    withAnimation { showSearch.toggle() }
                }
            } label: {
                Image("ic_magnifying")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }

            Button {
                // TODO: 订单入口
            } label: {
                HStack(spacing: 2) {
                    Image("ic_order")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                    Text("订\n单")
                        .lineLimit(2)
                        .font(.custom("order", size: 10))
                        .foregroundStyle(.orderGray)
                }
            }
        }
        .toolbarBackground(Color("shopColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            if viewModel.goodsList.isEmpty {
                viewModel.getGoodsList()
            }
        }
    }

    private func toggleCart() {
        if showCart {
            showCart.toggle()
        } else {
            withAnimation(.easeOut(duration: 0.3)) {
                showCart.toggle()
            }
        }
    }
}

// MARK: - ① 主体：左分类 + 右商品列表
private struct ShopMainSplitView: View {
    let imageUrl: String
    @ObservedObject var viewModel: ShopVM

    @Binding var selectedType: GoodsTypeModel
    @Binding var scrollID: String?

    @Binding var bannerHeight: Float
    @Binding var itemHeight: Float
    @Binding var lastTapTime: Double

    private let screenWidth = UIScreen.main.bounds.size.width

    var body: some View {
        HStack(spacing: 0) {

            // Left: 分类
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.goodsTypes) { goodsType in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundStyle(selectedType == goodsType ? .lightBg : .white.opacity(0.0001))

                            Text(goodsType.name)
                                .font(selectedType == goodsType ? .headline : .subheadline)
                                .foregroundStyle(selectedType == goodsType ? .darkBg : Color.gray)
                                .padding(.leading)

                            if let count = viewModel.typeCountDict[goodsType], count > 0 {
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
                        .frame(height: 76)
                        .onTapGesture {
                            selectedType = goodsType
                            lastTapTime = Date().timeIntervalSince1970
                            withAnimation {
                                if goodsType.type == 100 {
                                    scrollID = "banner"
                                } else if let goodsModel = viewModel.typeFirstDict[goodsType.type] {
                                    scrollID = goodsModel._id
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: min(180, max(88, screenWidth / 6)))
            .background(Color.categoryBg)
            .scrollIndicators(.hidden)

            // Right: 商品列表
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {

                    // Banner
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay {
                                GeometryReader { geo in
                                    LazyImage(url: URL(string: imageUrl)) { state in
                                        state.image?
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .onAppear {
                                        let frame = geo.frame(in: .scrollView)
                                        bannerHeight = Float(frame.origin.x * 2 + geo.size.height)
                                        itemHeight = 112 + Float(frame.origin.x)
                                        print(bannerHeight)
                                        print(itemHeight)
                                    }
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

                    // Goods
                    ForEach(viewModel.goodsList, id: \._id) { goods in
                        GoodsRow(
                            goods: goods,
                            cartDict: $viewModel.cartDict,
                            addToCart: { p1, p2 in
                                viewModel.addToCart(goods: p1, count: p2)
                            }
                        )
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
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: inner.frame(in: .scrollView).origin.y
                        )
                    }
                )
            }
            .frame(maxWidth: .infinity)
            .scrollPosition(id: $scrollID)
            .id("goodsScrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { newOffset in
                // 防止点击触发的滚动回调误更新 selectedType
                if Date().timeIntervalSince1970 - lastTapTime < 0.5 { return }

                let potentialIndex = (0 - Float(newOffset) - bannerHeight) / itemHeight + 1
                if potentialIndex.isFinite {
                    var index = Int(potentialIndex)
                    if index < 0 { index = 0 }

                    if index < viewModel.goodsList.count {
                        Task {
                            let goodsType = await viewModel.goodsList[index].typeModelAsync()
                            if goodsType != selectedType {
                                selectedType = goodsType
                                print("scroll to \(goodsType.name)")
                            }
                        }
                    }
                } else {
                    print("Invalid index: \(potentialIndex)")
                }
            }
        }
    }
}

// MARK: - ② 浮层：Search + Cart
private struct ShopOverlaysView: View {
    @ObservedObject var viewModel: ShopVM

    @Binding var showSearch: Bool
    @Binding var searchKey: String
    @Binding var showCart: Bool
    @Binding var scrollID: String?

    var body: some View {
        ZStack {
            if showSearch {
                searchOverlay
                    .transition(.moveFromTopAndFade)
            }

            if showCart {
                cartOverlay
                    .transition(.move(edge: .bottom))
                    .animation(.spring(duration: 2), value: showCart)
            }
        }
    }

    private var searchOverlay: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("商品关键字", text: $searchKey)
                        .foregroundStyle(.secondary)
                        .submitLabel(.search)
                        .onSubmit {
                            // TODO: submit search
                        }
                }
                .padding()
                .background(.inputBg)
                .clipShape(.rect(cornerRadius: 10))

                Image(systemName: "xmark")
                    .onTapGesture { showSearch = false }
            }
            .padding()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {

                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.searchHints, id: \.key) { key in
                                Text(key.key)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background(.inputBg)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .onTapGesture {
                                        searchKey = key.value
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)

                    ForEach(viewModel.goodsList.filter {
                        !searchKey.isEmpty && $0.name.contains(searchKey)
                    }, id: \._id) { goods in
                        GoodsRow(
                            goods: goods,
                            cartDict: $viewModel.cartDict,
                            addToCart: { p1, p2 in
                                viewModel.addToCart(goods: p1, count: p2)
                            }
                        )
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
    }

    private var cartOverlay: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black.opacity(0.5))
                .onTapGesture { showCart = false }

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    HStack {
                        Button {
                            viewModel.clearCart()
                            showCart = false
                        } label: {
                            Text("清空购物车")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        }

                        Spacer()

                        Button {
                            // TODO: 分享购物车
                        } label: {
                            Text("分享购物车")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                    .background(.regularMaterial)

                    Divider()

                    ScrollView {
                        VStack(spacing: 0) {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 0)
                                .padding(.bottom)

                            ForEach(viewModel.goodsList.filter {
                                viewModel.cartDict[$0] != nil && viewModel.cartDict[$0]! > 0
                            }, id: \._id) { goods in
                                GoodsRow(
                                    rowHeight: 80,
                                    goods: goods,
                                    cartDict: $viewModel.cartDict,
                                    addToCart: { p1, p2 in
                                        viewModel.addToCart(goods: p1, count: p2)
                                    }
                                )
                                .onTapGesture {
                                    withAnimation {
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
        }
    }
}

// MARK: - ③ 底部结算栏
private struct ShopBottomBarView: View {
    @ObservedObject var viewModel: ShopVM
    let onToggleCart: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "cart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(.button)
                .padding(.leading)
                .padding(.leading, 6)
                .onTapGesture { onToggleCart() }

            Text("\(viewModel.goodsCount)")
                .foregroundStyle(.white)
                .font(.custom("cartCount", size: 14))
                .padding(viewModel.goodsCount > 9 ? 5 : 7)
                .background(.button)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.white, lineWidth: 1))
                .frame(minWidth: 32, minHeight: 32)
                .padding(.leading, -12)
                .padding(.trailing, 8)
                .padding(.bottom, 24)
                .opacity(viewModel.goodsCount > 0 ? 1 : 0)
                .onTapGesture { onToggleCart() }

            VStack(alignment: .leading) {
                HStack(alignment: .bottom, spacing: 4) {
                    Text("¥").font(.subheadline)
                    Text("\(Float(viewModel.goodsAmount) / 100.0, specifier: "%g")")
                        .font(.title3)
                        .bold()
                }
                .foregroundStyle(.price)

                Text("5 公里闪送，满100包邮")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            NavigationLink(
                destination: PreviewOrderView(
                    goodsList: viewModel.cartToGoodsIds(),
                    goodsAmount: viewModel.goodsAmount
                )
            ) {
                Text("去结算")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(10)
                    .background(.button)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.horizontal)
            }
            .opacity(viewModel.goodsCount == 0 ? 0.6 : 1)
            .disabled(viewModel.goodsCount == 0)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - PreferenceKey
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    ShopView(viewModel: ShopVM())
}
