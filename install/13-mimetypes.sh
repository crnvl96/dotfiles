# Configures default applications for common file types.

msg "Updating desktop database for MIME types..."
mkdir -p ~/.local/share/applications
update-desktop-database ~/.local/share/applications

msg "Setting default applications..."
# Open all images with imv
xdg-mime default imv.desktop image/png image/jpeg image/gif image/webp image/bmp image/tiff

# Open PDFs with the Document Viewer
xdg-mime default org.gnome.Evince.desktop application/pdf

# Open video files with VLC
xdg-mime default vlc.desktop video/mp4 video/x-msvideo video/x-matroska video/x-flv video/x-ms-wmv video/mpeg video/ogg video/webm video/quicktime video/3gpp video/3gpp2 video/x-ms-asf "video/x-ogm+ogg" "video/x-theora+ogg" application/ogg
