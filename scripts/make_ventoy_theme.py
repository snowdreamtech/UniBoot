#!/usr/bin/env python3
# ==============================================================================
# UniBoot Ventoy Theme Asset Generator
# Generates background.png and highlight bar PNG assets from official brand logo
# Supports multi-language slogan generation (e.g. --lang en / --lang zh)
# Copyright (c) 2026-present SnowdreamTech Inc. All rights reserved.
# ==============================================================================

import argparse
import os
import sys
from PIL import Image, ImageDraw, ImageFont, ImageFilter

SLOGANS = {
    "en": "A Unified Boot Execution Platform",
    "zh": "统一启动执行平台",
    "zh_cn": "统一启动执行平台",
    "zh-cn": "统一启动执行平台",
}

script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(script_dir, ".."))
default_theme_dir = os.path.join(project_root, "ventoy", "themes", "uniboot")
assets_icon_path = os.path.join(project_root, "assets", "logo-icon.png")

def parse_args():
    parser = argparse.ArgumentParser(description="UniBoot Ventoy Theme Asset Generator")
    parser.add_argument("--lang", default="en", help="Language code for slogan (default: en, options: en, zh)")
    parser.add_argument("--slogan", default=None, help="Custom slogan text (overrides --lang)")
    parser.add_argument("--out-dir", default=default_theme_dir, help=f"Target theme directory (default: {default_theme_dir})")
    return parser.parse_args()

def load_font(size, is_cjk=False):
    cjk_fonts = [
        "/System/Library/Fonts/PingFang.ttc",
        "/System/Library/Fonts/STHeiti Light.ttc",
        "/System/Library/Fonts/Hiragino Sans GB.ttc",
        "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
        "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc",
    ]
    latin_fonts = [
        "/System/Library/Fonts/Helvetica.ttc",
        "/System/Library/Fonts/Arial.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    
    candidates = (cjk_fonts if is_cjk else latin_fonts) + cjk_fonts + latin_fonts
    for font_path in candidates:
        if os.path.exists(font_path):
            try:
                return ImageFont.truetype(font_path, size)
            except Exception:
                continue
    return ImageFont.load_default()

def main():
    args = parse_args()
    lang_key = args.lang.lower()
    slogan_text = args.slogan if args.slogan else SLOGANS.get(lang_key, SLOGANS["en"])
    is_cjk = any(key in lang_key for key in ["zh", "cn", "ja", "ko"]) or any('\u4e00' <= char <= '\u9fff' for char in slogan_text)
    
    theme_dir = os.path.abspath(args.out_dir)
    os.makedirs(theme_dir, exist_ok=True)

    width, height = 1280, 800

    # 1. Base dark Canvas (#070A12)
    bg = Image.new("RGBA", (width, height), (7, 10, 18, 255))

    # Create smooth Gaussian-blurred ambient glow layer
    glow_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)

    # Draw soft cyan (top-left) & purple (bottom-right) ambient glow shapes
    glow_draw.ellipse([-100, -100, 500, 500], fill=(0, 229, 255, 70))
    glow_draw.ellipse([780, 380, 1380, 980], fill=(124, 77, 255, 70))

    # Apply ultra-soft Gaussian Blur
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=120))
    bg = Image.alpha_composite(bg, glow_layer)
    draw = ImageDraw.Draw(bg)

    # Top Header Bar (height 80)
    draw.rectangle([0, 0, width, 80], fill=(15, 23, 42, 245))
    draw.line([0, 80, width, 80], fill=(0, 229, 255, 180), width=2)

    # Load fonts
    font_title = load_font(25, is_cjk=False)
    font_sub = load_font(13, is_cjk=is_cjk)

    # Option 1: Two-line Stacked Left-Aligned Header
    # Logo Icon (52x52) at x = 35, y = 14
    if os.path.exists(assets_icon_path):
        icon = Image.open(assets_icon_path).convert("RGBA")
        icon = icon.resize((52, 52), Image.Resampling.LANCZOS)
        bg.paste(icon, (35, 14), icon)

    # Line 1: UniBoot Title at x = 100, y = 16
    draw.text((100, 16), "UniBoot", fill=(255, 255, 255, 255), font=font_title)

    # Line 2: Slogan at x = 100, y = 46
    draw.text((100, 46), slogan_text, fill=(0, 229, 255, 220), font=font_sub)

    # Deep high-contrast menu card container
    # Canvas: 1280x800 -> [104, 128, 1176, 688]
    # Aligns 1:1 with theme.txt integer percentage positioning: left=10%, top=18%, width=80%, height=66%
    draw.rectangle([104, 128, 1176, 688], fill=(15, 23, 42, 245), outline=(51, 65, 85, 220), width=1)

    # Footer Bar (height 48)
    draw.rectangle([0, height - 48, width, height], fill=(15, 23, 42, 255))
    draw.line([0, height - 48, width, height - 48], fill=(124, 77, 255, 150), width=1)

    # RIGHT-ALIGNED Copyright text on bottom right
    footer_text = "© SnowdreamTech Inc. All rights reserved."
    font_footer = load_font(13, is_cjk=False)
    draw.text((width - 340, height - 32), footer_text, fill=(148, 163, 184, 255), font=font_footer)

    bg_path = os.path.join(theme_dir, "background.png")
    bg.save(bg_path)

    # 2. Generate Highlight Bar
    bar_w, bar_h = 1040, 44
    bar = Image.new("RGBA", (bar_w, bar_h), (30, 41, 59, 240))
    bar_draw = ImageDraw.Draw(bar)
    bar_draw.rectangle([0, 0, 6, bar_h - 1], fill=(0, 229, 255, 255))
    bar_draw.rectangle([0, 0, bar_w - 1, bar_h - 1], outline=(0, 229, 255, 180), width=1)
    bar.save(os.path.join(theme_dir, "select_c.png"))

    cap_w = 2
    cap = Image.new("RGBA", (cap_w, bar_h), (0, 229, 255, 255))
    cap.save(os.path.join(theme_dir, "select_w.png"))
    cap.save(os.path.join(theme_dir, "select_e.png"))

    print(f"UniBoot Ventoy theme assets successfully generated (language: {lang_key}, slogan: '{slogan_text}') in: {theme_dir}")

if __name__ == "__main__":
    main()
