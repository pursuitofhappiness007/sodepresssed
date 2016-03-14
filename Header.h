{
    "result": 0,
    "data": {
        "goods_list": [
                       {
                           "id": 21,      //商品id
                           "name": "测试商品",  //商品名称
                           "thumbnailImg": "http://localhost/b2v/public/images/no_picture.png",   //商品图片
                           "goodsId": 6,      //品类id
                           "goodsRangePrice": [  //区间价
                                               {
                                                   "addTime": null,
                                                   "addWho": null,
                                                   "editTime": null,
                                                   "editWho": null,
                                                   "goodsRelationId": 21,
                                                   "id": 43,
                                                   "maxNum": 20,
                                                   "minNum": 1,
                                                   "price": 90
                                               },
                                               {
                                                   "addTime": null,
                                                   "addWho": null,
                                                   "editTime": null,
                                                   "editWho": null,
                                                   "goodsRelationId": 21,
                                                   "id": 44,
                                                   "maxNum": 50, //为0时候代表，21以上
                                                   "minNum": 21,
                                                   "price": 80
                                               }
                                               ],
                           "marketId": 44,		//市场id
                           "num": 0,
                           "price": 100,      //商品价格
                           "salePriceType": 1,  //售价类型：0按单价，1按区间价
                           "specifications": "0",   //规格
                           "status": null  //状态: 0正常，1冻结，-1删除
                           "minNum": 1,     //起订数量
                           "maxNum": 10,    //限购数量
                           "startTime": null,  //售卖开始时间
                           "endTime": null,    //售卖截止时间
                           "supplierId": 8     //供应商id
                       }
                       ],
        "page": {
            "total_page": 1, //总页数
            "page_no": 1,    //当前页码
            "page_size": 5   //页码大小
        }
    }
}
