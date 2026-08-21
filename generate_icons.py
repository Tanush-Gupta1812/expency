import os
from PIL import Image, ImageDraw

def create_expency_icon(size):
    # Create image with transparent or black background
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 1. Background rounded rectangle / circle in Obsidian Black with Cyan border
    corner_radius = int(size * 0.22)
    # Background
    draw.rounded_rectangle([(0, 0), (size, size)], radius=corner_radius, fill=(0, 0, 0, 255))
    
    # 1px border with cyan tint
    border_w = max(1, int(size * 0.025))
    draw.rounded_rectangle(
        [(border_w, border_w), (size - border_w, size - border_w)], 
        radius=corner_radius, 
        outline=(0, 219, 233, 110), 
        width=border_w
    )

    # 2. Geometric Neon E in Cyan #00DBE9
    cyan = (0, 219, 233, 255)
    green = (0, 255, 0, 255)

    left = int(size * 0.24)
    right = int(size * 0.76)
    top = int(size * 0.24)
    bottom = int(size * 0.76)
    bar_thick = int(size * 0.12)

    # Top horizontal bar
    draw.rectangle([(left, top), (right, top + bar_thick)], fill=cyan)
    # Vertical spine
    draw.rectangle([(left, top), (left + bar_thick, bottom)], fill=cyan)
    # Middle horizontal bar
    mid_top = int(size * 0.44)
    draw.rectangle([(left, mid_top), (int(size * 0.65), mid_top + bar_thick)], fill=cyan)
    # Bottom horizontal bar
    draw.rectangle([(left, bottom - bar_thick), (right, bottom)], fill=cyan)

    # 3. Electric Lime Green Dot #00FF00
    dot_x = int(size * 0.76)
    dot_y = int(size * 0.50)
    dot_r = int(size * 0.055)
    draw.ellipse([(dot_x - dot_r, dot_y - dot_r), (dot_x + dot_r, dot_y + dot_r)], fill=green)

    return img

sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

base_res = r"c:\Users\gupta\Documents\Development\expency\android\app\src\main\res"

for folder, s in sizes.items():
    folder_path = os.path.join(base_res, folder)
    os.makedirs(folder_path, exist_ok=True)
    icon = create_expency_icon(s)
    out_path = os.path.join(folder_path, "ic_launcher.png")
    icon.save(out_path, "PNG")
    print(f"Generated {out_path} ({s}x{s})")

# Also save high-res 512x512 logo into assets
assets_dir = r"c:\Users\gupta\Documents\Development\expency\assets"
os.makedirs(assets_dir, exist_ok=True)
logo_512 = create_expency_icon(512)
logo_512.save(os.path.join(assets_dir, "logo.png"), "PNG")
print("Updated assets/logo.png (512x512)")
