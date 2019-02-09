#!/bin/bash


TESTS="
window 1 hann
1 hann: nan
window 2 hann
2 hann: 0 0
window 3 hann
3 hann: 0 10000 0
window 10 hann
10 hann: 0 1170 4132 7500 9698 9698 7500 4132 1170 0
window 100 hann
100 hann: 0 10 40 90 160 250 358 485 631 794 974 1170 1381 1607 1847 2100 2364 2639 2923 3216 3515 3821 4132 4446 4762 5079 5396 5712 6024 6332 6635 6932 7220 7500 7770 8028 8274 8507 8726 8930 9118 9290 9444 9581 9698 9797 9877 9937 9977 9997 9997 9977 9937 9877 9797 9698 9581 9444 9290 9118 8930 8726 8507 8274 8028 7770 7500 7220 6932 6635 6332 6024 5712 5396 5079 4762 4446 4132 3821 3515 3216 2923 2639 2364 2100 1847 1607 1381 1170 974 794 631 485 358 250 160 90 40 10 0
window 1 boxcar
1 boxcar: 10000
window 2 boxcar
2 boxcar: 10000 10000
window 10 boxcar
10 boxcar: 10000 10000 10000 10000 10000 10000 10000 10000 10000 10000
window 1 flattop
1 flattop: nan
window 2 flattop
2 flattop: -4 -4
window 3 flattop
3 flattop: -4 10000 -4
window 10 flattop
10 flattop: -4 -202 -702 1982 8625 8625 1982 -702 -202 -4
window 100 flattop
100 flattop: -4 -5 -8 -14 -22 -34 -49 -69 -94 -124 -160 -202 -249 -302 -360 -420 -482 -542 -599 -647 -683 -703 -702 -674 -615 -520 -383 -200 31 315 652 1043 1488 1982 2523 3105 3720 4360 5016 5675 6328 6962 7563 8122 8625 9062 9424 9703 9892 9988 9988 9892 9703 9424 9062 8625 8122 7563 6962 6328 5675 5016 4360 3720 3105 2523 1982 1488 1043 652 315 31 -200 -383 -520 -615 -674 -702 -703 -683 -647 -599 -542 -482 -420 -360 -302 -249 -202 -160 -124 -94 -69 -49 -34 -22 -14 -8 -5 -4
window 1 blackmanharris
1 blackmanharris: nan
window 2 blackmanharris
2 blackmanharris: 1 1
window 3 blackmanharris
3 blackmanharris: 1 10000 1
window 10 blackmanharris
10 blackmanharris: 1 151 1470 5206 9317 9317 5206 1470 151 1
window 100 blackmanharris
100 blackmanharris: 1 1 3 6 11 18 28 42 60 83 113 151 197 254 323 405 502 615 746 896 1066 1257 1470 1706 1965 2247 2552 2878 3226 3592 3976 4375 4786 5206 5632 6060 6486 6906 7315 7710 8086 8439 8764 9058 9317 9538 9718 9855 9948 9994 9994 9948 9855 9718 9538 9317 9058 8764 8439 8086 7710 7315 6906 6486 6060 5632 5206 4786 4375 3976 3592 3226 2878 2552 2247 1965 1706 1470 1257 1066 896 746 615 502 405 323 254 197 151 113 83 60 42 28 18 11 6 3 1 1
power 100 10 1
100 10 1: 10 10 10 10 10 10 10 10 10 10 100
power 100 11 1
100 11 1: 9 9 9 9 9 10 9 9 9 9 9 100
power 101 11 1
101 11 1: 9 9 9 10 9 9 9 10 9 9 9 101
power 102 11 1
102 11 1: 9 9 10 9 9 10 9 9 10 9 9 102
power 103 11 1
103 11 1: 9 9 10 9 10 9 10 9 10 9 9 103
power 104 11 1
104 11 1: 9 10 9 10 9 10 9 10 9 10 9 104
power 1 1 1
1 1 1: 1 1
power 1 1 2
1 1 2: 1 1
power 10 1 1
10 1 1: 10 10
power 10 1 2
10 1 2: 10 10
power 1000 10 1
1000 10 1: 100 100 100 100 100 100 100 100 100 100 1000
power 1000 10 1.001
1000 10 1.001: 100 100 100 100 100 100 100 100 100 100 1000
power 1000 10 1.01
1000 10 1.01: 96 97 98 98 99 100 101 102 104 105 1000
power 1000 10 1.1
1000 10 1.1: 63 69 76 84 92 101 111 122 134 148 1000
power 1000 10 1.5
1000 10 1.5: 9 14 20 30 45 67 99 151 226 339 1000
power 1000 10 2
1000 10 2: 1 2 4 8 16 32 63 125 250 499 1000
power 1000000 100 1.5
1000000 100 1.5: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 3 4 6 9 14 20 30 45 67 101 151 226 339 508 761 1142 1713 2569 3854 5781 8671 13006 19509 29264 43896 65844 98692 148148 222222 333333 1000000
power 1000000 100 2
1000000 100 2: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 4 8 16 31 62 123 244 489 977 1953 3906 7729 15625 31250 62500 125000 250000 500000 1000000
power 1000000 1000 1.1
1000000 1000 1.1: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 4 4 4 5 5 5 6 6 7 8 8 9 10 11 12 13 15 16 18 19 21 23 26 28 31 34 37 41 45 49 54 60 65 72 79 87 96 105 116 127 140 154 169 186 204 225 247 272 299 329 362 398 438 481 529 582 640 704 775 852 937 1031 1134 1247 1372 1509 1660 1826 2009 2210 2431 2674 2941 3235 3559 3914 4306 4736 5210 5731 6304 6934 7628 8391 9230 10153 11168 12285 13513 14864 16351 17986 19785 21763 23939 26333 28966 31863 35049 38554 42410 46651 51316 56447 62092 68301 74225 82645 90909 1000000
power 1000000 1000 1.01
1000000 1000 1.01: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8 8 8 8 8 8 8 8 8 8 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11 11 11 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 14 14 14 14 15 15 15 15 15 15 15 16 16 16 16 16 16 16 17 17 17 17 17 17 18 18 18 18 18 19 19 19 19 19 19 20 20 20 20 20 21 21 21 21 21 22 22 22 22 22 23 23 23 23 24 24 24 24 25 25 25 25 26 26 26 26 27 27 27 27 28 28 28 28 29 29 29 30 30 30 30 31 31 31 32 32 32 33 33 33 34 34 34 35 35 35 36 36 36 37 37 37 38 38 39 39 39 40 40 40 41 41 42 42 43 43 43 44 44 45 45 46 46 46 47 47 48 48 49 49 50 50 51 51 52 52 53 53 54 54 55 55 56 57 57 58 58 59 59 60 61 61 62 62 63 64 64 65 66 66 67 68 68 69 70 70 71 72 72 73 74 75 75 76 77 78 78 79 80 81 81 82 83 84 85 86 86 87 88 89 90 91 92 93 94 94 95 96 97 98 99 100 101 102 103 104 105 106 107 109 110 111 112 113 114 115 116 117 119 120 121 122 123 125 126 127 128 130 131 132 134 135 136 138 139 140 142 143 145 146 148 149 150 152 153 155 157 158 160 161 163 165 166 168 169 171 173 175 176 178 180 182 183 185 187 189 191 193 195 197 199 201 203 205 207 209 211 213 215 217 219 222 224 226 228 231 233 235 238 240 242 245 247 250 252 255 257 260 262 265 268 270 273 276 278 281 284 287 290 293 296 299 301 305 308 311 314 317 320 323 326 330 333 336 340 343 347 350 353 357 361 364 368 371 375 379 383 387 390 394 398 402 406 410 414 419 423 427 431 436 440 444 449 453 458 462 467 472 476 481 486 491 496 501 506 511 516 521 526 531 537 542 547 553 558 564 570 575 581 587 593 599 605 611 617 623 629 636 642 648 655 661 668 675 681 688 695 702 709 716 723 730 738 745 753 760 768 775 783 791 799 807 815 823 831 840 848 856 865 874 882 891 900 909 918 927 937 946 956 965 975 984 994 1004 1014 1024 1035 1045 1055 1066 1077 1087 1098 1109 1120 1132 1143 1154 1166 1178 1189 1201 1213 1225 1238 1250 1262 1275 1288 1301 1314 1327 1340 1354 1367 1381 1395 1408 1423 1437 1451 1466 1480 1495 1510 1525 1540 1556 1571 1587 1603 1619 1635 1651 1668 1685 1702 1719 1736 1753 1771 1788 1806 1824 1842 1861 1880 1898 1917 1936 1956 1975 1995 2015 2035 2056 2076 2097 2118 2139 2160 2182 2204 2226 2248 2271 2293 2316 2339 2363 2386 2410 2434 2459 2483 2508 2533 2559 2584 2610 2636 2662 2689 2716 2743 2771 2798 2826 2855 2883 2912 2941 2970 3000 3030 3060 3091 3122 3153 3185 3217 3249 3281 3314 3347 3381 3414 3449 3483 3518 3553 3589 3624 3661 3697 3734 3772 3809 3847 3886 3925 3964 4004 4044 4084 4125 4166 4208 4250 4292 4335 4379 4423 4467 4511 4557 4602 4648 4695 4742 4789 4837 4885 4934 4983 5033 5084 5134 5186 5238 5290 5343 5396 5450 5505 5560 5615 5672 5728 5786 5843 5902 5961 6020 6081 6141 6203 6265 6328 6391 6455 6519 6253 6650 6717 6784 6852 6920 6990 7059 7130 7201 7273 7346 7420 7494 7569 7644 7721 7798 7876 7955 8034 8115 8196 8278 8361 8444 8529 8614 8700 8787 8875 8964 9053 9144 9235 9328 9421 9515 9610 9706 9803 9901 1000000
power 1000000 2000 1.01
1000000 2000 1.01: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8 8 8 8 8 8 8 8 8 8 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11 11 11 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 14 14 14 14 15 15 15 15 15 15 15 16 16 16 16 16 16 16 17 17 17 17 17 17 18 18 18 18 18 19 19 19 19 19 19 20 20 20 20 20 21 21 21 21 21 22 22 22 22 22 23 23 23 23 24 24 24 24 25 25 25 25 26 26 26 26 27 27 27 27 28 28 28 28 29 29 29 30 30 30 30 31 31 31 32 32 32 33 33 33 34 34 34 35 35 35 36 36 36 37 37 37 38 38 39 39 39 40 40 40 41 41 42 42 42 43 43 44 44 45 45 46 46 46 47 47 48 48 49 49 50 50 51 51 52 52 53 53 54 54 55 55 56 57 57 58 58 59 59 60 61 61 62 62 63 64 64 65 66 66 67 68 68 69 70 70 71 72 72 73 74 75 75 76 77 78 78 79 80 81 81 82 83 84 85 86 86 87 88 89 90 91 92 93 94 95 95 96 97 98 99 100 101 102 103 104 105 106 107 109 110 111 112 113 114 115 116 117 119 120 121 122 123 125 126 127 128 130 131 132 134 135 136 138 139 140 142 143 145 146 148 149 150 152 154 155 157 158 160 161 163 165 166 168 170 171 173 175 176 178 180 182 184 185 187 189 191 193 195 197 199 201 203 205 207 209 211 213 215 217 219 222 224 226 228 231 233 235 238 240 242 245 247 250 252 255 257 260 262 265 268 270 273 276 278 281 284 287 290 293 296 299 302 305 308 311 314 317 320 323 326 330 333 336 340 343 347 350 353 357 361 364 368 371 375 379 383 387 390 394 398 402 406 410 414 419 423 427 431 436 440 444 449 453 458 462 467 472 476 481 486 491 496 501 506 511 516 521 526 531 537 542 547 553 558 564 570 575 581 587 593 599 605 611 617 623 629 635 642 648 655 661 668 675 681 688 695 702 709 716 723 730 738 745 753 760 768 775 783 791 799 807 815 823 831 840 848 856 865 874 882 891 900 909 918 927 937 946 955 965 975 984 994 1004 1014 1024 1035 1045 1055 1066 1077 1087 1098 1109 1120 1132 1143 1154 1166 1177 1189 1201 1213 1225 1238 1250 1262 1275 1288 1301 1314 1327 1340 1353 1367 1381 1394 1408 1422 1437 1451 1466 1480 1495 1510 1525 1540 1556 1571 1587 1603 1619 1635 1651 1668 1685 1701 1718 1736 1753 1771 1788 1806 1824 1842 1861 1879 1898 1917 1936 1956 1975 1995 2015 2035 2056 2076 2097 2118 2139 2160 2182 2204 2226 2248 2271 2293 2316 2339 2363 2386 2410 2434 2459 2483 2508 2533 2558 2584 2610 2636 2662 2689 2716 2743 2770 2798 2826 2854 2883 2912 2941 2970 3000 3030 3060 3091 3122 3153 3185 3216 3249 3281 3314 3347 3380 3414 3448 3483 3518 3553 3588 3624 3661 3697 3734 3771 3809 3847 3886 3925 3964 4003 4044 4084 4125 4166 4208 4250 4292 4335 4379 4422 4467 4511 4556 4602 4648 4694 4741 4789 4837 4885 4934 4983 5033 5083 5134 5186 5237 5290 5343 5396 5450 5505 5560 5615 5671 5728 5785 5843 5902 5961 6020 6080 6141 6203 6265 6327 6391 6454 6519 6584 6650 6717 6784 6852 6920 6989 7059 7130 7201 7273 7346 7419 7493 7568 7644 7720 7798 7876 7954 8034 8114 8195 8277 8360 8444 8528 7324 8700 8787 8874 8963 9053 9143 9235 9327 9420 9515 9610 9706 9803 9901 1000000"



cd $(dirname "$0")

OK=0
FAILED=0
ANIM="|/-\\"
ANIM_INDEX=0

run() {
  local COMMAND=$1
  local EXPECTED=$2
  echo -n $'\r\e[2K\e[36;1m('${ANIM:ANIM_INDEX:1}$')\e[m' running: $COMMAND
  ANIM_INDEX=$(( ++ ANIM_INDEX % 4 ))

  if diff <(echo $EXPECTED) <(eval $COMMAND) >/dev/null 2>&1; then
    (( OK ++ ))
  else
    echo $'\r\e[2K\e[33mtest failed\e[m' $COMMAND
    (( FAILED ++ ))
  fi
}

IFS=$'\n'
COMMAND=
for LINE in $TESTS; do
  if [ -z "$COMMAND" ]; then 
    COMMAND="$LINE"
    continue
  fi

  run "$COMMAND" "$LINE"
  COMMAND=
done

echo $'\e[2K\r'"Number of tests:  $(printf %4d $(( OK + FAILED )))"
echo $'\e[33mFailed\e[m' "tests:     $(printf %4d $FAILED)"
echo $'\e[32mSuccessful\e[m' "tests: $(printf %4d $OK)"
