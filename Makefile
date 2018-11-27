
lib_dir = $(shell pwd)
install_dir = $(lib_dir)/build_dir
dl_dir=$(lib_dir)/dl

all: pre json curl openssl

pre:
	mkdir -p $(lib_dir)
	mkdir -p $(dl_dir)
	mkdir -p $(install_dir)

define download
	if ! [ -f $(dl_dir)/$(1) ]; then wget $(2) -O $(dl_dir)/$(1); fi
	if ! [ -d $(3) ]; then tar -zxvf $(dl_dir)/$(1) -C $(lib_dir); fi
endef

all: json curl openssl

json_name=json-c
json_version=0.13.1-20180305
json_addr=https://github.com/json-c/json-c/archive
json_dl=$(json_name)-$(json_version).tar.gz
json_dir = $(lib_dir)/$(json_name)-$(json_name)-$(json_version)
json: pre
	$(call download,$(json_dl),$(json_addr)/$(json_dl),$(json_dir))
	cd $(json_dir) && ./configure --prefix=$(install_dir) && make && make install


curl_name=curl
curl_version=7.62.0
curl_addr=https://curl.haxx.se/download
curl_dl=$(curl_name)-$(curl_version).tar.gz
curl_dir = $(lib_dir)/$(curl_name)-$(curl_version)
curl: pre
	$(call download,$(curl_dl),$(curl_addr)/$(curl_dl),$(curl_dir))
	cd $(curl_dir) && ./configure --prefix=$(install_dir) && make && make install

openssl_name=openssl
openssl_version=1.1.1
openssl_addr=https://www.openssl.org/source/old/$(openssl_version)
openssl_dl=$(openssl_name)-$(openssl_version).tar.gz
openssl_dir = $(lib_dir)/$(openssl_name)-$(openssl_version)
openssl: pre
	$(call download,$(openssl_dl),$(openssl_addr)/$(openssl_dl),$(openssl_dir))
	cd $(openssl_dir) && ./config --prefix=$(install_dir) && make && make install

.PHONY:pre json curl openssl
