#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"
cd $PKG_PATH

#修复HomeProxy的google检测
HP_DIR=$(find ../feeds/luci/ -maxdepth 3 -type d -wholename "*/applications/luci-app-homeproxy")
if [ -d "$HP_DIR" ]; then
	echo " "

	HP_PATH="$HP_DIR/root/usr/share/rpcd/ucode/luci.homeproxy"
	sed -i 's|www.google.com|www.google.com/generate_204|g' $HP_PATH

	cd $PKG_PATH && echo "homeproxy check has been fixed!"
fi

#修改argon主题字体和颜色
if [ -d *"luci-theme-argon"* ]; then
	echo " "

	cd ./luci-theme-argon/

	sed -i "/font-weight:/ { /important/! { /\/\*/! s/:.*/: var(--font-weight);/ } }" $(find ./luci-theme-argon -type f -iname "*.css")
	sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" ./luci-app-argon-config/root/etc/config/argon

	cd $PKG_PATH && echo "theme-argon has been fixed!"
fi

#修改qca-nss-drv启动顺序
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	echo " "

	sed -i 's/START=.*/START=85/g' $NSS_DRV

	cd $PKG_PATH && echo "qca-nss-drv has been fixed!"
fi

#修改qca-nss-pbuf启动顺序
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	echo " "

	sed -i 's/START=.*/START=86/g' $NSS_PBUF

	cd $PKG_PATH && echo "qca-nss-pbuf has been fixed!"
fi

#修复TailScale配置文件冲突
TS_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
if [ -f "$TS_FILE" ]; then
	echo " "

	sed -i '/\/files/d' $TS_FILE

	cd $PKG_PATH && echo "tailscale has been fixed!"
fi

#修复Rust编译失败
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	echo " "

	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE

	cd $PKG_PATH && echo "rust has been fixed!"
fi

#修复DiskMan编译失败
DM_FILE=$(find ./ -maxdepth 3 -type f -wholename "*/luci-app-diskman/Makefile")
if [ -f "$DM_FILE" ]; then
	echo " "

	sed -i 's/fs-ntfs/fs-ntfs3/g' $DM_FILE

	cd $PKG_PATH && echo "diskman has been fixed!"
fi

#修复Frpc配置文件
FRPC_DIR=$(find ../feeds/luci/ -maxdepth 3 -type d -wholename "*/applications/luci-app-frpc")
if [ -d "$FRPC_DIR" ]; then
	FRPC_PATH="$FRPC_DIR/htdocs/luci-static/resources/view/frpc.js"
	sed -i "s|'tcp', 'kcp', 'websocket'|'tcp', 'kcp', 'websocket', 'quic'|g" $FRPC_PATH

	cd $PKG_PATH && echo "luci-app-frpc has been fixed!"
fi
