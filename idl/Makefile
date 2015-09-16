FILES = pvattrget.pro \
        pvattrinfo.pro \
        pvattrisavailable.pro \
        pvattrlist.pro \
        pvattrname.pro \
        pvattr.pro \
        pvattrrange.pro \
        pvattrset.pro \
        pvcameraattributes.pro \
        pvcameraclose.pro \
        pvcameracount.pro \
        pvcamera__define.pro \
        pvcameralistex.pro \
        pvcameraopen.pro \
        pvcamerareport.pro \
        pvcaptureadjustpacketsize.pro \
        pvcaptureend.pro \
        pvcapturequeueframe.pro \
        pvcapturestart.pro \
        pvcapturetransferframe.pro \
        pvcapturewaitforframedone.pro \
        pvcommandrun.pro \
        pvinitialize.pro \
        pvstrerr.pro \
        pvstrinfo.pro \
        pvuninitialize.pro \
        pvversion.pro

INSTALL = install
DESTINATION = pro

all: install

clean:

install:
	sudo $(INSTALL) -d $(DESTINATION)
	sudo $(INSTALL) -m 644 $(FILES) $(DESTINATION)

uninstall:
	sudo rm $(DESTINATION)/$(FILES)
	sudo rmdir $(DESTINATION)
