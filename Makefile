CXX ?= c++
# SOURCES = atom.cpp file.cpp main.cpp mp4.cpp track.cpp
SOURCES = $(shell echo *.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
INCLUDE = -I./ -I./ffmpeg
PKGDEPS = libavcodec libavformat
PKGLDFLAGS = $(shell pkg-config --libs $(PKGDEPS))

untrunc: $(OBJECTS)
	# $(CC) -I$(INCLUDE) $(CPPFLAGS) $(CXXFLAGS) $(OBJECTS) $$(pkg-config --libs $(PKGDEPS)) -o untrunc
	$(CXX) $(INCLUDE) $(CPPFLAGS) $(CXXFLAGS) $(OBJECTS) $(PKGLDFLAGS) -o untrunc

ffmpeg/configure:
	git submodule update --init --depth 1 ffmpeg

ffmpeg/config.h: ffmpeg/configure
	cd ffmpeg; ./configure

%.o: %.cpp ffmpeg/config.h
	$(CXX) $(INCLUDE) $(CPPFLAGS) $(CXXFLAGS) $(PKGCFLAGS) -c $< -o $@

clean:
	rm -f *.o untrunc
	(test -d ffmpeg && cd ffmpeg; git reset --hard; git clean -xdf) || true
