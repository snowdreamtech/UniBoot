# Changelog

## [1.3.0](https://github.com/snowdreamtech/UniBoot/compare/v1.2.0...v1.3.0) (2026-10-11)


### 🚀 Features

* add local-first triple fallback iPXE entry and custom menu templates ([9864f7a](https://github.com/snowdreamtech/UniBoot/commit/9864f7a6e6525e23418bede762d59b51fe329575))
* add Netboot.xyz binaries and custom GRUB configuration ([b0024f8](https://github.com/snowdreamtech/UniBoot/commit/b0024f8a7c024707e1bed9db39d551ee957c4ac4))
* **build:** auto-generate embedded boot.ipxe from uniboot.ipxe in ISO generator and CI pipeline ([ed9d28e](https://github.com/snowdreamtech/UniBoot/commit/ed9d28eef6b352df13456c98c7e3fec7bc5e0d26))
* configure main screen image_list and bilingual menu aliases ([ef8bc10](https://github.com/snowdreamtech/UniBoot/commit/ef8bc109f80892a0f3432e56a68a217992275831))
* **core:** merge all dev enhancements into main as single consolidated release ([90a134d](https://github.com/snowdreamtech/UniBoot/commit/90a134dcb15a0523e2570b7cc0938b07aa4dd87e))
* initialize UniBoot project repository ([b40cfc2](https://github.com/snowdreamtech/UniBoot/commit/b40cfc2537907f72098a0b16272bcd2bdba81fe0))
* **ipxe:** add undionly.kpxe compilation target and ISO staging support ([a4aa205](https://github.com/snowdreamtech/UniBoot/commit/a4aa2053e09c1609aacdb4b0d546f47e093f0118))
* **ipxe:** embed UniBoot offline menu with EFI local file fallback and align color palette ([aeed7de](https://github.com/snowdreamtech/UniBoot/commit/aeed7de8f5719ae2e4bca1677721da850a051220))
* **ipxe:** enable full HTTPS support, embedded script, and custom boot menu ([6b97a86](https://github.com/snowdreamtech/UniBoot/commit/6b97a86dc39cb67b032252e7553308c7feed0455))
* **ipxe:** enable local-first USB menu loading with cloud fallback for BIOS and UEFI ([aca1b09](https://github.com/snowdreamtech/UniBoot/commit/aca1b09c48f2e439f54f734415e10538605e45ee))
* **ipxe:** implement github actions workflow to compile cross-arch efi binaries with embedded scripts ([9186b16](https://github.com/snowdreamtech/UniBoot/commit/9186b1681ca16b70137cc8893c9e9e8980662fa1))
* **ipxe:** load brand background image in uniboot.ipxe for visual alignment with Ventoy ([0c9ecc0](https://github.com/snowdreamtech/UniBoot/commit/0c9ecc00ed8a925164d9596896fe8259623a952e))
* **iso:** auto-detect missing iPXE firmware and trigger local compilation ([82145ad](https://github.com/snowdreamtech/UniBoot/commit/82145ad9cf8252c47c3602b9c7f41db09a6ee039))
* **iso:** prioritize local full compilation with fallback to release assets download ([45478d1](https://github.com/snowdreamtech/UniBoot/commit/45478d17be8b3e3e74fd294f3801e75a00947fd8))
* **menu:** replace uniboot.ipxe with official netboot.xyz menu for deep customization ([fc1e0f1](https://github.com/snowdreamtech/UniBoot/commit/fc1e0f14b527962fe9f59099ef3ee2826b947cdd))
* **netboot:** add ARM64 UEFI compatibility and dynamic GRUB detection ([3918403](https://github.com/snowdreamtech/UniBoot/commit/39184031133f4bd0851c911460d9f4ece945d692))
* **netboot:** add cross-platform UniBoot Hybrid ISO generator (BIOS/UEFI dual boot) ([5934cac](https://github.com/snowdreamtech/UniBoot/commit/5934cacb4c8c11974e55d74f07c3d41158f77e76))
* **netboot:** add RISC-V lkrn payload support for non-EFI environments ([31f9dc6](https://github.com/snowdreamtech/UniBoot/commit/31f9dc64581c86ba16515adad08fd3ed7291f9f3))
* **netboot:** add universal omni-architecture support for all EFI platforms ([2c4566b](https://github.com/snowdreamtech/UniBoot/commit/2c4566beac67481e8aedab453cbfecb66d1790b4))
* **netboot:** adopt vanilla iPXE with uniboot.ipxe external hook ([282fb98](https://github.com/snowdreamtech/UniBoot/commit/282fb98ad4dc26b521296d0de552e75887897414))
* **release:** include background.png as release asset for 1:1 Ventoy theme ([d964d41](https://github.com/snowdreamtech/UniBoot/commit/d964d41331da67c4ed821cc4f956ee8e9df8f43c))
* **scripts:** add automated cross-platform QEMU test runner suite ([7c137f7](https://github.com/snowdreamtech/UniBoot/commit/7c137f73627a633d9b2ecb4e722f7daa4eee21b1))
* **scripts:** add fullscreen parameter support to launch QEMU in full screen ([76987a6](https://github.com/snowdreamtech/UniBoot/commit/76987a6286f328eebf4c85cfcb38cee85e71b56a))
* **scripts:** add local iPXE cross-compilation script and --rebuild-ipxe option to sync-and-test.sh ([e8ec333](https://github.com/snowdreamtech/UniBoot/commit/e8ec3335c652bf88a983553f0479c53eed700d99))
* **scripts:** add make_ventoy_theme.py generator script for automated theme asset creation ([b9711f5](https://github.com/snowdreamtech/UniBoot/commit/b9711f58c8487378cdb7c98e63657d2636171690))
* **scripts:** support multi-language slogans in make_ventoy_theme.py generator ([c42cdf5](https://github.com/snowdreamtech/UniBoot/commit/c42cdf5aca9ef112a05ea825d04c2d0d574136b4))
* **ventoy:** design official proprietary UniBoot Ventoy theme and configure in ventoy.json ([8ccc6c1](https://github.com/snowdreamtech/UniBoot/commit/8ccc6c191f499fbe54aa7adbd179c34f081c4a41))
* **ventoy:** hide .efi files on first screen to improve UX ([867be00](https://github.com/snowdreamtech/UniBoot/commit/867be003908d6d08697079443cef11ae2275a0f0))
* **ventoy:** set /iso/UniBoot.iso as default image in ventoy.json ([835f24b](https://github.com/snowdreamtech/UniBoot/commit/835f24bcf76c67d9367e95318a1ce125e54030e8))


### 🐛 Bug Fixes

* **build:** add cloud fallback mechanism if uniboot.ipxe is missing or deleted ([70db090](https://github.com/snowdreamtech/UniBoot/commit/70db090d32794e7303ebc35f60bd43feab235431))
* centralize embedded iPXE generation ([dc1c5ab](https://github.com/snowdreamtech/UniBoot/commit/dc1c5ab7bdc41c1a5ec9e17e2d4d500609d6ab97))
* harden container build dependencies ([bbfed30](https://github.com/snowdreamtech/UniBoot/commit/bbfed30a58da8bbd3af6aebbfefcb665738e236b))
* initialize network before iPXE chaining ([ca4c98d](https://github.com/snowdreamtech/UniBoot/commit/ca4c98dbb694a82ec731580d3071a5bbd74e3866))
* **ipxe:** correct embed script comments to reflect uefi local access limitations ([e90b968](https://github.com/snowdreamtech/UniBoot/commit/e90b968b8ea3ee1b6c2802b8680539a0cc1a9f3d))
* **ipxe:** use GRUB to detect local uniboot.ipxe directly to bypass iPXE fs limitations ([0f64c0e](https://github.com/snowdreamtech/UniBoot/commit/0f64c0e8ad62284eac6d9817708693709ac70582))
* **iso:** correct mformat arguments for 16MB FAT image ([07bf52d](https://github.com/snowdreamtech/UniBoot/commit/07bf52d5ccb06a8d3a7a0d34d6427467b0d93d94))
* **iso:** structure ISO staging path under /ipxe/ and add i18n warnings ([ad368e6](https://github.com/snowdreamtech/UniBoot/commit/ad368e63bb028626545373a43ec1c16f285629bc))
* **netboot:** rename exit option to clarify returning to Ventoy ([94fa12a](https://github.com/snowdreamtech/UniBoot/commit/94fa12af54adab50b87458acb3710907a9105d0d))
* **release:** disable Go binary compilation in GoReleaser for pure asset publishing ([037b19f](https://github.com/snowdreamtech/UniBoot/commit/037b19f4d54b0b905cc68800bf8618080d894e29))
* remove non-image binaries from ventoy.json image_list plugin ([ec46a14](https://github.com/snowdreamtech/UniBoot/commit/ec46a148fcb857a6d6cc4d1178beee718b3c29c2))
* resolve Debian i386 toolchain conflict ([ca736ba](https://github.com/snowdreamtech/UniBoot/commit/ca736ba55b4ea33866d4c178e55b9dc1cc60b1c4))
* **scripts:** add --delete flag to sync script, include iso dir, and refine conditionals ([f9cfc75](https://github.com/snowdreamtech/UniBoot/commit/f9cfc75dd411d918800b84c1c2e912fb96902cfa))
* **scripts:** clean up unused variables and stage uniboot.ipxe in efiboot.img ([b3dc665](https://github.com/snowdreamtech/UniBoot/commit/b3dc6656946d84ccaa5371a2b80e31f9504033d8))
* **scripts:** enhance cross-platform compatibility and auto tool verification across macOS, Linux, and Windows ([b6d50f0](https://github.com/snowdreamtech/UniBoot/commit/b6d50f004b3222df77a681fb22af1fb569715270))
* **scripts:** optimize macOS disk remount in test scripts to target data partition directly ([6447e8c](https://github.com/snowdreamtech/UniBoot/commit/6447e8c58f5ae5b422e27795744e890d245e8574))
* **scripts:** sync assets directory to USB volume to ensure README logo renders ([e6af964](https://github.com/snowdreamtech/UniBoot/commit/e6af964113976eac9ce1ac7d53e80ef2a66585dc))
* set root to vtoy_iso_part in custom grub menu for netboot entries ([35e7bae](https://github.com/snowdreamtech/UniBoot/commit/35e7bae244edbab82aa8596e98231f98fbac9615))
* **theme:** restore integer pixel coordinates and single gfxmode to fix GRUB2 unaligned pointer crash ([2c28d47](https://github.com/snowdreamtech/UniBoot/commit/2c28d4761b4e2cb201aabdf377d121cba9a5f47a))
* **theme:** use full-screen dark transition mode [#070](https://github.com/snowdreamtech/UniBoot/issues/070)A12 to eliminate black popup flicker ([718e1be](https://github.com/snowdreamtech/UniBoot/commit/718e1bebe6d26ff7386f8b298f6e6bfce162e1b1))
* **ventoy:** eliminate black box screen flicker during menu transition ([ef58b88](https://github.com/snowdreamtech/UniBoot/commit/ef58b8876bb2168fc8ee835400df68a28e7b0538))
* **ventoy:** set default gfxmode to 1280x800 for high resolution rendering ([c22a4f9](https://github.com/snowdreamtech/UniBoot/commit/c22a4f9f23f255a15576d4283735d15af566d32b))
* **ventoy:** sync clean control settings and safe inline path grub menu ([56690fb](https://github.com/snowdreamtech/UniBoot/commit/56690fbae8709ea1118dbc145d8dc9f83b54e1d7))
* **workflow:** fix YAML heredoc indentation in build-ipxe.yml using sed strip ([b53a09a](https://github.com/snowdreamtech/UniBoot/commit/b53a09a00c694310fea2b700eb93a442ef60959d))


### 🛠 Refactoring

* **core:** rename netboot directory to ipxe to reflect new standalone architecture ([22149ae](https://github.com/snowdreamtech/UniBoot/commit/22149ae0e44547104b32656775879a1e6d5a07cd))
* **grub:** enhance custom menu with video drivers, i18n, and dynamic search ([9af7a79](https://github.com/snowdreamtech/UniBoot/commit/9af7a79aa1052d60abc28bf733b4b01b7f642d07))
* **ipxe:** merge embed.ipxe into boot.ipxe to eliminate redundant code ([b42f481](https://github.com/snowdreamtech/UniBoot/commit/b42f48131793dba2519af4987aa13acbcf14c1bf))
* move test scripts, add i18n support, and remove obsolete files ([db45ffe](https://github.com/snowdreamtech/UniBoot/commit/db45ffe98da6b00da8edf3abd00cee4b453c3462))
* simplify embedded iPXE entry ([bf7bc93](https://github.com/snowdreamtech/UniBoot/commit/bf7bc931bbe16bee38164e45fd468288593a2514))


### 📖 Documentation

* **agents:** add design and asset alignment policy to AGENTS.md ([d6dd29b](https://github.com/snowdreamtech/UniBoot/commit/d6dd29bf6b750effa52a692db6d239dcc41f8c7a))
* **agents:** add Git Commit Cleanliness Policy - use reset over revert ([bc50d08](https://github.com/snowdreamtech/UniBoot/commit/bc50d084684786482b2a70b6ba2fd872806578fa))
* **agents:** add workspace rules for atomic execution, commit policy, and shell script quality ([2d307f8](https://github.com/snowdreamtech/UniBoot/commit/2d307f8a61c4e7b7b32671bb434c611dcdd0b161))
* align ISO search directory path in architecture documentation ([d8ba3a7](https://github.com/snowdreamtech/UniBoot/commit/d8ba3a7cc9e9dc83441174f17b70b1b804dcee00))
* **brand:** design UniBoot logo assets, banner, and integrate into README ([1aaccb0](https://github.com/snowdreamtech/UniBoot/commit/1aaccb073f828a678f502c1e1d3e330fd8868b9f))
* **license:** update project documentation and license to GPL-2.0 ([09ebf34](https://github.com/snowdreamtech/UniBoot/commit/09ebf34863087aa61d064d074097d8e81f2fd4a7))
* **readme:** add acknowledgements section for ventoy, ipxe, and netboot.xyz ([a98e426](https://github.com/snowdreamtech/UniBoot/commit/a98e42606417a2bff23877d581feb6d1e35be833))
* **release:** add CHANGELOG.md for v1.0.0 release ([125f151](https://github.com/snowdreamtech/UniBoot/commit/125f15180b867963cf495bac85db595237cf4c42))


### ♻️ Miscellaneous Chores

* **build:** untrack precompiled firmware binaries and update gitignore ([763a0f4](https://github.com/snowdreamtech/UniBoot/commit/763a0f4e1804a5657ce0258b9da1f61f7b62d035))
* **qemu:** change default fullscreen mode to off for better developer experience ([5d19b4b](https://github.com/snowdreamtech/UniBoot/commit/5d19b4be6450f001ed7ebedc11bd6fc374e6383a))
* **release:** 1.0.0 🚀 ([ceaaf51](https://github.com/snowdreamtech/UniBoot/commit/ceaaf51e1c5eee31e79db6b3d84c83359c371998))
* **release:** 1.0.0 🚀 ([ee84084](https://github.com/snowdreamtech/UniBoot/commit/ee84084ba9799dfa3fdb400770149b37b5bb8197))
* **release:** 1.1.0 🚀 ([ca8cae9](https://github.com/snowdreamtech/UniBoot/commit/ca8cae93d0e1708239163ce19d1391101fafe246))
* **release:** 1.2.0 🚀 ([d69516d](https://github.com/snowdreamtech/UniBoot/commit/d69516d734da5146d5bb18d3b417923c02068261))
* **release:** remove fixed release-as override for continuous semantic versioning ([348778d](https://github.com/snowdreamtech/UniBoot/commit/348778d8a3be0fbc35df2342ad33c1c5a2299f92))
* **test:** integrate automatic Hybrid ISO generation into sync-and-test flow ([6ecf815](https://github.com/snowdreamtech/UniBoot/commit/6ecf8150cc1852c3e79b028c1070b994fd4aeae8))
* **ventoy:** rename menu labels to UniBoot Network Installation ([cd2595c](https://github.com/snowdreamtech/UniBoot/commit/cd2595c9229b8829b47d16b3d8e24a9f0763eeb0))

## [1.2.0](https://github.com/snowdreamtech/UniBoot/compare/v1.1.0...v1.2.0) (2026-09-16)


### 🚀 Features

* **release:** include background.png as release asset for 1:1 Ventoy theme ([7016ff3](https://github.com/snowdreamtech/UniBoot/commit/7016ff3edbd31ee7b36f6d022ab2d984f0aca2b8))


### 🐛 Bug Fixes

* centralize embedded iPXE generation ([5e76ae5](https://github.com/snowdreamtech/UniBoot/commit/5e76ae5e6934e662a3a7478ce6a18e9ff8284157))
* harden container build dependencies ([c0bf854](https://github.com/snowdreamtech/UniBoot/commit/c0bf8540365864b053cbad885c9437d0d881910f))
* initialize network before iPXE chaining ([8752291](https://github.com/snowdreamtech/UniBoot/commit/87522910ae935bb8525c3d6df52832b66e124356))
* resolve Debian i386 toolchain conflict ([235dcd8](https://github.com/snowdreamtech/UniBoot/commit/235dcd8fe5d5521afea747761896412131485eef))


### 🛠 Refactoring

* simplify embedded iPXE entry ([1cdb144](https://github.com/snowdreamtech/UniBoot/commit/1cdb1441407d51c14f4768c3db56b120ba1e8a69))


### ♻️ Miscellaneous Chores

* **ipxe:** auto-compile lkrn, kpxe and multi-arch EFI binaries with embedded script ([ed2faab](https://github.com/snowdreamtech/UniBoot/commit/ed2faab734241ac3bbe23add178392e924c18524))
* **ipxe:** auto-compile lkrn, kpxe and multi-arch EFI binaries with embedded script ([2e988d6](https://github.com/snowdreamtech/UniBoot/commit/2e988d6affacf8624210633170f3085b58ddbc55))

## [1.1.0](https://github.com/snowdreamtech/UniBoot/compare/v1.0.0...v1.1.0) (2026-09-13)


### 🚀 Features

* **ipxe:** add undionly.kpxe compilation target and ISO staging support ([7b1029b](https://github.com/snowdreamtech/UniBoot/commit/7b1029bc5aab9402358dd3a5f886f64e0e1411fa))
* **scripts:** add local iPXE cross-compilation script and --rebuild-ipxe option to sync-and-test.sh ([73da965](https://github.com/snowdreamtech/UniBoot/commit/73da965075a67c41a3df3faa08b9eef78a3881f6))


### ♻️ Miscellaneous Chores

* **ipxe:** auto-compile lkrn, kpxe and multi-arch EFI binaries with embedded script ([ba824c8](https://github.com/snowdreamtech/UniBoot/commit/ba824c821bf81908c8a6751f145935c909caea26))
* **release:** remove fixed release-as override for continuous semantic versioning ([41eab8a](https://github.com/snowdreamtech/UniBoot/commit/41eab8a8e2661f4861524b435ba862ea2a5c8b8a))

## [1.0.0](https://github.com/snowdreamtech/UniBoot/compare/v1.0.0...v1.0.0) (2026-09-11)


### 🚀 Features

* add local-first triple fallback iPXE entry and custom menu templates ([780547c](https://github.com/snowdreamtech/UniBoot/commit/780547c02a908b9d0d73c432523fa069e518bf0c))
* add Netboot.xyz binaries and custom GRUB configuration ([1440ec5](https://github.com/snowdreamtech/UniBoot/commit/1440ec56941377db301851786fd22dcd6828ce5c))
* **build:** auto-generate embedded boot.ipxe from uniboot.ipxe in ISO generator and CI pipeline ([936db3e](https://github.com/snowdreamtech/UniBoot/commit/936db3e8a4e16b98a1c0cc7fe1ac11a5439e9640))
* configure main screen image_list and bilingual menu aliases ([ecd2f32](https://github.com/snowdreamtech/UniBoot/commit/ecd2f326f0c57c73a27764cecf2b01140dd66f27))
* **core:** merge all dev enhancements into main as single consolidated release ([8463705](https://github.com/snowdreamtech/UniBoot/commit/846370556e597f202a2daaf4db797f697df68ff0))
* initialize UniBoot project repository ([c3f4227](https://github.com/snowdreamtech/UniBoot/commit/c3f4227f14d8d13fbf291bbef5a485f83c1b10e0))
* **ipxe:** embed UniBoot offline menu with EFI local file fallback and align color palette ([550d6c0](https://github.com/snowdreamtech/UniBoot/commit/550d6c082213150834f611360023c29959c9ecf4))
* **ipxe:** enable full HTTPS support, embedded script, and custom boot menu ([8aaf867](https://github.com/snowdreamtech/UniBoot/commit/8aaf867beed8358585ea7ca4d35ff126bc69f92f))
* **ipxe:** enable local-first USB menu loading with cloud fallback for BIOS and UEFI ([1aa1163](https://github.com/snowdreamtech/UniBoot/commit/1aa1163e5cfae9692edce30c13f97cc975a0a092))
* **ipxe:** implement github actions workflow to compile cross-arch efi binaries with embedded scripts ([7513fe7](https://github.com/snowdreamtech/UniBoot/commit/7513fe7ce028fe0cf992d84e9359d8e026c5d6f3))
* **ipxe:** load brand background image in uniboot.ipxe for visual alignment with Ventoy ([fd38b02](https://github.com/snowdreamtech/UniBoot/commit/fd38b029de0a004692a8f1b67fb19806793517c0))
* **menu:** replace uniboot.ipxe with official netboot.xyz menu for deep customization ([480909d](https://github.com/snowdreamtech/UniBoot/commit/480909d3fae6732c1682881d43dfff97b16f544a))
* **netboot:** add ARM64 UEFI compatibility and dynamic GRUB detection ([b725078](https://github.com/snowdreamtech/UniBoot/commit/b725078c449ae2ae6feb9a58d526dc2408b7e7da))
* **netboot:** add cross-platform UniBoot Hybrid ISO generator (BIOS/UEFI dual boot) ([45b5b4b](https://github.com/snowdreamtech/UniBoot/commit/45b5b4ba7ea31e5885aa39ffe3e893bc343150da))
* **netboot:** add RISC-V lkrn payload support for non-EFI environments ([f878cd4](https://github.com/snowdreamtech/UniBoot/commit/f878cd42e727079b1bae21a2af884531816c36ec))
* **netboot:** add universal omni-architecture support for all EFI platforms ([ffa4ed7](https://github.com/snowdreamtech/UniBoot/commit/ffa4ed71d942fabfb4244fafd0cd3b5ff1a12087))
* **netboot:** adopt vanilla iPXE with uniboot.ipxe external hook ([39b883d](https://github.com/snowdreamtech/UniBoot/commit/39b883d1e9b8a0cad0dbe9e4a5ceb1f3f5e3f43b))
* **scripts:** add automated cross-platform QEMU test runner suite ([65f5226](https://github.com/snowdreamtech/UniBoot/commit/65f52265c0821c6871b545c8e9b925b08df8ea63))
* **scripts:** add fullscreen parameter support to launch QEMU in full screen ([dcf0443](https://github.com/snowdreamtech/UniBoot/commit/dcf0443d8aa93ef16b61ee2301373ae18fcd66b8))
* **scripts:** add make_ventoy_theme.py generator script for automated theme asset creation ([68611e6](https://github.com/snowdreamtech/UniBoot/commit/68611e6450f352a87bf391f0363fd4c1820167d0))
* **scripts:** support multi-language slogans in make_ventoy_theme.py generator ([3af65b2](https://github.com/snowdreamtech/UniBoot/commit/3af65b25403910064c6b7479b0e137fb49484098))
* **ventoy:** design official proprietary UniBoot Ventoy theme and configure in ventoy.json ([f92d528](https://github.com/snowdreamtech/UniBoot/commit/f92d5283335ae9a58a854ed4d386849a55876972))
* **ventoy:** hide .efi files on first screen to improve UX ([ac15526](https://github.com/snowdreamtech/UniBoot/commit/ac1552689c5a85068f1f09b33578817bcd71262d))
* **ventoy:** set /iso/UniBoot.iso as default image in ventoy.json ([d32554f](https://github.com/snowdreamtech/UniBoot/commit/d32554f023808f95c4490e7a8b2bb77687a0be23))


### 🐛 Bug Fixes

* **build:** add cloud fallback mechanism if uniboot.ipxe is missing or deleted ([c992a86](https://github.com/snowdreamtech/UniBoot/commit/c992a861ceb86f453c1b893e4580c39895a05611))
* **ipxe:** correct embed script comments to reflect uefi local access limitations ([184f24d](https://github.com/snowdreamtech/UniBoot/commit/184f24d3179bf5ad11557634e278c2213c6c4451))
* **ipxe:** use GRUB to detect local uniboot.ipxe directly to bypass iPXE fs limitations ([f78160e](https://github.com/snowdreamtech/UniBoot/commit/f78160e1fd7d0eeb5c0ace517a96a7eb3f67b9d8))
* **iso:** correct mformat arguments for 16MB FAT image ([ed23789](https://github.com/snowdreamtech/UniBoot/commit/ed2378963c8ebc67750167f88d9feeeae17da347))
* **iso:** structure ISO staging path under /ipxe/ and add i18n warnings ([651239a](https://github.com/snowdreamtech/UniBoot/commit/651239a16ca10be2cf78ef081b223e1b5c789480))
* **netboot:** rename exit option to clarify returning to Ventoy ([9107b1d](https://github.com/snowdreamtech/UniBoot/commit/9107b1d7752a47fa4287b0f39900c6354d5becac))
* **release:** disable Go binary compilation in GoReleaser for pure asset publishing ([472599a](https://github.com/snowdreamtech/UniBoot/commit/472599a4b7ef7ebeedcd4ae91101069a95eae7c2))
* remove non-image binaries from ventoy.json image_list plugin ([e94a17c](https://github.com/snowdreamtech/UniBoot/commit/e94a17c327fd45dc8b45179235537cd6e2d42825))
* **scripts:** add --delete flag to sync script, include iso dir, and refine conditionals ([5b10f94](https://github.com/snowdreamtech/UniBoot/commit/5b10f94cdfcf68b70b48f4eb46111e653a4fc803))
* **scripts:** clean up unused variables and stage uniboot.ipxe in efiboot.img ([4aa39d1](https://github.com/snowdreamtech/UniBoot/commit/4aa39d1556ccfde48d3bc49588d3ea603dd11376))
* **scripts:** enhance cross-platform compatibility and auto tool verification across macOS, Linux, and Windows ([898f09b](https://github.com/snowdreamtech/UniBoot/commit/898f09b5a6ecf5cb3baae5e1cf731279cbdb0677))
* **scripts:** optimize macOS disk remount in test scripts to target data partition directly ([9dd1b0c](https://github.com/snowdreamtech/UniBoot/commit/9dd1b0c26aeb334797c60d2e49b487458d5ef60a))
* **scripts:** sync assets directory to USB volume to ensure README logo renders ([33c9005](https://github.com/snowdreamtech/UniBoot/commit/33c90056bd21ea5bed53ffa1ca864c8197caeada))
* set root to vtoy_iso_part in custom grub menu for netboot entries ([96ccec1](https://github.com/snowdreamtech/UniBoot/commit/96ccec1d7f1f8eb6fd4c66d361f967821be4c6b8))
* **theme:** restore integer pixel coordinates and single gfxmode to fix GRUB2 unaligned pointer crash ([1255c5f](https://github.com/snowdreamtech/UniBoot/commit/1255c5f6f9acbbb91d960b84528d92fd9e969316))
* **theme:** use full-screen dark transition mode [#070](https://github.com/snowdreamtech/UniBoot/issues/070)A12 to eliminate black popup flicker ([f609a01](https://github.com/snowdreamtech/UniBoot/commit/f609a015df9dccdccb5fdca47df6e872678e0d6b))
* **ventoy:** eliminate black box screen flicker during menu transition ([888c7af](https://github.com/snowdreamtech/UniBoot/commit/888c7aff59c81717fcb3ec42ea29135b88cbcde5))
* **ventoy:** set default gfxmode to 1280x800 for high resolution rendering ([3966b16](https://github.com/snowdreamtech/UniBoot/commit/3966b160a620f312a14b6aa36f2c913f27c1b280))
* **ventoy:** sync clean control settings and safe inline path grub menu ([ffe83bd](https://github.com/snowdreamtech/UniBoot/commit/ffe83bdb2d32f5b29110ed10a3d68550b0e7f3d0))
* **workflow:** fix YAML heredoc indentation in build-ipxe.yml using sed strip ([d3dd49f](https://github.com/snowdreamtech/UniBoot/commit/d3dd49fb2b71409ef9b89c6693bfa8bd92add9c6))


### 🛠 Refactoring

* **core:** rename netboot directory to ipxe to reflect new standalone architecture ([cb04148](https://github.com/snowdreamtech/UniBoot/commit/cb04148a6b2b2c4e8d978b46bf8955a4ddefbd6d))
* **grub:** enhance custom menu with video drivers, i18n, and dynamic search ([ad9594f](https://github.com/snowdreamtech/UniBoot/commit/ad9594f8cd093d4b502a8a6ee001a7f53dc9fc7c))
* **ipxe:** merge embed.ipxe into boot.ipxe to eliminate redundant code ([9e7b9e0](https://github.com/snowdreamtech/UniBoot/commit/9e7b9e01ca434ba047605fbf8af0ff0f2ca0d727))
* move test scripts, add i18n support, and remove obsolete files ([a9b432a](https://github.com/snowdreamtech/UniBoot/commit/a9b432ad969c953b7a264f50b49e67a8f7f72734))


### 📖 Documentation

* **agents:** add design and asset alignment policy to AGENTS.md ([37f388e](https://github.com/snowdreamtech/UniBoot/commit/37f388e7376296bec534488292c6fb34ff983e46))
* **agents:** add Git Commit Cleanliness Policy - use reset over revert ([45ede5d](https://github.com/snowdreamtech/UniBoot/commit/45ede5d3a57865fa6281d1d3330f1c6c02ba75d7))
* **agents:** add workspace rules for atomic execution, commit policy, and shell script quality ([b73bccd](https://github.com/snowdreamtech/UniBoot/commit/b73bccd89b3b215be9d3c4b8243e8dfcce1c99d2))
* align ISO search directory path in architecture documentation ([ff28664](https://github.com/snowdreamtech/UniBoot/commit/ff28664f895de9c0050d256676cf0089c0d1101f))
* **brand:** design UniBoot logo assets, banner, and integrate into README ([251eaae](https://github.com/snowdreamtech/UniBoot/commit/251eaaeba26db3f46c0c8ad5719b83868cb8b3e3))
* **license:** update project documentation and license to GPL-2.0 ([ae9a547](https://github.com/snowdreamtech/UniBoot/commit/ae9a54790f6923cbbe29e83782e3aced56b0f5c7))
* **readme:** add acknowledgements section for ventoy, ipxe, and netboot.xyz ([8fb68f2](https://github.com/snowdreamtech/UniBoot/commit/8fb68f297eb21dfa96c1382e79bd1d6ba277ef24))
* **release:** add CHANGELOG.md for v1.0.0 release ([f916591](https://github.com/snowdreamtech/UniBoot/commit/f916591f78bb9fdff8c811ffc4be80f510a7c937))


### ♻️ Miscellaneous Chores

* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([40261e4](https://github.com/snowdreamtech/UniBoot/commit/40261e4aacb246586942f846b739727c8b73b74e))
* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([ec45147](https://github.com/snowdreamtech/UniBoot/commit/ec451478b7cc3205cb13f602556203b860411070))
* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([647741c](https://github.com/snowdreamtech/UniBoot/commit/647741cccb937ffe2e7a44bdcf2bb7d6b03750de))
* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([83eaeaa](https://github.com/snowdreamtech/UniBoot/commit/83eaeaa4cc71867140665815ddf2d24954b4722e))
* **ipxe:** update compiled lkrn and multi-arch EFI binaries with full HTTPS support ([a3372c9](https://github.com/snowdreamtech/UniBoot/commit/a3372c960326f2030e1fab5d0a71077125fefe41))
* **qemu:** change default fullscreen mode to off for better developer experience ([fda7716](https://github.com/snowdreamtech/UniBoot/commit/fda7716be5ca03ecebd2ce5ef22d6a3431e58afc))
* **release:** 1.0.0 🚀 ([aa9002b](https://github.com/snowdreamtech/UniBoot/commit/aa9002b01dc791c921b0c09675485b92d43154e9))
* **test:** integrate automatic Hybrid ISO generation into sync-and-test flow ([5ee50f3](https://github.com/snowdreamtech/UniBoot/commit/5ee50f31c6128bee1f5181c00f681e53f2e0e0c2))
* **ventoy:** rename menu labels to UniBoot Network Installation ([ddb7af1](https://github.com/snowdreamtech/UniBoot/commit/ddb7af15acd3adc45f26979ee8ecbbb239682adf))

## [1.0.0](https://github.com/snowdreamtech/UniBoot/compare/v0.1.0...v1.0.0) (2026-09-11)


### 🚀 Features

* add local-first triple fallback iPXE entry and custom menu templates ([780547c](https://github.com/snowdreamtech/UniBoot/commit/780547c02a908b9d0d73c432523fa069e518bf0c))
* add Netboot.xyz binaries and custom GRUB configuration ([1440ec5](https://github.com/snowdreamtech/UniBoot/commit/1440ec56941377db301851786fd22dcd6828ce5c))
* **build:** auto-generate embedded boot.ipxe from uniboot.ipxe in ISO generator and CI pipeline ([936db3e](https://github.com/snowdreamtech/UniBoot/commit/936db3e8a4e16b98a1c0cc7fe1ac11a5439e9640))
* configure main screen image_list and bilingual menu aliases ([ecd2f32](https://github.com/snowdreamtech/UniBoot/commit/ecd2f326f0c57c73a27764cecf2b01140dd66f27))
* **core:** merge all dev enhancements into main as single consolidated release ([8463705](https://github.com/snowdreamtech/UniBoot/commit/846370556e597f202a2daaf4db797f697df68ff0))
* initialize UniBoot project repository ([c3f4227](https://github.com/snowdreamtech/UniBoot/commit/c3f4227f14d8d13fbf291bbef5a485f83c1b10e0))
* **ipxe:** embed UniBoot offline menu with EFI local file fallback and align color palette ([550d6c0](https://github.com/snowdreamtech/UniBoot/commit/550d6c082213150834f611360023c29959c9ecf4))
* **ipxe:** enable full HTTPS support, embedded script, and custom boot menu ([8aaf867](https://github.com/snowdreamtech/UniBoot/commit/8aaf867beed8358585ea7ca4d35ff126bc69f92f))
* **ipxe:** enable local-first USB menu loading with cloud fallback for BIOS and UEFI ([1aa1163](https://github.com/snowdreamtech/UniBoot/commit/1aa1163e5cfae9692edce30c13f97cc975a0a092))
* **ipxe:** implement github actions workflow to compile cross-arch efi binaries with embedded scripts ([7513fe7](https://github.com/snowdreamtech/UniBoot/commit/7513fe7ce028fe0cf992d84e9359d8e026c5d6f3))
* **ipxe:** load brand background image in uniboot.ipxe for visual alignment with Ventoy ([fd38b02](https://github.com/snowdreamtech/UniBoot/commit/fd38b029de0a004692a8f1b67fb19806793517c0))
* **menu:** replace uniboot.ipxe with official netboot.xyz menu for deep customization ([480909d](https://github.com/snowdreamtech/UniBoot/commit/480909d3fae6732c1682881d43dfff97b16f544a))
* **netboot:** add ARM64 UEFI compatibility and dynamic GRUB detection ([b725078](https://github.com/snowdreamtech/UniBoot/commit/b725078c449ae2ae6feb9a58d526dc2408b7e7da))
* **netboot:** add cross-platform UniBoot Hybrid ISO generator (BIOS/UEFI dual boot) ([45b5b4b](https://github.com/snowdreamtech/UniBoot/commit/45b5b4ba7ea31e5885aa39ffe3e893bc343150da))
* **netboot:** add RISC-V lkrn payload support for non-EFI environments ([f878cd4](https://github.com/snowdreamtech/UniBoot/commit/f878cd42e727079b1bae21a2af884531816c36ec))
* **netboot:** add universal omni-architecture support for all EFI platforms ([ffa4ed7](https://github.com/snowdreamtech/UniBoot/commit/ffa4ed71d942fabfb4244fafd0cd3b5ff1a12087))
* **netboot:** adopt vanilla iPXE with uniboot.ipxe external hook ([39b883d](https://github.com/snowdreamtech/UniBoot/commit/39b883d1e9b8a0cad0dbe9e4a5ceb1f3f5e3f43b))
* **scripts:** add automated cross-platform QEMU test runner suite ([65f5226](https://github.com/snowdreamtech/UniBoot/commit/65f52265c0821c6871b545c8e9b925b08df8ea63))
* **scripts:** add fullscreen parameter support to launch QEMU in full screen ([dcf0443](https://github.com/snowdreamtech/UniBoot/commit/dcf0443d8aa93ef16b61ee2301373ae18fcd66b8))
* **scripts:** add make_ventoy_theme.py generator script for automated theme asset creation ([68611e6](https://github.com/snowdreamtech/UniBoot/commit/68611e6450f352a87bf391f0363fd4c1820167d0))
* **scripts:** support multi-language slogans in make_ventoy_theme.py generator ([3af65b2](https://github.com/snowdreamtech/UniBoot/commit/3af65b25403910064c6b7479b0e137fb49484098))
* **ventoy:** design official proprietary UniBoot Ventoy theme and configure in ventoy.json ([f92d528](https://github.com/snowdreamtech/UniBoot/commit/f92d5283335ae9a58a854ed4d386849a55876972))
* **ventoy:** hide .efi files on first screen to improve UX ([ac15526](https://github.com/snowdreamtech/UniBoot/commit/ac1552689c5a85068f1f09b33578817bcd71262d))
* **ventoy:** set /iso/UniBoot.iso as default image in ventoy.json ([d32554f](https://github.com/snowdreamtech/UniBoot/commit/d32554f023808f95c4490e7a8b2bb77687a0be23))


### 🐛 Bug Fixes

* **build:** add cloud fallback mechanism if uniboot.ipxe is missing or deleted ([c992a86](https://github.com/snowdreamtech/UniBoot/commit/c992a861ceb86f453c1b893e4580c39895a05611))
* **ipxe:** correct embed script comments to reflect uefi local access limitations ([184f24d](https://github.com/snowdreamtech/UniBoot/commit/184f24d3179bf5ad11557634e278c2213c6c4451))
* **ipxe:** use GRUB to detect local uniboot.ipxe directly to bypass iPXE fs limitations ([f78160e](https://github.com/snowdreamtech/UniBoot/commit/f78160e1fd7d0eeb5c0ace517a96a7eb3f67b9d8))
* **iso:** correct mformat arguments for 16MB FAT image ([ed23789](https://github.com/snowdreamtech/UniBoot/commit/ed2378963c8ebc67750167f88d9feeeae17da347))
* **iso:** structure ISO staging path under /ipxe/ and add i18n warnings ([651239a](https://github.com/snowdreamtech/UniBoot/commit/651239a16ca10be2cf78ef081b223e1b5c789480))
* **netboot:** rename exit option to clarify returning to Ventoy ([9107b1d](https://github.com/snowdreamtech/UniBoot/commit/9107b1d7752a47fa4287b0f39900c6354d5becac))
* **release:** disable Go binary compilation in GoReleaser for pure asset publishing ([472599a](https://github.com/snowdreamtech/UniBoot/commit/472599a4b7ef7ebeedcd4ae91101069a95eae7c2))
* remove non-image binaries from ventoy.json image_list plugin ([e94a17c](https://github.com/snowdreamtech/UniBoot/commit/e94a17c327fd45dc8b45179235537cd6e2d42825))
* **scripts:** add --delete flag to sync script, include iso dir, and refine conditionals ([5b10f94](https://github.com/snowdreamtech/UniBoot/commit/5b10f94cdfcf68b70b48f4eb46111e653a4fc803))
* **scripts:** clean up unused variables and stage uniboot.ipxe in efiboot.img ([4aa39d1](https://github.com/snowdreamtech/UniBoot/commit/4aa39d1556ccfde48d3bc49588d3ea603dd11376))
* **scripts:** enhance cross-platform compatibility and auto tool verification across macOS, Linux, and Windows ([898f09b](https://github.com/snowdreamtech/UniBoot/commit/898f09b5a6ecf5cb3baae5e1cf731279cbdb0677))
* **scripts:** optimize macOS disk remount in test scripts to target data partition directly ([9dd1b0c](https://github.com/snowdreamtech/UniBoot/commit/9dd1b0c26aeb334797c60d2e49b487458d5ef60a))
* **scripts:** sync assets directory to USB volume to ensure README logo renders ([33c9005](https://github.com/snowdreamtech/UniBoot/commit/33c90056bd21ea5bed53ffa1ca864c8197caeada))
* set root to vtoy_iso_part in custom grub menu for netboot entries ([96ccec1](https://github.com/snowdreamtech/UniBoot/commit/96ccec1d7f1f8eb6fd4c66d361f967821be4c6b8))
* **theme:** restore integer pixel coordinates and single gfxmode to fix GRUB2 unaligned pointer crash ([1255c5f](https://github.com/snowdreamtech/UniBoot/commit/1255c5f6f9acbbb91d960b84528d92fd9e969316))
* **theme:** use full-screen dark transition mode [#070](https://github.com/snowdreamtech/UniBoot/issues/070)A12 to eliminate black popup flicker ([f609a01](https://github.com/snowdreamtech/UniBoot/commit/f609a015df9dccdccb5fdca47df6e872678e0d6b))
* **ventoy:** eliminate black box screen flicker during menu transition ([888c7af](https://github.com/snowdreamtech/UniBoot/commit/888c7aff59c81717fcb3ec42ea29135b88cbcde5))
* **ventoy:** set default gfxmode to 1280x800 for high resolution rendering ([3966b16](https://github.com/snowdreamtech/UniBoot/commit/3966b160a620f312a14b6aa36f2c913f27c1b280))
* **ventoy:** sync clean control settings and safe inline path grub menu ([ffe83bd](https://github.com/snowdreamtech/UniBoot/commit/ffe83bdb2d32f5b29110ed10a3d68550b0e7f3d0))
* **workflow:** fix YAML heredoc indentation in build-ipxe.yml using sed strip ([d3dd49f](https://github.com/snowdreamtech/UniBoot/commit/d3dd49fb2b71409ef9b89c6693bfa8bd92add9c6))


### 🛠 Refactoring

* **core:** rename netboot directory to ipxe to reflect new standalone architecture ([cb04148](https://github.com/snowdreamtech/UniBoot/commit/cb04148a6b2b2c4e8d978b46bf8955a4ddefbd6d))
* **grub:** enhance custom menu with video drivers, i18n, and dynamic search ([ad9594f](https://github.com/snowdreamtech/UniBoot/commit/ad9594f8cd093d4b502a8a6ee001a7f53dc9fc7c))
* **ipxe:** merge embed.ipxe into boot.ipxe to eliminate redundant code ([9e7b9e0](https://github.com/snowdreamtech/UniBoot/commit/9e7b9e01ca434ba047605fbf8af0ff0f2ca0d727))
* move test scripts, add i18n support, and remove obsolete files ([a9b432a](https://github.com/snowdreamtech/UniBoot/commit/a9b432ad969c953b7a264f50b49e67a8f7f72734))


### 📖 Documentation

* **agents:** add design and asset alignment policy to AGENTS.md ([37f388e](https://github.com/snowdreamtech/UniBoot/commit/37f388e7376296bec534488292c6fb34ff983e46))
* **agents:** add Git Commit Cleanliness Policy - use reset over revert ([45ede5d](https://github.com/snowdreamtech/UniBoot/commit/45ede5d3a57865fa6281d1d3330f1c6c02ba75d7))
* **agents:** add workspace rules for atomic execution, commit policy, and shell script quality ([b73bccd](https://github.com/snowdreamtech/UniBoot/commit/b73bccd89b3b215be9d3c4b8243e8dfcce1c99d2))
* align ISO search directory path in architecture documentation ([ff28664](https://github.com/snowdreamtech/UniBoot/commit/ff28664f895de9c0050d256676cf0089c0d1101f))
* **brand:** design UniBoot logo assets, banner, and integrate into README ([251eaae](https://github.com/snowdreamtech/UniBoot/commit/251eaaeba26db3f46c0c8ad5719b83868cb8b3e3))
* **license:** update project documentation and license to GPL-2.0 ([ae9a547](https://github.com/snowdreamtech/UniBoot/commit/ae9a54790f6923cbbe29e83782e3aced56b0f5c7))
* **readme:** add acknowledgements section for ventoy, ipxe, and netboot.xyz ([8fb68f2](https://github.com/snowdreamtech/UniBoot/commit/8fb68f297eb21dfa96c1382e79bd1d6ba277ef24))
* **release:** add CHANGELOG.md for v1.0.0 release ([f916591](https://github.com/snowdreamtech/UniBoot/commit/f916591f78bb9fdff8c811ffc4be80f510a7c937))


### ♻️ Miscellaneous Chores

* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([40261e4](https://github.com/snowdreamtech/UniBoot/commit/40261e4aacb246586942f846b739727c8b73b74e))
* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([ec45147](https://github.com/snowdreamtech/UniBoot/commit/ec451478b7cc3205cb13f602556203b860411070))
* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([647741c](https://github.com/snowdreamtech/UniBoot/commit/647741cccb937ffe2e7a44bdcf2bb7d6b03750de))
* **ipxe:** auto-compile lkrn and multi-arch EFI binaries with embedded script ([83eaeaa](https://github.com/snowdreamtech/UniBoot/commit/83eaeaa4cc71867140665815ddf2d24954b4722e))
* **ipxe:** update compiled lkrn and multi-arch EFI binaries with full HTTPS support ([a3372c9](https://github.com/snowdreamtech/UniBoot/commit/a3372c960326f2030e1fab5d0a71077125fefe41))
* **qemu:** change default fullscreen mode to off for better developer experience ([fda7716](https://github.com/snowdreamtech/UniBoot/commit/fda7716be5ca03ecebd2ce5ef22d6a3431e58afc))
* **test:** integrate automatic Hybrid ISO generation into sync-and-test flow ([5ee50f3](https://github.com/snowdreamtech/UniBoot/commit/5ee50f31c6128bee1f5181c00f681e53f2e0e0c2))
* **ventoy:** rename menu labels to UniBoot Network Installation ([ddb7af1](https://github.com/snowdreamtech/UniBoot/commit/ddb7af15acd3adc45f26979ee8ecbbb239682adf))

## Changelog
