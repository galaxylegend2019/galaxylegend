import os
import sys
import shutil

def copytree(src, dst, symlinks=False, ignore=None):
    names = os.listdir(src)
    if ignore is not None:
        ignored_names = ignore(src, names)
    else:
        ignored_names = set()

    safe_makedirs(dst)
    errors = []
    for name in names:
        if name in ignored_names:
            continue
        srcname = os.path.join(src, name)
        dstname = os.path.join(dst, name)
        try:
            if symlinks and os.path.islink(srcname):
                linkto = os.readlink(srcname)
                os.symlink(linkto, dstname)
            elif os.path.isdir(srcname):
                copytree(srcname, dstname, symlinks, ignore)
            else:
                # Will raise a SpecialFileError for unsupported file types
                shutil.copy2(srcname, dstname)
        # catch the Error from the recursive copytree so that we can
        # continue with other files
        except Error, err:
            errors.extend(err.args[0])
        except EnvironmentError, why:
            errors.append((srcname, dstname, str(why)))
    try:
        shutil.copystat(src, dst)
    except OSError, why:
        if WindowsError is not None and isinstance(why, WindowsError):
            # Copying file access times may fail on Windows
            pass
        else:
            errors.append((src, dst, str(why)))
    if errors:
        raise Error, errors


def safe_makedirs(name, mode=0777):
	if os.path.exists(name):
		return
	os.makedirs(name,mode)
	return


def main():
	is_build_dlc = False
	if len(sys.argv) > 1 and sys.argv[1] == 'true':
		is_build_dlc = True
	
	work_dir = os.path.dirname(os.path.abspath(__file__))
	# os.chdir(os.path.join(work_dir,"FlashUIProj","trunk","dataSyncAll","Android"))
	StreamingAssets_path = os.path.join(work_dir,"UnityPrj","GL2","Assets","StreamingAssets")
	# if os.path.exists(StreamingAssets_path):
	# 	shutil.rmtree(StreamingAssets_path)
	# 	os.mkdir(StreamingAssets_path)
		
	os.chdir(os.path.join(work_dir,"UnityPrj"))
	os.system('autoExportAssetsAndroid.bat')
	os.chdir(os.path.join(work_dir,"FlashUIProj","trunk"))
	os.system('python autobuildRes_android.py')
	if is_build_dlc:
		print "build dlc ..."
		os.chdir(os.path.join(work_dir,"FlashUIProj","trunk","dataSyncAll"))
		os.system('python buildALLDLCAndroid.py default Android')
	os.chdir(os.path.join(work_dir,"FlashUIProj","trunk","prj","Android"))
	os.system('python 2_pack_data.py')

	if os.path.exists(os.path.join(work_dir,"UnityPrj","GL2_Android","GL2")):
		shutil.rmtree(os.path.join(work_dir,"UnityPrj","GL2_Android","GL2"))
	os.chdir(os.path.join(work_dir,"UnityPrj"))
	os.system('autoExportGameAndroid.bat')

	shutil.copyfile(os.path.join(work_dir,"UnityPrj","GL2_Android","support","AndroidManifest.xml"),os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","AndroidManifest.xml"))
	shutil.copyfile(os.path.join(work_dir,"UnityPrj","GL2_Android","support","build.gradle"),os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","build.gradle"))

	shutil.copyfile(os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","libs","unity-classes.jar"),os.path.join(work_dir,"UnityPrj","GL2_Android","Engine","libs","unity-classes.jar"))

	copytree(os.path.join(work_dir,"UnityPrj","GL2_Android","support","res"),os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","res"))

	shutil.rmtree(os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","src","com"));
	copytree(os.path.join(work_dir,"UnityPrj","GL2_Android","support","com"),os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","src","com"))

	shutil.copyfile(os.path.join(work_dir,"FlashUIProj","trunk","prj","Android","tap4fun.zip"),os.path.join(work_dir,"UnityPrj","GL2_Android","GL2","assets","tap4fun.zip"))

	os.chdir(os.path.join(work_dir,"UnityPrj","GL2_Android"))
	os.system("gradle assembleDebug")

if __name__ == '__main__':
	main()
