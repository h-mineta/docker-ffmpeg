FROM alpine:latest

ENV FFMPEG_VERSION=4.2.2

RUN set -x \
	&& apk upgrade --update \
	&& apk add \
		ca-certificates \
		openssl \
		lame \
		libogg \
		x264-libs \
		x265 \
		libvpx \
		libvorbis \
		libpng \
		freetype \
		librtmp \
		libtheora \
		libwebp \
		libass \
		opus \
		faac \
	\
	&& apk add --virtual .build-deps \
		build-base \
		curl \
		nasm \
		tar \
		bzip2 \
		zlib-dev \
		openssl-dev \
		yasm-dev \
		lame-dev \
		libogg-dev \
		x264-dev \
		x265-dev \
		libvpx-dev \
		libvorbis-dev \
		freetype-dev \
		libass-dev \
		libwebp-dev \
		rtmpdump-dev \
		libtheora-dev \
		opus-dev \
		faac-dev \
		mercurial \
		cmake \
	\
	&& cd /tmp \
	&& curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . \
	&& cd ffmpeg-${FFMPEG_VERSION} \
	&& CFLAGS="-march=native -O2 -m64 -pipe -fomit-frame-pointer" \
		CXXFLAGS="-march=native -O2 -m64 -pipe -fomit-frame-pointer" \
		./configure \
		--enable-version3 \
		--enable-gpl \
		--enable-nonfree \
		--enable-small \
		--enable-libmp3lame \
		--enable-libx264 \
		--enable-libx265 \
		--enable-libvpx \
		--enable-libtheora \
		--enable-libvorbis \
		--enable-libopus \
		--enable-libass \
		--enable-libwebp \
		--enable-librtmp \
		--enable-postproc \
		--enable-avresample \
		--enable-libfreetype \
		--enable-openssl \
		--enable-static \
		--disable-shared \
		--disable-debug \
		--extra-cflags="-I/usr/local/include -I/usr/include" \
		--extra-ldflags="-L/usr/local/lib" \
	\
	&& make -j \
	&& make install \
	&& make distclean \
	\
	# cleaning
	&& cd / \
	&& apk del --purge .build-deps \
	&& rm -rf /tmp/* \
	&& rm -rf /var/cache/apk/* \
	\
	&& mkdir -p /tmp/ffmpeg

WORKDIR /tmp/ffmpeg
ENTRYPOINT ["ffmpeg"]
