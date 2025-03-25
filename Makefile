PLATFORM?=linux_x86_64

CC = gcc

SRC = src

CFLAGS += -Wall 
CFLAGS += -Wextra 
CFLAGS += -pedantic 
CFLAGS += -O2
CFLAGS += $$(pkg-config --cflags vulkan)
CFLAGS += -I$(SRC)

LIBS += -lm
LIBS += $$(pkg-config --libs vulkan)
LIBS += -lalloc


TARGET=libhive.a
CACHE=.cache
OUTPUT=$(CACHE)/release


#MODULE += hivewindow.o

TEST += test.o


-include config/$(PLATFORM).mk


OBJ = $(addprefix $(CACHE)/,$(MODULE))
T_OBJ = $(addprefix $(CACHE)/,$(TEST))


all: env $(OBJ)
	ar -crs $(OUTPUT)/$(TARGET) $(OBJ)


%.o:
	$(CC) $(CFLAGS) -c $< -o $@


-include dep.list


exec: env $(OBJ) $(T_OBJ)
	$(CC) $(T_OBJ) $(OBJ) $(LIBS) -o $(OUTPUT)/test
	$(OUTPUT)/test


.PHONY: env dep clean


dep:
	$(FIND) src test -name "*.c" | xargs $(CC) -I$(SRC) -MM | sed 's|[a-zA-Z0-9_-]*\.o|$(CACHE)/&|' > dep.list


env:
	mkdir -pv $(CACHE)
	mkdir -pv $(OUTPUT)


install:
	mkdir -pv $(INDIR)
	cp -v $(OUTPUT)/$(TARGET) $(LIBDIR)/$(TARGET)
	cp -vr $(SRC)/include $(INDIR)


clean: 
	rm -rvf $(OUTPUT)
	rm -vf $(CACHE)/*.o



