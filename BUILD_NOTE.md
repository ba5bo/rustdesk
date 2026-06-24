# RustDesk Flutter Windows 构建笔记

## 环境

| 项目 | 值 |
|------|-----|
| OS | Windows 25H2 |
| VS | Visual Studio 2026 (v18) Professional |
| MSVC | 14.50.35717 |
| Flutter | 3.27.4 (Dart 3.6.2) |
| Rust | 1.96.0 |
| CMake | VS 2026 内置 |

> 注意：本机没有 Visual Studio 2019/2022，只有 VS 2026。

## 已解决的问题

### 1. VS 2026 兼容（Flutter SDK 补丁）

**文件：** `C:\Users\mr\flutter\packages\flutter_tools\lib\src\windows\visual_studio.dart`

Flutter 3.27.4 内置的 VS 检测逻辑不认识 VS 2026（版本号 18），做了两处修改：

#### 补丁 A：CMake 生成器映射（line ~184）
```dart
return switch (_majorVersion) {
    17 => 'Visual Studio 17 2022',
    18 => 'Visual Studio 18 2026',  // 新增
    _  => 'Visual Studio 16 2019',
};
```

#### 补丁 B：vswhere 版本范围（line ~444）
```dart
// 原：'[17,18)' → 不包含 v18，Phase 1 搜不到
// 改：'[17,19)' → 包含 v18，Phase 1 能搜到 VS 2026
// 脚本 flutter/patch_vs.ps1 默认使用 [16,18)
// 本机实际使用 [17,19)（因为只有 VS 2026）
```

#### 清除 Flutter 工具快照
修改源码后需删除预编译快照强制重新编译：
```
del %USERPROFILE%\flutter\bin\cache\flutter_tools.snapshot
del %USERPROFILE%\flutter\bin\cache\flutter_tools.stamp
```

### 2. librustdesk.dll 正确编译

**根因：** 首次 `cargo build --lib` 未加 `--features flutter`，
`src/lib.rs` 中 bridge/flutter 模块都是条件编译（`#[cfg(feature = "flutter")]`），
导致 DLL 只导出 2 个函数，Flutter 主程序加载时报 `0xC0000142`。

**修复：**
```powershell
cargo build --lib --features flutter
```
编译后 DLL 导出 351 个函数（含 `rustdesk_core_main_args` 和所有 `wire_*`）。

### 3. 构建产物

```
flutter\build\windows\x64\runner\Debug\
├── rustdesk.exe          (3.1 MB)  - 主程序
├── librustdesk.dll       (67 MB)   - Rust 桥接库（debug）
├── flutter_windows.dll   (45 MB)   - Flutter 引擎
├── desktop_drop_plugin.dll         - 拖放插件
├── desktop_multi_window_plugin.dll - 多窗口插件
├── file_selector_windows_plugin.dll
├── window_manager_plugin.dll
├── url_launcher_windows_plugin.dll
└── ...其他插件 DLL
```

### 4. 构建辅助脚本

| 脚本 | 用途 |
|------|------|
| `flutter/build_win_debug.bat` | 一键 Flutter debug 构建（清理→pub get→编译） |
| `flutter/build_debug.ps1` | 同上（PowerShell 版，支持 Dart 源码模式） |
| `build_dll_debug.cmd` / `.ps1` | 仅编译 librustdesk.dll（--features flutter） |
| `flutter/gen_bridge_run.bat` / `.ps1` | 重新生成 flutter_rust_bridge 绑定代码 |
| `flutter/patch_vs.ps1` | VS 2026 兼容补丁脚本 |

## 完整构建流程

```powershell
# 1. 安装/切换 Flutter 3.27.4
git checkout 3.27.4

# 2. 打 VS 2026 补丁
.\flutter\patch_vs.ps1

# 3. 编译 Rust 库（必须带 flutter feature）
cargo build --lib --features flutter

# 4. 生成 bridge 代码（如 Rust FFI 接口有变动）
flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart

# 5. Flutter 构建
cd flutter
flutter build windows --debug

# 6. 复制 DLL
copy /y ..\target\debug\librustdesk.dll build\windows\x64\runner\Debug\
```

或一键运行：
```
flutter\build_win_debug.bat
```

## 注意事项

- **必须**带 `--features flutter` 编译 Rust，否则 bridge 代码不编译
- Flutter SDK 补丁**不在**本仓库内，需手动运行 `patch_vs.ps1`
- 修改 `visual_studio.dart` 后**必须**删除 `flutter_tools.snapshot` 缓存
- 本仓库是个人分支 `ba5bo-mr`，非上游 rustdesk 官方
