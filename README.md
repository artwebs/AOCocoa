###  二维码编码使用
```
DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:info];
UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:250];
```


