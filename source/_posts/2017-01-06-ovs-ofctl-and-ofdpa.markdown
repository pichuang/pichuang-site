---
layout: post
title:  "OpenvSwitch ovs-ofctl and OF-DPA"
date:   2017-01-06 13:42:10 +0800
tags: [ovs, ofdpa, switch, ovs-ofctl]
---

## Goal
Remote control and management OF-DPA via ovs-ofctl

## Environment
- Switch
  - IP: 192.168.11.2
  - Hardware
    - Model
      - [Edgecore AS5712-54X](http://www.edge-core.com/productsInfo.php?cls=1&cls2=8&cls3=44&id=15)
  - Software
    - ONL version
      - [ONL-2.0.0-ONL-OS-DEB8-2016-12-22.1828-604af0c-AMD64-INSTALLED-INSTALLER](http://opennetlinux.org/binaries/2016.12.22.18.28.604af0c9b3dc9504870c30273ab22f2fb62746c3/ONL-2.0.0-ONL-OS-DEB8-2016-12-22.1828-604af0c-AMD64-INSTALLED-INSTALLER)
    - OF-DPA version
      - [ofdpa_3.0 EA3](https://github.com/onfsdn/atrium-docs/blob/master/16A/ONOS/builds/ofdpa_3.0.3.1%2Baccton1.4~1-1_amd64.deb)
    - `You need launch ofappagent first`. If you dont know how to start it. Please refer [OF-DPA with ONL Cheat Sheet](http://blog.pichuang.com.tw/ofdpa-with-onl-cheat-sheet)
- Contorl VM
  - IP: 192.168.11.1
  - OpenvSwitch
    - 2.6.9
    - In this case, we just use `ovs-ofctl`, and it's also work if you want to use dpctl which CPqD provide

### Install ofdpa-ofctl script (Optional)
{% highlight shell %}
cat <<'EOF' >> /usr/bin/ofdpa-ofctl
#!/bin/bash
SWITCH_IP="192.168.11.2"
OPTS="-O OpenFlow13 tcp:$SWITCH_IP:6633"

if [ -n "$1" ]; then
    ovs-ofctl $1 $OPTS
else
    ovs-ofctl -h
fi
EOF
chmod +x /usr/local/bin/ofdpa-ofctl
{% endhighlight %}
- Same as `ovs-ofctl`

### Usage

#### Show port information
- `ofdpa-ofctl show`
![screenshot-ovs-ofctl-show](https://lh3.googleusercontent.com/tKLPupRqIMcNsuPBugLxYQg6DB4klz3vPBECqYSa_T7MD2l0IRZyIl_6kq6uLX7cmfuFwWx-VCjoPtC2nHUJ5Xn1aVTq5nRR2NKTxOS5l5y3-7YwgJHKZGdCgqQsEgeIJNxfPYrRAtBqs5a-38OLVEIrfh6Pb0GYZkgl2VoNB7nNY2wMXh6KX7g-voYhklH1XCEkXaajRGQz4zg3vbKQpqC1lS9sgGFQVCqwsLGZoz2lne0kkfCEW3yn9TMXs7PPcvVBtmGJBH97v-Gx4CV-no-vTHmWXbe6v2bWEIhJB_oFhKPZILu2K05jHsA68f426VvN6uIT4bfxVA7i9sl90EJbD3aGZdfnyPqrnpsbsaHDuFCXkIbXvixrv1HtKrStubBPyKpW37_cCjBj3YdDmcloB_Wi7caqSxyw-KSYQv6mlPJ4RPFiScXvbWpj_wF7bxLxYwxLpQbo8qIoPExQTwjPp6O7ZVR0XGtcQcn5jAD8L3ur895qLAo55abBZ7-Tv-filg_PIbRKdej2q-twvCGRbspOO7m76f6ekuccyMBfkEYlleUjY39WowfzWCkt7tqoi-1rSVDW5Px9PqXl0Sh-1sn1rEK_7SGru7XDIzecQP3__CVz=w1566-h1060-no)

#### Show tables information
- `ofdpa-ofctl dump-tables`
![screenshot-ovs-ofctl-dump-tables](https://lh3.googleusercontent.com/adiWa4tuPFAuRm4uv7OXdwxq5r6bwOlTDpdMUFCn1ID6KXANtE7VgCqAg8pF21u-8a-T2584d5MiemV8fIw1BH-FP6pQy88SGi3h6CH0E_8IA_apF0fvdUfZFvrX3owYnGouihbPmml2oP38nc_ZsDD3bJnVjOaWaeqh68NKoeOvdvjHXrEwTQ5wXnQiny3Cvqi1KoKK5lk7jaCkagOaZWztslp2KfRTFxQrZepj8sDtstwcgUJNctP0ZQWmcyx96a-LOHni6MlqWzs_P1cw2xxRCC9mZBnczazSwBU1n2KGr2IS3Oeu-44kO2rMsMwQSOgh-cCCv1m6nTTD-XscIRuwjmJctZaMgvipEUKTn8wKVwd7Cz-aYV6tEDQ44LajnBKzJdNjWbESzIVNHy_yo_S8pRnxQpJGOVlErgSKGMQB5_ZBkxAuXAB-_d_dBno6hrdu-ewBxZFS636mqDa39Tn158fpJx8yS6vQoYcvfzVNkmsywilc4w0lRMMybELAV3mob04z8RbhXRY34I7VquaNQbQxNZ7i-m-CA5fdtLvbTPiRULVwHegNT-88dTT7yReRqmBNQq_i7GuDP5dQtrqhtvQN7_bXwNPovF59BWdiRJ2A1LZw=w586-h1406-no)

#### Show flow entries
- `ofdpa-ofctl dump-flows`

#### Show queue stats
- `ofdpa-ofctl queue-stats`
![screenshot-ovs-ofctl-queue-stats](https://lh3.googleusercontent.com/QvogwdWFxfC7FNYe_r16HGBI9BrP1RArXsUOkBCYabr-PodbErqEtFHwc0xlln-JNaxFz4xiLYAfq3YZ9edg2PvOY3Mi07icXCsghfktguXmyxtShhgOLVVLJsxJ2ZWPFuTCSnrUa-9vDcIYwAUIo33qyHWc5Kqp2zgOGNXHAN5CeByDN7lNhbgYDI8zb5qVtaWhBiOx52CWMxR0H4GtYl6_yKMm_hHsSq5sfae2EvnyLQSTq4yNPWNgh9CUqoxFqXkRjDV5ZFJp3ZXc_rRDDUngyliu3YcnhY7q6x68ECj1TIX1Qv3SS_sAYSpwby2iON_XRfjbTCzuxK7k25SqR_2iTxRTsvi4aFb_Y61uzHGMoZ86c2lu6BuZzBfDigyJD9HbMrPNRJCWjHwMASADkPe3jRy2LApO4q1eFK7q87CSSPSq99-N3vkwDLYUPY_D5KbivK1AWA5u4sb1Bd5ctJTezfdu93_ypK41uYKA4mbhzOLj3GmNxF2uS791xmPKDIvuDJYC385wMf5SJLSRzjnYM2iaqiXsqP8ILgpSVD9G1YKPnEJ2-IXln2F7LuE7pte43JQr7J41EZIUbZ9zA5jomELcbealeiLStCB-AJnkddP9nXhW=w1440-h944-no)

#### Show group information
- `ofdpa-ofctl dump-groups`

#### Show ports information
- `ofdpa-ofcll dump-ports`

## Reference
- [ovs-ofctl](http://openvswitch.org/support/dist-docs/ovs-ofctl.8.txt)
- [Pica8 OVS Configuration Guide 2.8.0](http://www.pica8.com/wp-content/uploads/2015/09/v2.8/html/ovs-configuration-guide/)

