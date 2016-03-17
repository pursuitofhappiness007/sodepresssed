提交订单后{
    result=0,
    data={
        order_info={
            is_wechat=0,
            marketName=东莞大岭山农批,
            id=317,
            paymentAmount=18,
            orderCode=OD20160317180433
        },
        wechat_param={
            a=b
        }
    }
}
    
    单个订单
    {
        "fatherHeader": {
            "id": 321,
            "address": "广发路2号",
            "businessStatus": 2,
            "marketName": "东莞大岭山农批",
            "marketId": 44,
            "orderCode": "OD20160317190437",
            "payMode": "BA",
            "paymentAmount": 216,
            "buyerRemark": "1",
            "consigneeTel1": "18682419999",
            "businessStatusName": "待发货"
        },
        "sonOrderList": [
                         {
                             "orderDetailList": [
                                                 {
                                                     "goodsId": 1,
                                                     "goodsName": "测试商品",
                                                     "frontPrice": 9,
                                                     "frontQuantity": 0,
                                                     "frontWeight": 2,
                                                     "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                 }
                                                 ],
                             "orderHeader": {
                                 "id": 322,
                                 "address": "广发路2号",
                                 "businessStatus": 2,
                                 "marketName": "东莞大岭山农批",
                                 "marketId": 44,
                                 "orderCode": "OD20160317190438",
                                 "payMode": "BA",
                                 "paymentAmount": 18,
                                 "buyerRemark": "1",
                                 "consigneeTel1": "18682419999",
                                 "businessStatusName": "待发货"
                             }
                         },
                         {
                             "orderDetailList": [
                                                 {
                                                     "goodsId": 2,
                                                     "goodsName": "测试",
                                                     "frontPrice": 99,
                                                     "frontQuantity": 2,
                                                     "frontWeight": 44,
                                                     "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                 }
                                                 ],
                             "orderHeader": {
                                 "id": 323,
                                 "address": "广发路2号",
                                 "businessStatus": 2,
                                 "marketName": "东莞大岭山农批",
                                 "marketId": 44,
                                 "orderCode": "OD20160317190439",
                                 "payMode": "BA",
                                 "paymentAmount": 198,
                                 "buyerRemark": "1",
                                 "consigneeTel1": "18682419999",
                                 "businessStatusName": "待发货"
                             }
                         }
                         ]
    }

获取订单列表
    {
        "result": 0,
        "data": {
            "user_order_menu": {
                "0": "待付款",
                "2": "待发货",
                "6": "待收货",
                "8": "已完成",
                "-1": "已取消",
                "-2": "无效订单"
            },
            "page": {
                "page_no": 1,
                "page_size": 10,
                "totalRows": 17
            },
            "order_list": [
                           {
                               "fatherHeader": {
                                   "id": 321,
                                   "address": "广发路2号",
                                   "businessStatus": 2,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317190437",
                                   "payMode": "BA",
                                   "paymentAmount": 216,
                                   "buyerRemark": "1",
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "待发货"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 1,
                                                                            "goodsName": "测试商品",
                                                                            "frontPrice": 9,
                                                                            "frontQuantity": 0,
                                                                            "frontWeight": 2,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 322,
                                                        "address": "广发路2号",
                                                        "businessStatus": 2,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317190438",
                                                        "payMode": "BA",
                                                        "paymentAmount": 18,
                                                        "buyerRemark": "1",
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                },
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 2,
                                                                            "goodsName": "测试",
                                                                            "frontPrice": 99,
                                                                            "frontQuantity": 2,
                                                                            "frontWeight": 44,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 323,
                                                        "address": "广发路2号",
                                                        "businessStatus": 2,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317190439",
                                                        "payMode": "BA",
                                                        "paymentAmount": 198,
                                                        "buyerRemark": "1",
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 317,
                                   "address": "广发路2号",
                                   "businessStatus": 2,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317180433",
                                   "payMode": "BA",
                                   "paymentAmount": 18,
                                   "buyerRemark": "1",
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "待发货"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 1,
                                                                            "goodsName": "测试商品",
                                                                            "frontPrice": 9,
                                                                            "frontQuantity": 0,
                                                                            "frontWeight": 2,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 318,
                                                        "address": "广发路2号",
                                                        "businessStatus": 2,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317180434",
                                                        "payMode": "BA",
                                                        "paymentAmount": 18,
                                                        "buyerRemark": "1",
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 315,
                                   "address": "广发路2号",
                                   "businessStatus": 2,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317180431",
                                   "payMode": "BA",
                                   "paymentAmount": 18,
                                   "buyerRemark": "1",
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "待发货"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 1,
                                                                            "goodsName": "测试商品",
                                                                            "frontPrice": 9,
                                                                            "frontQuantity": 0,
                                                                            "frontWeight": 2,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 316,
                                                        "address": "广发路2号",
                                                        "businessStatus": 2,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317180432",
                                                        "payMode": "BA",
                                                        "paymentAmount": 18,
                                                        "buyerRemark": "1",
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 313,
                                   "address": "广发路2号",
                                   "businessStatus": -1,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317170429",
                                   "payMode": "BA",
                                   "paymentAmount": 18,
                                   "buyerRemark": "1",
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "订单取消"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 1,
                                                                            "goodsName": "测试商品",
                                                                            "frontPrice": 9,
                                                                            "frontQuantity": 0,
                                                                            "frontWeight": 2,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 314,
                                                        "address": "广发路2号",
                                                        "businessStatus": -1,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317170430",
                                                        "payMode": "BA",
                                                        "paymentAmount": 18,
                                                        "buyerRemark": "1",
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "订单取消"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 311,
                                   "address": "广发路2号",
                                   "businessStatus": 2,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317110427",
                                   "payMode": "BA",
                                   "paymentAmount": 693,
                                   "buyerRemark": null,
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "待发货"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 2,
                                                                            "goodsName": "测试",
                                                                            "frontPrice": 99,
                                                                            "frontQuantity": 7,
                                                                            "frontWeight": 154,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 312,
                                                        "address": "广发路2号",
                                                        "businessStatus": 2,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317110428",
                                                        "payMode": "BA",
                                                        "paymentAmount": 693,
                                                        "buyerRemark": null,
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 309,
                                   "address": "广发路2号",
                                   "businessStatus": 2,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317110425",
                                   "payMode": "BA",
                                   "paymentAmount": 693,
                                   "buyerRemark": null,
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "待发货"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 2,
                                                                            "goodsName": "测试",
                                                                            "frontPrice": 99,
                                                                            "frontQuantity": 7,
                                                                            "frontWeight": 154,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 310,
                                                        "address": "广发路2号",
                                                        "businessStatus": 2,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317110426",
                                                        "payMode": "BA",
                                                        "paymentAmount": 693,
                                                        "buyerRemark": null,
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 307,
                                   "address": "广发路2号",
                                   "businessStatus": -1,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317110423",
                                   "payMode": "BA",
                                   "paymentAmount": 693,
                                   "buyerRemark": null,
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "订单取消"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 2,
                                                                            "goodsName": "测试",
                                                                            "frontPrice": 99,
                                                                            "frontQuantity": 7,
                                                                            "frontWeight": 154,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 308,
                                                        "address": "广发路2号",
                                                        "businessStatus": -1,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317110424",
                                                        "payMode": "BA",
                                                        "paymentAmount": 693,
                                                        "buyerRemark": null,
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "订单取消"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 305,
                                   "address": "广发路2号",
                                   "businessStatus": -1,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317110421",
                                   "payMode": "BA",
                                   "paymentAmount": 693,
                                   "buyerRemark": null,
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "订单取消"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 2,
                                                                            "goodsName": "测试",
                                                                            "frontPrice": 99,
                                                                            "frontQuantity": 7,
                                                                            "frontWeight": 154,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 306,
                                                        "address": "广发路2号",
                                                        "businessStatus": -1,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317110422",
                                                        "payMode": "BA",
                                                        "paymentAmount": 693,
                                                        "buyerRemark": null,
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "订单取消"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 298,
                                   "address": "广发路2号",
                                   "businessStatus": -1,
                                   "marketName": "东莞大岭山农批",
                                   "marketId": 44,
                                   "orderCode": "OD20160317100414",
                                   "payMode": "BA",
                                   "paymentAmount": 0,
                                   "buyerRemark": null,
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "订单取消"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 2,
                                                                            "goodsName": "测试",
                                                                            "frontPrice": 99,
                                                                            "frontQuantity": 0,
                                                                            "frontWeight": 12,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 299,
                                                        "address": "广发路2号",
                                                        "businessStatus": -1,
                                                        "marketName": "东莞大岭山农批",
                                                        "marketId": 44,
                                                        "orderCode": "OD20160317100415",
                                                        "payMode": "BA",
                                                        "paymentAmount": 0,
                                                        "buyerRemark": null,
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "订单取消"
                                                    }
                                                }
                                                ]
                           },
                           {
                               "fatherHeader": {
                                   "id": 273,
                                   "address": "街口路东5巷-1号",
                                   "businessStatus": 2,
                                   "marketName": "小哥菜市场",
                                   "marketId": 40,
                                   "orderCode": "OD20160316160389",
                                   "payMode": "BA",
                                   "paymentAmount": 2400,
                                   "buyerRemark": "henhaohenhao",
                                   "consigneeTel1": "18682419999",
                                   "businessStatusName": "待发货"
                               },
                               "sonOrderList": [
                                                {
                                                    "orderDetailList": [
                                                                        {
                                                                            "goodsId": 4,
                                                                            "goodsName": "大白菜",
                                                                            "frontPrice": 200,
                                                                            "frontQuantity": 0,
                                                                            "frontWeight": 12,
                                                                            "goodsPic": "http://192.168.199.50:8870/images/no_picture.png"
                                                                        }
                                                                        ],
                                                    "orderHeader": {
                                                        "id": 274,
                                                        "address": "街口路东5巷-1号",
                                                        "businessStatus": 2,
                                                        "marketName": "小哥菜市场",
                                                        "marketId": 40,
                                                        "orderCode": "OD20160316160390",
                                                        "payMode": "BA",
                                                        "paymentAmount": 2400,
                                                        "buyerRemark": "henhaohenhao",
                                                        "consigneeTel1": "18682419999",
                                                        "businessStatusName": "待发货"
                                                    }
                                                }
                                                ]
                           }
                           ]
        }
    }