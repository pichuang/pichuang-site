---
layout: post
title: "Small Form Factor Notes"
date: 2017-03-01 09:37:43
updated: 2017-03-01 09:37:43
category:
- Infra
tags:
- infra
- dac
- sff
---

## Objective

本篇是記錄關於 SFF (Small Form Factor) 的相關規範，尤其是裡面的 EEPROM 資訊之驗證

## SFF Spec list
[SNIA, Storage Networking Industry Association][5] 是一個提供全球包含儲存、網路工業標準的國際組織，成員大多由各大網通或儲存廠商所組成。此組織針對 SFF (Small Form Factor) 定義了目前常見的規範如下:

| Spec     | Full name |
|----------|----------------------------------------------------|
| [SFF-8024][12]| SFF Committee Cross Reference to Industry Products |
| [SFF-8436][4] | Quad Small Form-factor pluggable SFF-8436 (QSFP+) |
| [SFF-8472][1] | Diagnostic Monitoring Interface for Optical Transceivers (SFP+) |
| [SFF-8636][11]| Management Interface for Cabled Environments |
| [SFF-8665][3] | QSFP+ 28 Gb/s 4X Pluggable Transceiver Solution (QSFP28) |

More information: [SNIA Public Documents][6]

<!--more-->

## SFF Standards Compliance

根據 [SFF-8024 SFF Committee Cross Reference to Industry Products][9] `TABLE 3-1 PLUGGABLE CONNECTORS` 文件指出，針對不同類型的 SFF 有各種適當的規範

![SFF-8024 SFF Committee Cross Reference to Industry Products, TABLE 3-1 PLUGGABLE CONNECTORS](https://lh3.googleusercontent.com/G0Ky3QMZzG7ed90GM1YziFdTScukMv1LqETPHrBui9JJF8FuF4b-Vx882KT4oyJozW8u6LqRNNMwPDHubwbk1xZd6pxw0r3050ECJn8bXseF1AK-0lAhI9HvXg3FDcHyq52kNQP7gTLbejBnPvboEncPcMOSJRs5gdj2_ya4vD2ylHdZzuKNctAvjxfpIdeeI56HrdeV3_P8oLl5806xmzhbCLvwax5FEhSSUgCXSWTJKBf_28troAtRKhfR-s-CITO1X0fN0lgT3U4cqeTS9qqE18jVxeYJ3KPiBqIdT9jM_ng-i835p4mu2Lrp-gEt_vTuRB5G4EeA2vHcEbDV7PwEvkq2_gl9xfj8XCobi2UOHCQqzfM8B8-s4yOmCROm_Z7HXqS6XAPRrdUAygu9_6ipbEbIk0UXugNjvkDuQgHQwLZBVBecatmd_8tTJev80zIMagIGWWKv9KWefEg8E0zxIsokHxCrF_qbutYioHI_sNWcb96XnknASYG2yexWsIfVh2vFsqxOSfPKUrk07r9AxMrUegENNvnu4DzqTu5v2Hw2BpyDhJ4aLOgASKzH_Tq1ogaWVNJwezH_qg3n2XdARc72q8nyJph-tvNTm0oGzWKkxUszFw=w1260-h1314-no)

以下是針對 DAC (Direct Attach Copper) 相關整理:

- 10Gb/s SFP+ DAC
  - IEEE 802.3ae (10GbE)
  - Electrical: SFF-8431, SFF-8083
  - Mechanical: SFF-8432
  - EEPROM: [SFF-8472][1]

- 25Gb/s SFP28 DAC
  - EEPROM: [SFF-8402][13]

- 40Gb/s QSFP+ DAC
  - IEEE 802.3ba (40GbE or 100GbE)
  - Electrical: IBTA V2 Revision 1.2.1 and 1.3
  - EEPROM: [SFF-8436][4]

- 100Gb/s QSFP28 DAC
  - IEEE 802.3bj (100GbE)
  - EEPROM: [SFF-8665][3]

## Hands-on

### Environment:
- Environment
  - [Cumulus Networks][7] Cumulus Linux 3.2.1
- Edgecore ET6402-40GDAC-3M
  - DAC (Direct Attach Copper)
  - QSFP+
  - 3M

### EEPROM

- Output Using `ethtool -m` 
```text
root@cumulus:~# ethtool -m swp49 |less
        Identifier                                : 0x0d (QSFP+)
        Extended identifier                       : 0x00 (1.5W max. Power consumption, No CDR in TX, No CDR in RX)
        Connector                                 : 0x23 (No separable connector)
        Transceiver codes                         : 0x08 0x00 0x00 0x00 0x00 0x00 0x00 0x00
        Transceiver type                          : 40G Ethernet: 40G Base-CR4
        Encoding                                  : 0x05 (64B/66B)
        BR, Nominal                               : 10300Mbps
        Rate identifier                           : 0x00
        Length (SMF,km)                           : 0km
        Length (OM3 50um)                         : 0m
        Length (OM2 50um)                         : 0m
        Length (OM1 62.5um)                       : 0m
        Length (Copper or Active cable)           : 3m
        Transmitter technology                    : 0xa0 (Copper cable unequalized)
        Attenuation at 2.5GHz                     : 3db
        Attenuation at 5.0GHz                     : 4db
        Vendor name                               : EDGE-CORE
        Vendor OUI                                : a8:b0:ae
        Vendor PN                                 : ET6402-40GDAC-3M
        Vendor rev                                : 0
        Vendor SN                                 : ***
        Laser bias current (Channel 1)            : 33.410 mA
        Laser bias current (Channel 2)            : 26.222 mA
        Laser bias current (Channel 3)            : 23.138 mA
        Laser bias current (Channel 4)            : 26.212 mA
        Receiver signal OMA(Channel 1)            : 1.7229 mW / 2.36 dBm
        Receiver signal OMA(Channel 2)            : 2.0561 mW / 3.13 dBm
        Receiver signal OMA(Channel 3)            : 1.6705 mW / 2.23 dBm
        Receiver signal OMA(Channel 4)            : 2.0547 mW / 3.13 dBm
        Module temperature                        : 0.00 degrees C / 32.00 degrees F
        Module voltage                            : 0.0000 V
        Alarm/warning flags implemented           : No
```

### Details

因為這條線是 40G QSFP+，故 EEPROM 對照的規範應該要看 [SFF-8436][4] 的 `7.6 QSFP+ Memory Map`，而以上的資訊是遵照 `7.6.2 Upper Memory Map Page 00h` 的 `Table 29 — Serial ID: Data Fields (Page 00)` 裡的格式呈現


- `7.6.2.1 Identifier (Address 128)`
```
Identifier                                : 0x0d (QSFP+)
```
  - The identifier value specifies the physical device described by the serial information. The QSFP+ Module shall use the identifier 0Dh. 

- `7.6.2.2 Extended Identifier (Address 129)`
```
Extended identifier                       : 0x00 (1.5W max. Power consumption, No CDR in TX, No CDR in RX)
```
  - The extended identifier provides additional information about the basic Module types such as whether the Module contains a CDR function and identifies the power consumption class it belongs to.

- `7.6.2.3 Connector (Address 130)`
```
Connector                                 : 0x23 (No separable connector)
```
  - The Connector value indicates the external connector provided on the interface. This value shall be included in the serial data. Note that 01h – 0Bh are not QSFP+ compatible, and are included for compatibility with other standards. 

- `7.6.2.4 Specification compliance (Address 131-138)`
```
Transceiver codes                         : 0x08 0x00 0x00 0x00 0x00 0x00 0x00 0x00
Transceiver type                          : 40G Ethernet: 40G Base-CR4
```
  - The following bit significant indicators define the electronic or optical interfaces that are supported by the QSFP+ Module. For Fibre Channel QSFP+s, the Fibre Channel speed, transmission media, transmitter technology, and distance capability shall all be indicated.
  - 0x08 0x00 0x00 0x00 0x00 0x00 0x00 0x00 == Address 131 (10/40G Ethernet Compliance Code), Bit 3 == 40G Base-CR4 

- `7.6.2.5 Encoding (Address 139)`
```
Encoding                                  : 0x05 (64B/66B)
```
  - The encoding value indicates the serial encoding mechanism that is the nominal design target of the particular QSFP+ Module. The value shall be contained in the serial data.

- `7.6.2.13 Device Tech (Address 147)`
```
Transmitter technology                    : 0xa0 (Copper cable unequalized)
```
  - The top 4 bits of the Device Tech byte describe the device technology used. The lower four bits (bits 7-4) of the Device Tech byte are used to describe the transmitter technology. 

- `7.6.2.{14, 16, 17, 18, 24} Vendor Name/OUI/PN/Rev/SN`
```
Vendor name                               : EDGE-CORE
Vendor OUI                                : a8:b0:ae
Vendor PN                                 : ET6402-40GDAC-3M
Vendor rev                                : 0
Vendor SN                                 : ***
```

- `7.6.2.26 Diagnostic Monitoring Type (Address 220)`
```
Laser bias current (Channel 1)            : 33.410 mA
Laser bias current (Channel 2)            : 26.222 mA
Laser bias current (Channel 3)            : 23.138 mA
Laser bias current (Channel 4)            : 26.212 mA
Receiver signal OMA(Channel 1)            : 1.7229 mW / 2.36 dBm
Receiver signal OMA(Channel 2)            : 2.0561 mW / 3.13 dBm
Receiver signal OMA(Channel 3)            : 1.6705 mW / 2.23 dBm
Receiver signal OMA(Channel 4)            : 2.0547 mW / 3.13 dBm
Module temperature                        : 0.00 degrees C / 32.00 degrees F
Module voltage                            : 0.0000 V
Alarm/warning flags implemented           : No
```
- Digital Diagnostic Monitors monitor received power, bias current, supply voltage and temperature. Additionally, alarm and warning thresholds must be written as specified in this document.

## References
- [SFF-8472 Rev 12.2 Diagnostic Monitoring Interface for Optical Transceivers][1]
- [光通讯：光纤、光模块及光接口常用知识][2]
- [SFF-8665 Rev 1.9 QSFP+ 28 Gb/s 4X Pluggable Transceiver Solution (QSFP28)][3]
- [SFF-8436 Rev 4.8 QSFP+ 10 Gbs 4X PLUGGABLE TRANSCEIVER][4]
- [SNIA, Storage Networking Industry Association][5]
- [SNIA Public Documents][6]
- [Cumulus Networks Official Website][7]
- [Wiki - American Wire Gauge, AWG][8]
- [SFF-8024 SFF Committee Cross Reference to Industry Products][9]
- [100G & 25G Plugfests: What we learned - Cumulus Networks][10]

## 社群服務

本人的文章大多都會發布在 [SDNDS-TW](https://www.facebook.com/groups/sdnds.tw/)。這社團文章都跟 SDN/NFV 國內外產業新聞或資訊有關，有任何技術問題也歡迎在上面詢問。
![SDNDS-TW Facebook Group](https://lh3.googleusercontent.com/KizynpieyTlykuyk-po1tgasnVI4Oxl9_vPXXpHYyj_JiUc0V5bRb8lHxGpZDQiTqMNCn_A6NqF-4Gx8KMex8XsjgdCGByIqtIpKBc4TvQoUtNtXf0RK_eBf2pwm8wNJRiWXfkz3vf6Tf465o2vzmH2G4iR28kf_Wc_ADeqDJDfQQlV0XTtQcSBBRG2N-zs1ue6dhg38lMoO47n0-SI6yl3x-HhyRIK8penHyHXe0i9q08IDqYEdtMGyKExcihESNthqc4r74kceAJUYhfqsFRpGLteEMXDkShC74r79Frr5aVwsYml0x1WVHkmXbxLZB381B0gkJWUXaoCeCC8rdeYtb6vn60vLsNYgYLRI0wT0VjEbJTCgcHUbNk8sBkXEiATLTKQiES5VcIEJ9nQ7FYTxsF8BiB7exUxr0b3kfTLVJF2RBqc0hpHojoiMh-nL-OY30a9rgf1vr4n-44sDGfa8-f7xWX3JEe-7RgNjwZ5glxGM1lkrf2_MHwbgVRNd2tzUrxmRNmMrVpFog-NcByDo824K8GJLxyLq0Dg12jkx90uOBKmhAE-_JUL5iIYzzUUKGJu1-ORReKmYR63UvTeUvwtxSEKUnpax4co6s6dQoS2f5bB37Q=w1652-h590-no)

[1]: https://ta.snia.org/kws/public/download/294/SFF-8472.PDF
[2]: http://fiber.ofweek.com/2015-11/ART-210001-11000-29022602.html
[3]: https://ta.snia.org/kws/public/download/353/SFF-8665.PDF
[4]: https://ta.snia.org/kws/public/download/274/SFF-8436.PDF
[5]: https://www.snia.org/
[6]: https://ta.snia.org/kws/public/documents?view=
[7]: https://cumulusnetworks.com/
[8]: https://en.wikipedia.org/wiki/American_wire_gauge
[9]: https://ta.snia.org/kws/public/download/134/8024_039.PDF
[10]: https://cumulusnetworks.com/blog/100g-25g-plugfests-learned/
[11]: https://ta.snia.org/kws/public/download/329/SFF-8636.PDF
[12]: https://ta.snia.org/kws/public/download/134/8024_039.PDF
[13]: https://ta.snia.org/kws/public/download/329/SFF-8402.PDF