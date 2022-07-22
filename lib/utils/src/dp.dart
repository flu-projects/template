part of utils;

final dp = _DesignSizes();
// w
double get width => () {
      if (!Device.isMobileWeb && Device.isWeb) {
        return (height * 375) / (812 - statusBarHeight);
      } else {
        return _width;
      }
    }();
double get _width => ScreenUtil.getInstance().screenWidth;
// h
double get height => ScreenUtil.getInstance().screenHeight;

double get statusBarHeight => ScreenUtil.getInstance().statusBarHeight;
double get bottomBarHeight => ScreenUtil.getInstance().bottomBarHeight;

extension IntDp on double {
  double _getWidth(double size) {
    if (Device.isWeb && !Device.isMobileWeb) {
      return (ScreenUtil.getInstance().screenHeight / 812) * size;
    } else {
      return ScreenUtil.getInstance().getWidth(size);
    }
  }

  double _getSp(double size) {
    if (Device.isWeb && !Device.isMobileWeb) {
      return (ScreenUtil.getInstance().screenHeight / 812) * size;
    } else {
      return ScreenUtil.getInstance().getSp(size);
    }
  }

  double get dp {
    return _getWidth(toDouble());
  }

  double get sp {
    return _getSp(toDouble());
  }
}

class _DesignSizes {
  final d1 = 1.0.dp;
  final d2 = 2.0.dp;
  final d3 = 3.0.dp;
  final d4 = 4.0.dp;
  final d5 = 5.0.dp;
  final d6 = 6.0.dp;
  final d7 = 7.0.dp;
  final d8 = 8.0.dp;
  final d9 = 9.0.dp;
  final d10 = 10.0.dp;
  final d11 = 11.0.dp;
  final d12 = 12.0.dp;
  final d13 = 13.0.dp;
  final d14 = 14.0.dp;
  final d15 = 15.0.dp;
  final d16 = 16.0.dp;
  final d17 = 17.0.dp;
  final d18 = 18.0.dp;
  final d19 = 19.0.dp;
  final d20 = 20.0.dp;
  final d21 = 21.0.dp;
  final d22 = 22.0.dp;
  final d23 = 23.0.dp;
  final d24 = 24.0.dp;
  final d25 = 25.0.dp;
  final d26 = 26.0.dp;
  final d27 = 27.0.dp;
  final d28 = 28.0.dp;
  final d29 = 29.0.dp;
  final d30 = 30.0.dp;
  final d31 = 31.0.dp;
  final d32 = 32.0.dp;
  final d33 = 33.0.dp;
  final d34 = 34.0.dp;
  final d35 = 35.0.dp;
  final d36 = 36.0.dp;
  final d37 = 37.0.dp;
  final d38 = 38.0.dp;
  final d39 = 39.0.dp;
  final d40 = 40.0.dp;
  final d41 = 41.0.dp;
  final d42 = 42.0.dp;
  final d43 = 43.0.dp;
  final d44 = 44.0.dp;
  final d45 = 45.0.dp;
  final d46 = 46.0.dp;
  final d47 = 47.0.dp;
  final d48 = 48.0.dp;
  final d49 = 49.0.dp;
  final d50 = 50.0.dp;
  final d51 = 51.0.dp;
  final d52 = 52.0.dp;
  final d54 = 54.0.dp;
  final d55 = 55.0.dp;
  final d56 = 56.0.dp;
  final d57 = 57.0.dp;
  final d58 = 58.0.dp;
  final d59 = 59.0.dp;
  final d60 = 60.0.dp;
  final d61 = 61.0.dp;
  final d62 = 62.0.dp;
  final d63 = 63.0.dp;
  final d64 = 64.0.dp;
  final d65 = 65.0.dp;
  final d66 = 66.0.dp;
  final d68 = 68.0.dp;
  final d69 = 69.0.dp;
  final d70 = 70.0.dp;
  final d72 = 72.0.dp;
  final d73 = 73.0.dp;
  final d74 = 74.0.dp;
  final d75 = 75.0.dp;
  final d76 = 76.0.dp;
  final d77 = 77.0.dp;
  final d78 = 78.0.dp;
  final d79 = 79.0.dp;
  final d80 = 80.0.dp;
  final d81 = 81.0.dp;
  final d82 = 82.0.dp;
  final d84 = 84.0.dp;
  final d85 = 85.0.dp;
  final d86 = 86.0.dp;
  final d87 = 87.0.dp;
  final d88 = 88.0.dp;
  final d90 = 90.0.dp;
  final d92 = 92.0.dp;
  final d94 = 94.0.dp;
  final d95 = 95.0.dp;
  final d96 = 96.0.dp;
  final d98 = 98.0.dp;
  final d99 = 99.0.dp;
  final d100 = 100.0.dp;
  final d102 = 102.0.dp;
  final d103 = 103.0.dp;
  final d104 = 104.0.dp;
  final d105 = 105.0.dp;
  final d106 = 106.0.dp;
  final d107 = 107.0.dp;
  final d108 = 108.0.dp;
  final d109 = 109.0.dp;
  final d110 = 110.0.dp;
  final d111 = 111.0.dp;
  final d112 = 112.0.dp;
  final d113 = 113.0.dp;
  final d114 = 114.0.dp;
  final d115 = 115.0.dp;
  final d116 = 116.0.dp;
  final d117 = 117.0.dp;
  final d118 = 118.0.dp;
  final d120 = 120.0.dp;
  final d121 = 121.0.dp;
  final d122 = 122.0.dp;
  final d123 = 123.0.dp;
  final d124 = 124.0.dp;
  final d125 = 125.0.dp;
  final d126 = 126.0.dp;
  final d128 = 128.0.dp;
  final d129 = 129.0.dp;
  final d130 = 130.0.dp;
  final d132 = 132.0.dp;
  final d134 = 134.0.dp;
  final d135 = 135.0.dp;
  final d136 = 136.0.dp;
  final d137 = 137.0.dp;
  final d138 = 138.0.dp;
  final d139 = 139.0.dp;
  final d140 = 140.0.dp;
  final d141 = 141.0.dp;
  final d142 = 142.0.dp;
  final d144 = 144.0.dp;
  final d145 = 145.0.dp;
  final d146 = 146.0.dp;
  final d147 = 147.0.dp;
  final d150 = 150.0.dp;
  final d152 = 152.0.dp;
  final d154 = 154.0.dp;
  final d155 = 155.0.dp;
  final d156 = 156.0.dp;
  final d158 = 158.0.dp;
  final d160 = 160.0.dp;
  final d162 = 162.0.dp;
  final d164 = 164.0.dp;
  final d165 = 165.0.dp;
  final d166 = 166.0.dp;
  final d168 = 168.0.dp;
  final d170 = 170.0.dp;
  final d172 = 172.0.dp;
  final d174 = 174.0.dp;
  final d175 = 175.0.dp;
  final d176 = 176.0.dp;
  final d178 = 178.0.dp;
  final d179 = 179.0.dp;
  final d180 = 180.0.dp;
  final d182 = 182.0.dp;
  final d184 = 184.0.dp;
  final d186 = 186.0.dp;
  final d190 = 190.0.dp;
  final d192 = 192.0.dp;
  final d193 = 193.0.dp;
  final d194 = 194.0.dp;
  final d195 = 195.0.dp;
  final d197 = 197.0.dp;
  final d198 = 198.0.dp;
  final d199 = 199.0.dp;
  final d200 = 200.0.dp;
  final d204 = 204.0.dp;
  final d206 = 206.0.dp;
  final d208 = 208.0.dp;
  final d210 = 210.0.dp;
  final d211 = 211.0.dp;
  final d214 = 214.0.dp;
  final d218 = 218.0.dp;
  final d219 = 219.0.dp;
  final d220 = 220.0.dp;
  final d222 = 222.0.dp;
  final d224 = 224.0.dp;
  final d225 = 225.0.dp;
  final d228 = 228.0.dp;
  final d230 = 230.0.dp;
  final d232 = 232.0.dp;
  final d238 = 238.0.dp;
  final d240 = 240.0.dp;
  final d242 = 242.0.dp;
  final d243 = 243.0.dp;
  final d244 = 244.0.dp;
  final d246 = 246.0.dp;
  final d248 = 248.0.dp;
  final d250 = 250.0.dp;
  final d252 = 252.0.dp;
  final d254 = 254.0.dp;
  final d255 = 255.0.dp;
  final d257 = 257.0.dp;
  final d260 = 260.0.dp;
  final d263 = 263.0.dp;
  final d265 = 265.0.dp;
  final d267 = 267.0.dp;
  final d270 = 270.0.dp;
  final d275 = 275.0.dp;
  final d280 = 280.0.dp;
  final d283 = 283.0.dp;
  final d285 = 285.0.dp;
  final d287 = 287.0.dp;
  final d288 = 288.0.dp;
  final d296 = 296.0.dp;
  final d297 = 297.0.dp;
  final d300 = 300.0.dp;
  final d307 = 307.0.dp;
  final d308 = 308.0.dp;
  final d309 = 309.0.dp;
  final d310 = 310.0.dp;
  final d313 = 313.0.dp;
  final d314 = 314.0.dp;
  final d318 = 318.0.dp;
  final d319 = 319.0.dp;
  final d321 = 321.0.dp;
  final d326 = 326.0.dp;
  final d330 = 330.0.dp;
  final d332 = 332.0.dp;
  final d334 = 334.0.dp;
  final d335 = 335.0.dp;
  final d336 = 336.0.dp;
  final d340 = 340.0.dp;
  final d343 = 343.0.dp;
  final d345 = 345.0.dp;
  final d347 = 347.0.dp;
  final d348 = 348.0.dp;
  final d350 = 350.0.dp;
  final d351 = 351.0.dp;
  final d352 = 352.0.dp;
  final d356 = 356.0.dp;
  final d359 = 359.0.dp;
  final d360 = 360.0.dp;
  final d363 = 363.0.dp;
  final d370 = 370.0.dp;
  final d372 = 372.0.dp;
  final d375 = 375.0.dp;
  final d380 = 380.0.dp;
  final d388 = 388.0.dp;
  final d399 = 399.0.dp;
  final d400 = 400.0.dp;
  final d402 = 402.0.dp;
  final d411 = 411.0.dp;
  final d420 = 420.0.dp;
  final d436 = 436.0.dp;
  final d443 = 443.0.dp;
  final d460 = 460.0.dp;
  final d468 = 468.0.dp;
  final d480 = 480.0.dp;
  final d488 = 488.0.dp;
  final d494 = 494.0.dp;
  final d500 = 500.0.dp;
  final d524 = 524.0.dp;
  final d533 = 533.0.dp;
  final d544 = 544.0.dp;
  final d553 = 553.0.dp;
  final d558 = 558.0.dp;
  final d560 = 560.0.dp;
  final d580 = 580.0.dp;
  final d600 = 600.0.dp;
  final d618 = 618.0.dp;
  final d633 = 633.0.dp;
  final d640 = 640.0.dp;
  final d644 = 644.0.dp;
  final d672 = 672.0.dp;
  final d700 = 700.0.dp;
  final d744 = 744.0.dp;
  final d750 = 750.0.dp;
  final d840 = 840.0.dp;
  final d880 = 880.0.dp;
}
