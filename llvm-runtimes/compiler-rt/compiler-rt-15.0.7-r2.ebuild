# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit cmake flag-o-matic llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="Compiler runtime library for clang (built-in part)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="${LLVM_VERSION}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="+abi_x86_32 abi_x86_64 +atomic-builtins +clang debug test"
REQUIRED_USE="atomic-builtins? ( clang )"
RESTRICT="!test? ( test ) !clang? ( test )"

DEPEND="
	llvm-core/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? ( llvm-core/clang:${LLVM_MAJOR} )
	test? (
		$(python_gen_any_dep ">=dev-python/lit-15[\${PYTHON_USEDEP}]")
		=llvm-core/clang-${LLVM_VERSION}*:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
"

LLVM_COMPONENTS=( compiler-rt cmake llvm/cmake )
LLVM_PATCHSET=${PV/_/-}
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-15[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if ! use clang && ! tc-is-clang; then
		ewarn "Building using a compiler other than clang may result in broken atomics"
		ewarn "library. Enable USE=clang unless you have a very good reason not to."
	fi
}

pkg_setup() {
	# Darwin Prefix builds do not have llvm installed yet, so rely on
	# bootstrap-prefix to set the appropriate path vars to LLVM instead
	# of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version llvm-core/llvm; then
		LLVM_MAX_SLOT=${LLVM_MAJOR} llvm_pkg_setup
	fi
	python-any-r1_pkg_setup
}

test_compiler() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	if use clang; then
		# Only do this conditionally to allow overriding with
		# e.g. CC=clang-13 in case of breakage
		if ! tc-is-clang ; then
			local -x CC=${CHOST}-clang
			local -x CXX=${CHOST}-clang++
		fi

		strip-unsupported-flags
	fi

	if ! test_compiler; then
		local nolib_flags=( -nodefaultlibs -lc )

		if test_compiler "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		elif test_compiler "${nolib_flags[@]}" -nostartfiles; then
			# Avoiding -nostartfiles earlier on for bug #862540,
			# and set available entry symbol for bug #862798.
			nolib_flags+=( -nostartfiles -emain )

			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${LLVM_VERSION}"

		-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=$(usex !atomic-builtins)
		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
		-DCOMPILER_RT_BUILD_MEMPROF=OFF
		-DCOMPILER_RT_BUILD_ORC=OFF
		-DCOMPILER_RT_BUILD_PROFILE=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if use amd64; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=$(usex abi_x86_32)
			-DCAN_TARGET_x86_64=$(usex abi_x86_64)
		)
	fi

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# setting -isysroot is disabled with compiler-rt-prefix-paths.patch
			# this allows adding arm64 support using SDK in EPREFIX
			-DDARWIN_macosx_CACHED_SYSROOT="${EPREFIX}/MacOSX.sdk"
			# Set version based on the SDK in EPREFIX.
			# This disables i386 for SDK >= 10.15
			-DDARWIN_macosx_OVERRIDE_SDK_VERSION="$(realpath "${EPREFIX}/MacOSX.sdk" | sed -e 's/.*MacOSX\(.*\)\.sdk/\1/')"
			# Use our libtool instead of looking it up with xcrun
			-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			-DCOMPILER_RT_TEST_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang++"
		)
	fi

	cmake_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-builtins
}
