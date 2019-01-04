CURRENT_PATH=$(PWD)
UNITY_PROJ=$(CURRENT_PATH)/UnityPrj/303Unity
UNITY_BUILD_TARGET=$(CURRENT_PATH)/ios303
set UNITY_BUILD_TARGET=$(UNITY_BUILD_TARGET)
export UNITY_BUILD_TARGET
IPA_NAME=Unity_iPhone_$(SVN_REVISION)
IPA_PATH=$(UNITY_BUILD_TARGET)/$(IPA_NAME).ipa
WWW_DOWN=/opt/local/apache2/htdocs/down
IPADOING=$(UNITY_BUILD_TARGET)/success1
MYSQL_EXECUTOR=/opt/local/lib/mysql56/bin/mysql -h 172.20.130.55 -udbuser -p1q3e2w4R tgs_logger
LUA=$(CURRENT_PATH)/tools/gd_xls/lua
DB_HOST=172.20.130.55
DB_DATA_NAME=data
DB_CFG_NAME=cfg

#test -s $(WWW_DOWN)/$(IPA_NAME).ipa || { echo "GNU sort does not exist! Exiting..."; }

u3d2:clean2 clean resource u3d_xcode3 xcode_clean xcode_archive xcode_export down
	rm -f $(IPADOING)
	#rm -f $(CURRENT_PATH)/timer.txt
	./log_time.sh ended_at  
u3d:clean2 clean resource u3d_xcode xcode_archive xcode_export down

# 客户端开发导出xcode
c:resource u3d_xcode

resource:right
	./log_time.sh resource_exported_at  
	cd 2DPCProj && sh buildAlltoUnity.sh
u3d_xcode:
	mkdir -p $(UNITY_BUILD_TARGET)
	/Applications/Unity/Unity.app/Contents/MacOS/Unity -executeMethod BuildScript.BuildWebPlayer -projectPath $(UNITY_PROJ) -noGraphics -batchmode -quit -logFile $(UNITY_BUILD_TARGET)/log.txt
u3d_xcode2:
	/Applications/Unity/Unity.app/Contents/MacOS/Unity -executeMethod BuildScript.BuildWebPlayer -projectPath $(UNITY_PROJ) -logFile $(UNITY_BUILD_TARGET)/log.txt 
u3d_xcode3:
	./log_time.sh xcode_exported_at  
	echo 'sleep 5 \n if [ ! -f "$(IPADOING)" ] \n then \ncd $(CURRENT_PATH) \n make u3d_xcode SVN_REVISION=$(SVN_REVISION) \n echo "" > $(UNITY_BUILD_TARGET)/success \nfi \n' > /Users/Shared/Jenkins/plist-test.sh
	./delay.sh "$(UNITY_BUILD_TARGET)/success"
	echo '' > $(IPADOING)
xcode_clean:
	./log_time.sh xcode_cleaned_at  
	cd $(UNITY_BUILD_TARGET) && xcodebuild clean -project Unity-iPhone.xcodeproj -configuration Release -alltargets
xcode_archive:
	./log_time.sh xcode_archived_at  
	cd $(UNITY_BUILD_TARGET) && xcodebuild archive -project Unity-iPhone.xcodeproj -scheme Unity-iPhone -archivePath p303.xcarchive
xcode_export:
	./log_time.sh ipa_exported_at  
	cd $(UNITY_BUILD_TARGET) && xcodebuild -exportArchive -archivePath p303.xcarchive -exportPath $(IPA_NAME) -exportFormat ipa -exportProvisioningProfile "baotuan_beta"
down:
	./log_time.sh downloaded_at  
	cp $(IPA_PATH) $(WWW_DOWN) 
	./plist.sh $(IPA_NAME) > $(WWW_DOWN)/$(IPA_NAME).plist
	./html.sh $(IPA_NAME) >> $(WWW_DOWN)/index.html
x_build:xcopy
	cd ../auto && ./build.sh release
clean:
	svn status | grep ^[\?I] | cut -c9- | xargs rm -rf 
	rm -f 2DPCProj/Data/Lua/GameDatas/*
	rm -f 2DPCProj/Data/Lua/NetProtocal/proto_struct.lua
	./log_time.sh started_at
clean2:
	rm -rf $(UNITY_BUILD_TARGET)
files:
	svn status --no-ignore | grep ^[\?I] | cut -c9-
xcopy:
	cp -rf tools/provisioning ../auto
	cp -rf tools/build.sh ../auto/build.sh
right:
	chmod 777 "$(PWD)/2DPCProj/tools/luatools/lua"
	chmod 777 "$(PWD)/2DPCProj/tools/luatools/luac"
	chmod 777 "$(PWD)/2DPCProj/tools/OSXswf_exporter"
	chmod 777 "$(PWD)/2DPCProj/tools/TextureConvertor/PVRTexTool"
time_cost:
	$(MYSQL_EXECUTOR) < $(CURRENT_PATH)/timer.txt 

gd:
	mkdir -p data/collection
	cd tools/gd_xls && $(LUA) lua_data.lua $(CURRENT_PATH)/config/GameDatas/ $(CURRENT_PATH)/data/ $(DB_DATA_NAME) $(DB_CFG_NAME)
dbf:
	mongo --host $(DB_HOST) data/db_cfg_init.js
