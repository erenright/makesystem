# Basic application data
partNumber		:= 12345
appName			:= APPNAME

# Version number
versionMajor	:= 1
versionMinor	:= 0
# versionMinor with leading zeroes stripped
versionMinorEx  := $(shell echo $(versionMinor) | sed -E 's/^0+([0-9]+)/\1/')
versionRevision	:= dev
versionAutoNum	:= 0
autoNumFile		:= .autonum

ifeq ($(origin CI_COMMIT_SHORT_SHA), undefined)
# If not building under GitLab, auto-increment the build number
	num := $(shell cat ${autoNumFile})
	ifeq ($(num),)
	else
		versionAutoNum := $(num)
	endif

	versionRevision := $(versionRevision)$(versionAutoNum)
else
# Otherwise, override version revision
	versionRevision := $(CI_COMMIT_SHORT_SHA)
endif

# If debug build, append "-debug" to the string
ifeq ($(DEBUG), 1)
	versionRevision := $(versionRevision)-debug
endif

CPPFLAGS		+= -DVERSIONMAJOR=$(versionMajor) -DVERSIONMINOR=$(versionMinorEx) -D$(appName)
export CPPFLAGS
