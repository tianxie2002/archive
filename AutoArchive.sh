# !/usr/bin

# 配置一些信息

# 修建文件夹
archivePath=$PWD
time=$(date +%Y%m%d%H%M)

archivePath=${archivePath}/${time}
mkdir ${archivePath}
exportOptionList=$PWD/Options.plist

cd ..
#
##项目路径
projectPath=$PWD/Motu
#
#echo ${projectPath}
cd ${projectPath}

git checkout develop
git pull origin develop:develop

scheme=Motu
# 下面三个命令 分别是clean , build , export
xcodebuild clean -workspace ${scheme}.xcworkspace -scheme ${scheme} -configuration Debug

xcodebuild archive -workspace ${scheme}.xcworkspace -scheme ${scheme} -archivePath ${archivePath}/${scheme}.xcarchive

xcodebuild -exportArchive -archivePath ${archivePath}/${scheme}.xcarchive -exportPath ${archivePath}/${scheme} -exportOptionsPlist ${exportOptionList}

#获取ipa 上传到蒲公英
ipaPath=${archivePath}/${scheme}/${scheme}.ipa

ukey=xxx
_api_key=xxx

curl -F "file=@$ipaPath" \
-F "uKey=$ukey" \
-F "_api_key=$_api_key" \
-F "installType=2" \
https://qiniu-storage.pgyer.com/apiv1/app/upload


