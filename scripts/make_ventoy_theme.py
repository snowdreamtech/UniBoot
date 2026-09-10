#!/usr/bin/env python3
# ==============================================================================
# UniBoot Ventoy Theme Asset Generator
# Generates background.png and highlight bar PNG assets from official brand logo
# Copyright (c) 2026-present SnowdreamTech Inc. All rights reserved.
# ==============================================================================

import os
import sys
from PIL import Image, ImageDraw, ImageFont, ImageFilter

script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(script_dir, ".."))
theme_dir = os.path.join(project_root, "ventoy", "themes", "uniboot")
assets_icon_path = os.path.join(project_root, "assets", "logo-icon.png")

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
try:
    font_title = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 25)
    font_sub = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 13)
except Exception:
    font_title = font_sub = ImageFont.load_default()

# Option 1: Two-line Stacked Left-Aligned Header
# Logo Icon (52x52) at x = 35, y = 14
if os.path.exists(assets_icon_path):
    icon = Image.open(assets_icon_path).convert("RGBA")
    icon = icon.resize((52, 52), Image.Resampling.LANCZOS)
    bg.paste(icon, (35, 14), icon)

# Line 1: UniBoot Title at x = 100, y = 16
draw.text((100, 16), "UniBoot", fill=(255, 255, 255, 255), font=font_title)

# Line 2: Slogan at x = 100, y = 46
draw.text((100, 46), "A Unified Boot Execution Platform", fill=(0, 229, 255, 220), font=font_sub)

# Deep high-contrast menu card container
draw.rectangle([100, 120, 1180, 700], fill=(15, 23, 42, 245), outline=(51, 65, 85, 220), width=1)

# Footer Bar (height 48)
draw.rectangle([0, height - 48, width, height], fill=(15, 23, 42, 255))
draw.line([0, height - 48, width, height - 48], fill=(124, 77, 255, 150), width=1)

# RIGHT-ALIGNED Copyright text on bottom right
footer_text = "© SnowdreamTech Inc. All rights reserved."
draw.text((width - 340, height - 32), footer_text, fill=(148, 163, 184, 255), font=font_sub)

bg.save(os.path.join(theme_dir, "background.png"))

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

print(f"UniBoot Ventoy theme assets successfully generated in: {theme_dir}")
