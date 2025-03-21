# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.2

EAPI=8

CRATES="
	emlop@0.7.1
	adler2@2.0.0
	aho-corasick@1.1.3
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.89
	assert_cmd@2.0.13
	atoi@2.0.0
	autocfg@1.3.0
	bstr@1.10.0
	cfg-if@1.0.0
	clap@4.4.18
	clap_builder@4.4.18
	clap_complete@4.4.10
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.2
	crc32fast@1.4.2
	crossbeam-channel@0.5.13
	crossbeam-utils@0.8.20
	deranged@0.3.11
	difflib@0.4.0
	doc-comment@0.3.3
	env_filter@0.1.2
	env_logger@0.11.5
	equivalent@1.0.1
	flate2@1.0.33
	hashbrown@0.14.5
	heck@0.4.1
	indexmap@2.5.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	libc@0.2.159
	log@0.4.22
	memchr@2.7.4
	miniz_oxide@0.8.0
	num-conv@0.1.0
	num-traits@0.2.19
	num_threads@0.1.7
	powerfmt@0.2.0
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	proc-macro2@1.0.86
	quote@1.0.37
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.6
	rev_lines@0.3.0
	ryu@1.0.18
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	serde_spanned@0.6.7
	strsim@0.10.0
	syn@2.0.77
	termtree@0.4.1
	thiserror-impl@1.0.64
	thiserror@1.0.64
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.21
	unicode-ident@1.0.13
	utf8parse@0.2.2
	wait-timeout@0.2.0
	windows-sys@0.52.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.6.20
"

RUST_MIN_VER="1.71.1"

inherit cargo shell-completion

DESCRIPTION="A fast, accurate, ergonomic emerge.log parser"
HOMEPAGE="https://github.com/vincentdephily/emlop"
SRC_URI="
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	   MIT Unicode-DFS-2016
	   || ( Apache-2.0 Boost-1.0 )
"

SLOT="0"
KEYWORDS="amd64"

# rust does not use *FLAGS from make.conf, silence portage warning
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install
	dodoc README.md CHANGELOG.md emlop.toml
	newbashcomp completion.bash emlop
	newfishcomp completion.fish emlop.fish
	newzshcomp completion.zsh _emlop
}
