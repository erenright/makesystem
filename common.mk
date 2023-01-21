# Set to 1 to enable debugging
# Be sure to clean and rebuild after modifying
DEBUG=0

MV				:= mv -f
RM				:= rm -f
SED				:= sed

# If building for docker/host system, add extra options
# Otherwise, specify the cross compiler
ifeq ($(DOCKER),1)
	# Add any extra options here...
else
	CROSS		:= arm-linux-
endif

CC				:= $(CROSS)gcc
LD				:= $(CROSS)ld
AR				:= $(CROSS)ar

objects			:= $(subst .c,.o,$(sources))
dependencies	:= $(subst .c,.d,$(sources))

# Add any custom global cpp flags you might need here...
CPPFLAGS		+= -DSOMETHING=1

# General flags and includes
include_dirs	:= ../libA
CFLAGS			+= -Wall -Werror

ifeq ($(DEBUG),1)
	CFLAGS		+= -ggdb
else
	CFLAGS		+= -O3
endif

# Combine include dirs for the pre-processor
CPPFLAGS		+= $(addprefix -I,$(include_dirs))

vpath %.h $(include_dirs)

.PHONY: library
library: $(library)

$(library): $(objects)
	$(AR) $(ARFLAGS) $@ $^

.PHONY: program
program: $(program)

$(program): $(objects) $(libraries)
	$(CC) -o $(program) $(LDFLAGS) $(objects) $(libraries) $(LDLIBS)

.PHONY: clean
clean:
	$(RM) $(objects) $(program) $(library) $(dependencies)

ifneq "$(MAKECMDGOALS)" "clean"
  -include $(dependencies)
endif

%.c %.h: %.y
	$(YACC.y) --defines $<
	$(MV) y.tab.c $*.c
	$(MV) y.tab.h $*.h

%.d: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -M $< |      \
	$(SED) 's,\($*\.o\) *:,\1 $@: ,' > $@.tmp
	$(MV) $@.tmp $@
