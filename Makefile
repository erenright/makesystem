include version.mk

libA        	    := libA
libraries			:= $(libA)
exeA		        := exeA
exeB    			:= exeB

imagedir			:= image
imagenamebase		:= $(partNumber)_$(appName)_v$(versionMajor).$(versionMinor).$(versionRevision)
imagefile			:= $(imagenamebase).squashfs

.PHONY: all $(exeA) $(exeB) $(libraries)
all: $(exeA) $(exeB) $(libraries)

install: $(exeA) $(exeB)
	$(RM) -rf $(imagedir) $(imagefile)
	install -D -m 755 -t $(imagedir)/	$(exeA)/exeA
	install -D -m 755 -t $(imagedir)/	$(exeB)/exeB
	mksquashfs $(imagedir) $(imagefile)

sign: install
	gpg --detach-sign $(imagefile)
	mkdir $(imagenamebase)
	mv $(imagefile) $(imagefile).sig $(imagenamebase)
	zip -r $(imagenamebase).zip $(imagenamebase)
	rm -rf $(imagenamebase)
	$(eval versionAutoNum=$(shell echo $$(($(versionAutoNum)+1))))
	@echo $(versionAutoNum) > $(autoNumFile)

clean:
	$(MAKE) -C . TARGET=clean
	rm -rf image *.squashfs *.zip

$(exeA) $(exeB) $(libraries):
	$(MAKE) --directory=$@ $(TARGET)

# Configure the various module dependencies
$(exeA): $(libA)
