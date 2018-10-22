# EmojiKeyBoard
Emoji KeyBoard  使用UICollectionview实现，支持颜文字  emoji

1. 使用UICollectionView实现
2. 不同表情类别大小不一样
3. 文字表情添加分割线
4. keyboard协议和代理

---
技术难点总结： 
1. 如何计算每个cell大小（不同emoji种类大小不一样）
2. 如何根据indexpath 计算对应数据源中的itemModel
3. 分割线绘制
4. 键盘view的协议与委托封装
