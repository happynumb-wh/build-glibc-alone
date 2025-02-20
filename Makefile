PWD						= $(shell pwd)
GLIBC_DIR				= $(PWD)/glibc
LINUX_HEADERS_SRCDIR	= $(PWD)/linux-headers


BUILD_DIR				= $(PWD)/build
INSTALL_DIR				= $(PWD)/glibc-bin


.PHONY :all clean

all: build-glibc build

build-glibc: build
ifeq ($(wildcard $(GLIBC_DIR)/*),)
	git submodule update --init $(GLIBC_DIR)
endif
	CC="riscv64-unknown-linux-gnu-gcc " \
	CXX="this-is-not-the-compiler-youre-looking-for" \
	CFLAGS=" -g  -mcmodel=medlow -O2 " \
	CXXFLAGS=" -g  -mcmodel=medlow -O2 " \
	ASFLAGS=" -g -mcmodel=medlow " \
	cd ${BUILD_DIR} && ${GLIBC_DIR}/configure \
		--host=riscv64-unknown-linux-gnu \
		--prefix=/usr \
		--disable-werror \
		--enable-shared \
		--enable-obsolete-rpc \
		--with-headers=${LINUX_HEADERS_SRCDIR}/include \
		--disable-multilib \
		--enable-kernel=3.0.0 \
		--libdir=/usr/lib libc_cv_slibdir=/lib libc_cv_rtlddir=/lib	

	$(MAKE) -C $(BUILD_DIR)
	$(MAKE) -C $(BUILD_DIR) install install_root=$(INSTALL_DIR) 

build:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(INSTALL_DIR)/usr/
	cp -a ${LINUX_HEADERS_SRCDIR}/include ${INSTALL_DIR}/usr/



clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(INSTALL_DIR)


