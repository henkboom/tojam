NAME="tea-time-quarrel"

PLATFORMS=linux macosx mingw

$(PLATFORMS) clean:
	make -C dokidoki-support $@ NAME="../$(NAME)"
