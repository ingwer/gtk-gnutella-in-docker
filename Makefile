IMAGE = gtkgnutella
GTK_GNUTELLA_VERSION = 1.1.15
TAG = latest
EXTDISPLAY = ${DISPLAY}

build:
	docker build --build-arg VERSION=$(GTK_GNUTELLA_VERSION) -t $(IMAGE):$(TAG) .

up:
	@docker run --rm \
		-v $(CURDIR):/data \
		alpine:3.11 sh -c '[ -d /data/downloads ] || (mkdir -p /data/downloads/ && chmod -R 777 /data/downloads)'
	@docker run -it --rm \
		-e DISPLAY=$(EXTDISPLAY) \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $(CURDIR)/downloads:/home/user/gtk-gnutella-downloads \
		$(IMAGE):$(TAG)
