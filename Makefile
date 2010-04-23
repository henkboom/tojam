NAME=tojam

PLATFORMS=linux macosx mingw

$(PLATFORMS) clean:
	make -C dokidoki-support $@ NAME="../$(NAME)"
