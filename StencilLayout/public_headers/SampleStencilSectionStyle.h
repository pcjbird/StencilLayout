/**
 *@brief 模版配置文件示例
 *
 *@filename SampleStencilSectionStyle.json
 *@project  StencilLayout
 *
 *Created by pcjbird on 2016/11/8.
 *Copyright © 2016年 Zero Status. All rights reserved.
 */

/*
 //*************************************************示例json**************************************************************************
{
    "i1":
    {
        "style-id":"i1",
        "comment":"Banner广告位",
        "section-margin-top":0,
        "section-margin-left":0,
        "section-margin-bottom":0,
        "section-margin-right":0,
        "content-margin-top":0,
        "content-margin-left":0,
        "content-margin-bottom":0,
        "content-margin-right":0,
        "background":"#ffffff",
        "maxitems":1,
        "item-merge-layout":true,
        "start-version":"6.0.0",
        "item-styles":
        [
         {"widthType":0, "fixedWidth":0, "widthRatio":1, "heightType":0, "fixedHeight":0, "heightRatioBaseWidth": 0.69, "defaultLayoutType":3}
         ],
    },
    "i2":
    {
        "style-id":"i2",
        "comment":"快捷入口",
        "section-margin-top":0,
        "section-margin-left":0,
        "section-margin-bottom":0,
        "section-margin-right":0,
        "content-margin-top":0,
        "content-margin-left":0,
        "content-margin-bottom":0,
        "content-margin-right":0,
        "background":"#ffffff",
        "maxitems":8,
        "item-merge-layout":true,
        "item-styles":
        [
         {"widthType":0, "fixedWidth":0, "widthRatio":1, "heightType":0, "fixedHeight":0, "heightRatioBaseWidth": 0.18, "defaultLayoutType":4}
         ],
    }
}



 //*************************************************注释说明**************************************************************************
{
    "i1":                                           //模版样式编号
    {
        "style-id":"i1",                            //模版样式编号
        "comment":"Banner广告位",                    //模版样式备注说明
        "section-margin-top":0,                     //模版上边距
        "section-margin-left":0,                    //模版左边距
        "section-margin-bottom":0,                  //模版下边距
        "section-margin-right":0,                   //模版右边距
        "content-margin-top":0,                     //模版项上边距
        "content-margin-left":0,                    //模版项左边距
        "content-margin-bottom":0,                  //模版项下边距
        "content-margin-right":0,                   //模版项右边距
        "background":"#ffffff",                     //模版背景色
        "maxitems":1,                               //模版项最大数量，0代表无限
        "item-merge-layout":true,                   //模版项是否合并
        "heightType":0                              //高度类型 0，默认,auto,由模版系统自动计算   1，高度交给模块自己计算
        "option-additional-height":0,               //可选，附加固定高度，针对类似pagecontrol等或有或无的高度部分
        "start-version":"6.0.0",                    //APP起始生效版本，不配则所有版本有效
        "item-styles":
        [
         {
             "widthType":0,                     //模版项宽度类型 0，比例 1，固定
             "fixedWidth":0,                    //模版项固定宽度   当widthType == 1时有效
             "widthRatio":1,                    //模版项宽度比例   当widthType == 0时有效
             "heightType":0,                    //模版项高度类型 0，比例 1，固定  2,自定义
             "fixedHeight":0,                   //模版项固定高度   当heightType == 1时有效
             "heightRatioBaseWidth": 0.69,      //模版项高宽比     当heightType == 0时有效
             "option-additional-height":0,      //可选，Cell附加固定高度
             "defaultLayoutType":3              //模版项默认布局类型
         }
         ],
    },
    
    //i2,i3,i4......
}
 */
