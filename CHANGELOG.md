# Changelog

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
