#!/bin/bash

echo IsBuildDLC: ${IsBuildDLC}

chmod u+x check_sh.sh
. check_sh.sh

_do svn up --accept tf
_do svn revert ./UnityPrj/GL2/Assets -R

_do svn info > svn_info.txt

_do cd FlashUIProj/trunk/data
python cleanData.py default IOS
_do cd ../../../

_do cd UnityPrj/
chmod u+x autoExportAssetsIOS.sh
. autoExportAssetsIOS.sh
grep "BuildError:\ " ExportAssetsBundle.log
if [ $? -eq 0 ]; then
	cd ..	
	exit -1
fi
_do cd ..

_do cd FlashUIProj/trunk/

#chmod u+x buildIosRes.sh
#_do . buildIosRes.sh
python autobuildRes_ios.py ${IsBuildDLC}

cd ../..

cd UnityPrj/

chmod u+x autoBuildIOS.sh
. autoBuildIOS.sh

cd ..