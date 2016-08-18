
## About
为了能在iPad中使用ActionSheet, 因此仿写了UIAlertController.

![image](https://github.com/Chakery/CGYAlertController/blob/master/CGYAlertExample/Screenshot/1.gif)

## Using

```
// Alert
CGYAlertController(title: "提示", message: "这是一个简单的提示", preferredStyle: .Alert, actions:
    CGYAlertAction(title: "取消", style: .Cancel),
    CGYAlertAction(title: "确定", style: .Default) { action in
        print(action.title)
    }
).show()

// ActionSheet
CGYAlertController(title: "问题", message: "马x去了哪里?", preferredStyle: .ActionSheet, actions:
  CGYAlertAction(title: "中国", style: .Default) { action in
      print(action.title)
  },
  CGYAlertAction(title: "美国", style: .Default) { action in
      print(action.title)
  },
  CGYAlertAction(title: "日本", style: .Default) { action in
      print(action.title)
  },
  CGYAlertAction(title: "新加坡", style: .Default) { action in
      print(action.title)
  },
  CGYAlertAction(title: "取消", style: .Cancel)
).show()
```
